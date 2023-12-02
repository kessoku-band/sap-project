//
//  ServerEditor.swift
//  sap-project
//
//  Created by Brandon Li on 29/11/23.
//

import SwiftUI
import SwiftData
import KeychainAccess

struct ServerEditor: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	@Query var keys: [PrivateKey]
	
	let server: Server?
	@State private var prevAuthMethod: AuthMethod = AuthMethod.privateKey
	
	@Binding var servers: [Server]
	
	let keychain = Keychain(service: "com.simonfalke.passwords")
	
	@State private var portColor: Color = Color(UIColor.label)
	@State private var connectionResult: ConnectionTest = ConnectionTest.untested
	
	@State private var name: String = ""
	
	@State private var hostname: String = ""
	@State private var port: String = ""
	
	@State private var username: String = ""
	@State private var selectedAuthMethod: AuthMethod = AuthMethod.password
	@State private var selectedKeys: Set<UUID> = []
	@State private var password: String = ""
	
	@ObservedObject var connectionTestHandler = ConnectionTestHandler()
	
	@State private var editing = false
	
	var body: some View {
		NavigationStack {
			VStack {
				Form {
					Section("Info") {
						LabeledContent("Name") {
							SpecialTextField("Required", text: $name)
								.multilineTextAlignment(.trailing)
						}
					}
					
					Section(header: Text("Connection"), footer: Text("Port must be within the range of 1-65535. The default is port 22.")) {
						LabeledContent("Hostname") {
							SpecialTextField("Required", text: $hostname)
								.multilineTextAlignment(.trailing)
						}
						
						LabeledContent {
							SpecialTextField("Required", text: $port)
								.multilineTextAlignment(.trailing)
								.onChange(of: port) { oldValue, newValue in
									if newValue == "" {
										return
									}
									if !newValue.isNumber || Int(newValue) ?? 0 > 65535 || Int(newValue) ?? 0 < 1 {
										port = oldValue
									}
								}
						} label: {
							Text("Port")
								.foregroundStyle(portColor)
						}
					}
					
					Section(header: Text("Authentication"), footer: Text("All credentials will be stored securely in the device Keychain.")) {
						LabeledContent("Username") {
							SpecialTextField("Required", text: $username)
								.multilineTextAlignment(.trailing)
						}
						
						Picker("Method", selection: $selectedAuthMethod) {
							ForEach([AuthMethod.password], id: \.self) {
								Text($0.description)
									.tag($0)
							}
						}
						
						switch selectedAuthMethod {
						case .privateKey:
							NavigationLink("Select Private Key") {
								PrivateKeySelectionView(selectedKeys: $selectedKeys)
							}
						case .password:
							LabeledContent("Password") {
								SecureField("Required", text: $password)
									.multilineTextAlignment(.trailing)
							}
						}
					}
					
					Section {
						Button {
							switch selectedAuthMethod {
							case .privateKey:
								let newServer = Server(
									name: name,
									hostname: hostname,
									port: Int(port) ?? 22,
									username: username,
									authMethod: selectedAuthMethod,
									keyIDs: selectedKeys
								)
								
								connectionResult = ConnectionTest.testing
								Task {
									await connectionResult = connectionTestHandler.verifyConnection(server: newServer, keys: keys)
								}
							case .password:
								let newPassword = Password()
								keychain[newPassword.id.uuidString] = password
								
								let newServer = Server(
									name: name,
									hostname: hostname,
									port: Int(port) ?? 22,
									username: username,
									authMethod: selectedAuthMethod,
									passwordID: newPassword.id
								)
								
								connectionResult = ConnectionTest.testing
								
								print(newPassword.id.uuidString as Any)

								Task {
									await connectionResult = connectionTestHandler.verifyConnection(server: newServer)
								}
								
								print(connectionTestHandler.tryingText)
							}
						} label: {
							Text("Test Connection")
						}
					} footer: {
						switch connectionResult {
						case ConnectionTest.untested:
							Text("")
						case ConnectionTest.testing:
							HStack{
								ProgressView()
								Text(connectionTestHandler.tryingText)
							}
						case ConnectionTest.success:
							Text("Connection succeeded.")
								.foregroundStyle(Color.green)
						case ConnectionTest.failed:
							Text("Connection failed.")
								.foregroundStyle(Color.red)
						}
					}
				}
			}
			.navigationTitle("New Server")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if !editing {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel", role: .cancel) {
							dismiss()
						}
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("Done") {
						save()
						dismiss()
					}
					.disabled(name.isEmpty || hostname.isEmpty || port.isEmpty || username.isEmpty || selectedKeys.isEmpty && password.isEmpty)
				}
			}
			.onAppear {
				if let server {
					switch server.authMethod {
					case .privateKey:
						selectedKeys = server.keyIDs ?? []
						prevAuthMethod = AuthMethod.privateKey
					case .password:
						password = keychain[server.passwordID?.uuidString ?? ""] ?? ""
						prevAuthMethod = AuthMethod.password
					}
					
					name = server.name
					hostname = server.hostname
					port = String(server.port)
					username = server.username
					selectedAuthMethod = server.authMethod
					
					editing = true
				}
			}
		}
	}
	
	private func save() {
		if let server {
			switch selectedAuthMethod {
			case .privateKey:
				switch prevAuthMethod {
				case .privateKey:
					for key in keys.filter({ key in server.keyIDs?.contains(key.id) ?? false }) {
						key.serversUsing.remove(server.id)
					}
				case .password:
					keychain[server.passwordID?.uuidString ?? ""] = nil
					server.passwordID = nil
				}
				
				server.keyIDs = selectedKeys
				for key in keys.filter({ key in server.keyIDs?.contains(key.id) ?? false }) {
					key.serversUsing.insert(server.id)
				}
			case .password:
				switch prevAuthMethod {
				case .privateKey:
					let newPassword = Password()
					keychain[newPassword.id.uuidString] = password
					
					for key in keys.filter({ key in server.keyIDs?.contains(key.id) ?? false }) {
						key.serversUsing.remove(server.id)
					}
					server.keyIDs = nil
				case .password:
					keychain[server.passwordID?.uuidString ?? ""] = password
				}
			}
			
			server.name = name
			server.hostname = hostname
			server.port = Int(port) ?? 22
			server.username = username
			server.authMethod = selectedAuthMethod
		} else {
			switch selectedAuthMethod {
			case .privateKey:
				let newServer = Server(
					name: name,
					hostname: hostname,
					port: Int(port) ?? 22,
					username: username,
					authMethod: selectedAuthMethod,
					keyIDs: selectedKeys
				)
				
				for key in keys.filter({ key in newServer.keyIDs?.contains(key.id) ?? false }) {
					key.serversUsing.insert(newServer.id)
				}
				
				modelContext.insert(newServer)
				servers.append(newServer)
			case .password:
				let newPassword = Password()
				keychain[newPassword.id.uuidString] = password
				
				let newServer = Server(
					name: name,
					hostname: hostname,
					port: Int(port) ?? 22,
					username: username,
					authMethod: selectedAuthMethod,
					passwordID: newPassword.id
				)
				
				modelContext.insert(newServer)
				servers.append(newServer)
			}
		}
	}
}


#Preview {
	ServerEditor(server: nil, servers: .constant([]))
}
