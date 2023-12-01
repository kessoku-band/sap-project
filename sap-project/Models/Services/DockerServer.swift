//
//  DockerServer.swift
//  sap-project
//
//  Created by Brandon Li on 1/12/23.
//

import Foundation
import SwiftData

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
}
