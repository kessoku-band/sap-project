//
//  DockerServersView.swift
//  sap-project
//
//  Created by Brandon Li on 1/12/23.
//

import SwiftUI
import SwiftData

struct PathWrapper: Identifiable {
	var id: UUID = UUID()
	var path: String
}

struct PathTextField: View {
	@Binding var pathWrapper: PathWrapper
	
	var body: some View {
		TextField("Path to compose folder", text: $pathWrapper.path)
	}
}

struct DockerServerEditor: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext
	
	@Query var servers: [Server]
	
	@State private var selectedServer: UUID = UUID()
	@State private var pathWrappers: [PathWrapper] = []
	@State private var filteredServers: [Server] = []
	
	let dockerServer: DockerServer?
	@Binding var dockerServers: [DockerServer]
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					Picker("Server", selection: $selectedServer) {
						ForEach(filteredServers) { server in
							Text(server.name)
								.tag(server.id)
						}
					}
				}
				
				Section("Compose") {
					ForEach($pathWrappers) { $pathWrapper in
						PathTextField(pathWrapper: $pathWrapper)
					}
					.onDelete(perform: onDelete)
					
					Button {
						withAnimation {
							pathWrappers.append(PathWrapper(path: ""))
						}
					} label: {
						Label("Add new compose folder", systemImage: "plus")
					}
				}
			}
			.navigationTitle("Configure Server")
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
				}
			}
			.onAppear {
				filteredServers = servers.filter { !dockerServers.map { $0.serverID } .contains($0.id) }
				if let dockerServer {
					selectedServer = dockerServer.serverID
					pathWrappers = dockerServer.composePaths.map { PathWrapper(path: $0) }
				} else {
					selectedServer = filteredServers[0].id
				}
			}
		}
	}
	
	private func save() {
		if let dockerServer {
			dockerServer.serverID = selectedServer
			dockerServer.composePaths = pathWrappers.map { $0.path }
			
			filteredServers = servers.filter { !dockerServers.map { $0.serverID } .contains($0.id) }
			selectedServer = filteredServers[0].id
		} else {
			let newDockerServer = DockerServer(serverID: selectedServer, composePaths: pathWrappers.map { $0.path } )
			
			dockerServers.append(newDockerServer)
			filteredServers = servers.filter { !dockerServers.map { $0.serverID } .contains($0.id) }
			if !filteredServers.isEmpty {
				selectedServer = filteredServers[0].id
			}
			print(selectedServer)
			modelContext.insert(newDockerServer)
		}
	}
	
	private func onDelete(at offsets: IndexSet) {
		for index in offsets {
			_ = withAnimation {
				pathWrappers.remove(at: index)
			}
		}
	}
}

struct DockerServersView: View {
	@Environment(\.modelContext) var modelContext
	
	let navigationTitle: String
	
	@Query var fetchedDockerServers: [DockerServer]
	@Query var servers: [Server]
	
	@State private var dockerServers: [DockerServer] = []
	@State private var showNewDockerServerSheet = false
	
	var body: some View {
		NavigationStack {
			List {
				Section("Servers") {
					ForEach(dockerServers) { dockerServer in
						let server = servers.filter { $0.id == dockerServer.serverID } [0]
						
						NavigationLink(server.name) {
							DockerServicesView(serverName:server.name, dockerServer: dockerServer)
						}
					}
					.onDelete(perform: onDelete)
				}
			}
			.navigationTitle(navigationTitle)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					EditButton()
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showNewDockerServerSheet.toggle()
					} label: {
						Image(systemName: "plus")
					}
					.disabled(servers.filter { !dockerServers.map { $0.serverID } .contains($0.id) }.isEmpty)
				}
			}
			.sheet(isPresented: $showNewDockerServerSheet) {
				DockerServerEditor(dockerServer: nil, dockerServers: $dockerServers)
			}
			.onAppear {
				dockerServers = fetchedDockerServers
			}
		}
	}
	
	private func onDelete(at offsets: IndexSet) {
		for index in offsets {
			modelContext.delete(dockerServers[index])
			dockerServers.remove(at: index)
		}
	}
}

#Preview {
	DockerServersView(navigationTitle: "Docker")
}
