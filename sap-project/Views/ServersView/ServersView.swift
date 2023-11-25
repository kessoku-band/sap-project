//
//  ServersView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData

private struct StateObjectData {
	var portColor: Color
	var showNewServerSheet: Bool
	var connectionResult: ConnectionTest
	
	var hostname: String
	var port: String
	var username: String
	var selectedAuthMethod: String
	var selectedKeys: Set<UUID>
	var password: String
	
	init(portColor: Color, showNewServerSheet: Bool, connectionResult: ConnectionTest, hostname: String, port: String, username: String, selectedAuthMethod: String = "Private Key", selectedKeys: Set<UUID>, password: String) {
		self.portColor = portColor
		self.showNewServerSheet = showNewServerSheet
		self.connectionResult = connectionResult
		self.hostname = hostname
		self.port = port
		self.username = username
		self.selectedAuthMethod = selectedAuthMethod
		self.selectedKeys = selectedKeys
		self.password = password
	}
}

private func ResetStateObjectData() -> StateObjectData {
	return StateObjectData(
		portColor: Color(UIColor.label),
		showNewServerSheet: false,
		connectionResult: ConnectionTest.untested,
		hostname: "",
		port: "22",
		username: "",
		selectedAuthMethod: "Private Key",
		selectedKeys: [],
		password: ""
	)
}

private class StateObject: ObservableObject {
	@Published var stateObjectData: StateObjectData = ResetStateObjectData()
	
	func setData(_ data: StateObjectData) {
		stateObjectData = data
	}
	
	func resetData() {
		stateObjectData = ResetStateObjectData()
	}
}

struct ServersView: View {
	@Environment(\.dismiss) var dismiss
	
	@Query var servers: [Server]
	
	@ObservedObject private var stateObject = StateObject()
	
	let authMethods: [String] = ["Private Key", "Password"]
	
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
						stateObject.stateObjectData.showNewServerSheet.toggle()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $stateObject.stateObjectData.showNewServerSheet, onDismiss: {
				stateObject.resetData()
			}) {
				NavigationStack {
					VStack {
						Form {
							Section(header: Text("Connection"), footer: Text("Port must be within the range of 1-65535. The default is port 22.")) {
								LabeledContent("Hostname") {
									TextField("Required", text: $stateObject.stateObjectData.hostname)
										.multilineTextAlignment(.trailing)
								}
								
								LabeledContent {
									TextField("Required", text: $stateObject.stateObjectData.port)
										.multilineTextAlignment(.trailing)
										.onChange(of: stateObject.stateObjectData.port) { oldValue, newValue in
											if newValue == "" {
												return
											}
											if !newValue.isNumber || Int(newValue) ?? 0 > 65535 || Int(newValue) ?? 0 < 1 {
												stateObject.stateObjectData.port = oldValue
											}
										}
								} label: {
									Text("Port")
										.foregroundStyle(stateObject.stateObjectData.portColor)
								}
							}
							
							Section(header: Text("Authentication"), footer: Text("All credentials will be stored securely in the device Keychain.")) {
								LabeledContent("Username") {
									TextField("Required", text: $stateObject.stateObjectData.username)
										.multilineTextAlignment(.trailing)
								}
								
								Picker("Method", selection: $stateObject.stateObjectData.selectedAuthMethod) {
									ForEach(authMethods, id: \.self) {
										Text($0)
									}
								}
								
								if stateObject.stateObjectData.selectedAuthMethod == "Private Key" {
									NavigationLink("Select Private Key") {
										PrivateKeySelectionView(selectedKeys: $stateObject.stateObjectData.selectedKeys)
									}
								}
								
								if stateObject.stateObjectData.selectedAuthMethod == "Password" {
									LabeledContent("Password") {
										SecureField("Required", text: $stateObject.stateObjectData.password)
											.multilineTextAlignment(.trailing)
									}
								}
							}
							
							Section {
								Button {
									stateObject.stateObjectData.connectionResult = VerifyConnection()
								} label: {
									Text("Test Connection")
								}
							} footer: {
								switch stateObject.stateObjectData.connectionResult {
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
								stateObject.stateObjectData.showNewServerSheet = false
							}
						}
						
						ToolbarItem(placement: .confirmationAction) {
							Button("Done") {
								stateObject.stateObjectData.showNewServerSheet = false
							}
						}
					}
				}
			}
		}
	}
}

#Preview {
	ServersView()
}
