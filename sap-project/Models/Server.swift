//
//  Server.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData

@Model
final class Server {
	var id = UUID()
	var name: String
	var hostname: String
	var port: Int
	var authMethod: Int
	var keyIDs: [String]?
	var passwordID: String?
	
	// authMethod == 0
	init(id: UUID = UUID(), name: String, hostname: String, port: Int, authMethod: Int, keyIDs: [String]) {
		self.id = id
		self.name = name
		self.hostname = hostname
		self.port = port
		self.authMethod = authMethod
		self.keyIDs = keyIDs
	}
	
	// authMethod == 1
	init(id: UUID = UUID(), name: String, hostname: String, port: Int, authMethod: Int, passwordID: String) {
		self.id = id
		self.name = name
		self.hostname = hostname
		self.port = port
		self.authMethod = authMethod
		self.passwordID = passwordID
	}
}
