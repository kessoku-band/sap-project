//
//  ServersView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData

struct NewServerView: View {
	@Environment(\.dismiss) var dismiss
	
	@State private var portColor: Color = Color(UIColor.label)
	@State private var connectionResult: ConnectionTest = ConnectionTest.untested
	
	@State private var hostname: String = ""
	@State private var port: String = ""
	
	@State private var username: String = ""
	let authMethods: [String] = ["Private Key", "Password"]
	@State private var selectedAuthMethod = "Private Key"
	@State private var selectedKeys: Set<UUID> = []
	@State private var password: String = ""
	
	var body: some View {
		NavigationStack {
			VStack {
				Form {
					Section(header: Text("Connection"), footer: Text("Port must be within the range of 1-65535. The default is port 22.")) {
						LabeledContent("Hostname") {
							TextField("Required", text: $hostname)
								.multilineTextAlignment(.trailing)
						}
						
						LabeledContent {
							TextField("Required", text: $port)
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
							TextField("Required", text: $username)
								.multilineTextAlignment(.trailing)
						}
						
						Picker("Method", selection: $selectedAuthMethod) {
							ForEach(authMethods, id: \.self) {
								Text($0)
							}
						}
						
						if selectedAuthMethod == "Private Key" {
							NavigationLink("Select Private Key") {
								PrivateKeySelectionView(selectedKeys: $selectedKeys)
							}
						}
						
						if selectedAuthMethod == "Password" {
							LabeledContent("Password") {
								SecureField("Required", text: $password)
									.multilineTextAlignment(.trailing)
							}
						}
					}
					
					Section {
						Button {
							connectionResult = VerifyConnection()
						} label: {
							Text("Test Connection")
						}
					} footer: {
						switch connectionResult {
						case ConnectionTest.untested:
							Text("")
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
						dismiss()
					}
				}
			}
		}
	}
}

struct ServersView: View {
	@Query var servers: [Server]
	
	@State private var showNewServerSheet = false
	
	var body: some View {
		NavigationStack {
			NoItemsView(enabled: servers.isEmpty, name: "Configured Servers")
			
			List(servers) { server in
				
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
				NewServerView()
			}
		}
	}
}

#Preview {
	ServersView()
}
