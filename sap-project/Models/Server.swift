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
	var keyID: String?
	var passwordID: String?
	
	// authMethod == 0
	init(id: UUID = UUID(), name: String, hostname: String, port: Int, authMethod: Int, keyID: String) {
		self.id = id
		self.name = name
		self.hostname = hostname
		self.port = port
		self.authMethod = authMethod
		self.keyID = keyID
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
