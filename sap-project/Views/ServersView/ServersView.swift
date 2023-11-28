//
//  ServersView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData
import KeychainAccess

struct ServerEditor: View {
	@Environment(\.dismiss) var dismiss
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
							Task {
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
									await connectionResult = connectionTestHandler.verifyConnection(server: newServer, keys: keys)
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
									await connectionResult = connectionTestHandler.verifyConnection(server: newServer)
									keychain[newPassword.id.uuidString] = nil
								}
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
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel", role: .cancel) {
						dismiss()
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
					
					hostname = server.hostname
					port = String(server.port)
					username = server.username
					selectedAuthMethod = server.authMethod
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

struct ServersView: View {
	@Environment(\.modelContext) private var modelContext
	
	@Query var fetchedServers: [Server]
	@Query var keys: [PrivateKey]
	
	@State private var servers: [Server] = []
	@State private var showNewServerSheet = false
	
	var body: some View {
		NavigationStack {
   
			NoItemsView(enabled: servers.isEmpty, name: "Configured Servers")
			
			List {
				ForEach($servers) { $server in
					NavigationLink(server.name) {
                        ServerView(server: $server)
					}
				}
				.onDelete(perform: onDelete)
			}
			.navigationTitle("Servers")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					EditButton()
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showNewServerSheet.toggle()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $showNewServerSheet) {
				ServerEditor(server: nil, servers: $servers)
			}
			.onAppear {
				servers = fetchedServers
			}
		}
	}
	
	private func onDelete(at offsets: IndexSet) {
		for index in offsets {
			for key in keys.filter({ key in servers[index].keyIDs?.contains(key.id) ?? false }) {
				key.serversUsing.remove(servers[index].id)
			}
			modelContext.delete(servers[index])
			servers.remove(at: index)
		}
	}
	
	private func onMove(source: IndexSet, destination: Int) {
		servers.move(fromOffsets: source, toOffset: destination)
	}
}

#Preview {
	ServersView()
}
