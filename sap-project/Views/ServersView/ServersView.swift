//
//  ServersView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData
import KeychainAccess

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
						ServerEditor(server: server, servers: $servers)
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
