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
	
	func retrieveContainers() -> [Container] {
		return []
	}
	
	func stopContainers(containers: [Container]) {
		
	}
	
	func startContainers(containers: [Container]) {
		
	}
	
	func restartContainers(containers: [Container]) {
		stopContainers(containers: containers)
		startContainers(containers: containers)
	}
}
