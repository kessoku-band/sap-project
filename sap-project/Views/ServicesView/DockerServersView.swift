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
	@Query var dockerServers: [DockerServer]
	
	@State private var selectedServer: UUID = UUID()
	@State private var pathWrappers: [PathWrapper] = []
	
	let dockerServer: DockerServer?
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					Picker("Server", selection: $selectedServer) {
						ForEach(servers.filter { !dockerServers.map { $0.serverID } .contains($0.id) } ) { server in
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
				if let dockerServer {
					selectedServer = dockerServer.serverID
					pathWrappers = dockerServer.composePaths.map { PathWrapper(path: $0) }
				} else {
					selectedServer = servers[0].id
				}
			}
		}
	}
	
	private func save() {
		if let dockerServer {
			dockerServer.serverID = selectedServer
			dockerServer.composePaths = pathWrappers.map { $0.path }
		} else {
			let newDockerServer = DockerServer(serverID: selectedServer, composePaths: pathWrappers.map { $0.path } )
			
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
	@Query var dockerServers: [DockerServer]
	@Query var servers: [Server]
	
	@State private var showNewDockerServerSheet = false
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(dockerServers) { dockerServer in
					let server = servers.filter { $0.id == dockerServer.serverID } [0]
					
					NavigationLink(server.name) {
						DockerServicesView(server: server)
					}
				}
			}
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
				}
			}
			.sheet(isPresented: $showNewDockerServerSheet) {
				DockerServerEditor(dockerServer: nil)
			}
		}
	}
}

#Preview {
	DockerServersView()
}
