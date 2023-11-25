//
//  ServersView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData

struct ServersView: View {
	@Query var servers: [Server]
	@State private var showNewServerSheet = false
	
	@State private var hostname: String = ""
	@State private var port: Int = 22
	
	let authMethods: [String] = ["Private Key", "Password"]
	@State private var selectedAuthMethod = "Private Key"
	@State private var selectedKeys: Set<UUID> = []
	
	var body: some View {
		NavigationStack {
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
				NavigationStack {
					Form {
						Section("Connection") {
							LabeledContent("Hostname") {
								TextField("Hostname", text: $hostname)
									.multilineTextAlignment(.trailing)
							}
							
							LabeledContent("Port") {
								TextField("Port", value: $port, formatter: NumberFormatter())
									.multilineTextAlignment(.trailing)
							}
						}
						
						Section("Authentication") {
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
						}
					}
					.navigationTitle("New Server")
					.navigationBarTitleDisplayMode(.inline)
				}
			}
		}
	}
}

#Preview {
	ServersView()
}
