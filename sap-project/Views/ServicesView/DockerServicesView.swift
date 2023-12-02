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
	@Binding var containerStatuses: [Container : String]
	let dockerServer: DockerServer
	
	@ObservedObject private var executeWrapper = ExecuteWrapper()
	
	@State private var status: String = ""
	
	var body: some View {
		HStack {
			Text(container.name)
			
			Spacer()
			
			if !executeWrapper.completed && containerStatuses[container] == nil {
				ProgressView()
			} else {
				Text(containerStatuses[container] ?? "")
					.foregroundStyle(.secondary)
			}
		}
		.onAppear {
			Task {
				containerStatuses[container] = await dockerServer.retrieveContainerStatus(server: server, container: container, executeWrapper: executeWrapper)
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
	@State private var containerStatuses: [Container: String] = [:]
	
	@ObservedObject private var executeWrapper = ExecuteWrapper()
	@State private var performingAction = false
	
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
				} else if performingAction {
					VStack(alignment: .center) {
						ProgressView()
							.frame(minHeight: 20)
						Text("Running...")
							.foregroundStyle(.secondary)
					}
					.frame(minHeight: 0, maxHeight: .infinity, alignment: .center)
				} else {
					VStack(alignment: .leading) {
						let server = servers.filter { $0.id == dockerServer.serverID } [0]
						
						List(containers, id: \.self, selection: $selectedContainers) { container in
							DockerServiceLine(server: server, container: container, containerStatuses: $containerStatuses, dockerServer: dockerServer)
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
											let executeWrapper = ExecuteWrapper()
											let server = servers.filter { $0.id == dockerServer.serverID } [0]
											
											withAnimation {
												editMode = .inactive
											}
											
											performingAction = true
											
											Task {
												await dockerServer.startContainers(server: server, containers: selectedContainers, executeWrapper: executeWrapper)
											}
											
											for container in selectedContainers {
												containerStatuses[container] = nil
											}
											
											performingAction = false
											
											for container in selectedContainers {
												let newExecuteWrapper = ExecuteWrapper()
												
												Task {
													containerStatuses[container] = await dockerServer.retrieveContainerStatus(server: server, container: container, executeWrapper: newExecuteWrapper)
												}
											}
										}
										
										Spacer()
										
										Button("Stop") {
											let executeWrapper = ExecuteWrapper()
											let server = servers.filter { $0.id == dockerServer.serverID } [0]
											
											withAnimation {
												editMode = .inactive
											}
											
											performingAction = true
											
											Task {
												await dockerServer.stopContainers(server: server, containers: selectedContainers, executeWrapper: executeWrapper)
											}
											
											for container in selectedContainers {
												containerStatuses[container] = nil
											}
											
											performingAction = false
											
											for container in selectedContainers {
												let newExecuteWrapper = ExecuteWrapper()
												
												Task {
													containerStatuses[container] = await dockerServer.retrieveContainerStatus(server: server, container: container, executeWrapper: newExecuteWrapper)
												}
											}
										}
										
										Spacer()
										
										Button("Restart") {
											let executeWrapper = ExecuteWrapper()
											let server = servers.filter { $0.id == dockerServer.serverID } [0]
											
											withAnimation {
												editMode = .inactive
											}
											
											performingAction = true
											
											Task {
												await dockerServer.restartContainers(server: server, containers: selectedContainers, executeWrapper: executeWrapper)
											}
											
											for container in selectedContainers {
												containerStatuses[container] = nil
											}
											
											performingAction = false
											
											for container in selectedContainers {
												let newExecuteWrapper = ExecuteWrapper()
												
												Task {
													containerStatuses[container] = await dockerServer.retrieveContainerStatus(server: server, container: container, executeWrapper: newExecuteWrapper)
												}
											}
										}
									}
									.padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
								}
							}
						}
					}
					.refreshable {
						let server = servers.filter { $0.id == dockerServer.serverID } [0]
						
						for container in containers {
							containerStatuses[container] = await dockerServer.retrieveContainerStatus(server: server, container: container, executeWrapper: executeWrapper)
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
