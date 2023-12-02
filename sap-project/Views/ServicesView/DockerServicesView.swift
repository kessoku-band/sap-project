//
//  DockerServicesView.swift
//  sap-project
//
//  Created by Brandon Li on 1/12/23.
//

import SwiftUI
import SwiftData

struct DockerServiceLine: View {
	let server: Server
	let container: Container
	let dockerServer: DockerServer
	
	@ObservedObject private var executeWrapper = ExecuteWrapper()
	
	@State private var status: String = ""
	
	var body: some View {
		HStack {
			Text(container.name)
			
			Spacer()

			if !executeWrapper.completed {
				ProgressView()
			} else {
				Text(status)
					.foregroundStyle(.secondary)
			}
		}
		.onAppear {
			Task {
				status = await dockerServer.retrieveContainerStatus(server: server, container: container, executeWrapper: executeWrapper)
			}
		}
	}
	
}

struct DockerServicesView: View {
	let serverName: String
	var dockerServer: DockerServer
	
	@Query var servers: [Server]
	
	@State private var selectedContainers = Set<Container>()
	@State private var containers: [Container] = []
	
	@ObservedObject private var executeWrapper = ExecuteWrapper()
	
	@State private var editMode: EditMode = .inactive
	
	var body: some View {
		NavigationStack {
			ZStack {
				if !executeWrapper.completed {
					VStack(alignment: .center) {
						ProgressView()
							.frame(minHeight: 20)
						Text("Loading containers")
							.foregroundStyle(.secondary)
					}
					.frame(minHeight: 0, maxHeight: .infinity, alignment: .center)
					
				} else {
					VStack(alignment: .leading) {
						let server = servers.filter { $0.id == dockerServer.serverID } [0]
						
						List(containers, id: \.self, selection: $selectedContainers) { container in
							DockerServiceLine(server: server, container: container, dockerServer: dockerServer)
						}
						.environment(\.editMode, $editMode)
						.toolbar {
							ToolbarItem(placement: .topBarTrailing) {
								selectButton
							}
							
							if editMode == EditMode.active {
								ToolbarItem(placement: .bottomBar) {
									HStack(alignment: .top) {
										Button("Start") {
											
										}
										Spacer()
										Button("Stop") {
											let executeWrapper = ExecuteWrapper()
											let server = servers.filter { $0.id == dockerServer.serverID } [0]
											
											Task {
												await dockerServer.stopContainers(server: server, containers: selectedContainers, executeWrapper: executeWrapper)
											}
										}
										Spacer()
										Button("Restart") {}
									}
									.padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
								}
							}
						}
					}
					.refreshable {
						Task {
							let server = servers.filter { $0.id == dockerServer.serverID } [0]
							containers = await dockerServer.retrieveContainers(server: server, executeWrapper: executeWrapper)
						}
					}
				}
			}
			.navigationTitle(serverName)
			.navigationBarTitleDisplayMode(.inline)
			.onAppear {
				executeWrapper.completed = false
				Task {
					let server = servers.filter { $0.id == dockerServer.serverID } [0]
					
					containers = await dockerServer.retrieveContainers(server: server, executeWrapper: executeWrapper)
				}
			}
		}
	}
	
	private var selectButton: some View {
		return Button {
			withAnimation {
				if editMode == .inactive {
					editMode = .active
				} else {
					editMode = .inactive
				}
			}
		} label: {
			Text(editMode == .inactive ? "Select" : "Done")
		}
	}
}

//#Preview {
//    DockerServicesView()
//}
