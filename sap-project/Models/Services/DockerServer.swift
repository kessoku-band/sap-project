//
//  DockerServer.swift
//  sap-project
//
//  Created by Brandon Li on 1/12/23.
//

import Foundation
import SwiftData

enum ContainerType {
	case individual
	case compose
}

struct Container: Identifiable, Hashable {
	var id: UUID = UUID()
	var type: ContainerType
	var composePath: String?
	var name: String
}

@Model
final class DockerServer {
	var id = UUID()
	var serverID: UUID
	var composePaths: [String]
	
	init(id: UUID = UUID(), serverID: UUID, composePaths: [String]) {
		self.id = id
		self.serverID = serverID
		self.composePaths = composePaths
	}
	
	func retrieveContainerStatus(server: Server, container: Container, executeWrapper: ExecuteWrapper) async -> String {
		let output = await executeWrapper.execute(server: server, command: "docker inspect -f '{{.State.Status}}' \(container.name)")
		return output
	}
	
	func retrieveContainers(server: Server, executeWrapper: ExecuteWrapper) async -> [Container] {
		let output = await executeWrapper.execute(server: server, command: "docker ps -a --format \"{{.ID}}\" | xargs -I {} docker inspect --format='{{.Name}}' {} | cut -d'/' -f2")
		return output.components(separatedBy: CharacterSet(charactersIn: " \n")).map { Container(type: ContainerType.individual, name: $0) }
	}
	
	func stopContainers(server: Server, containers: Set<Container>, executeWrapper: ExecuteWrapper) async {
		for container in containers {
			let _ = await executeWrapper.execute(server: server, command: "docker stop \(container.name)")
		}
	}
	
	func startContainers(containers: Set<Container>) {
		
	}
	
	func restartContainers(server: Server, containers: Set<Container>, executeWrapper: ExecuteWrapper) async {
		await stopContainers(server: server, containers: containers, executeWrapper: executeWrapper)
		startContainers(containers: containers)
	}
}
