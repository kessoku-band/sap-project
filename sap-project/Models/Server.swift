//
//  Server.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData

enum AuthMethod: Codable, Equatable, CaseIterable, CustomStringConvertible {
	case privateKey
	case password
	
	var description: String {
		switch self {
		case .privateKey: return "Private Key"
		case .password: return "Password"
		}
	}
}

@Model
final class Server {
	var id = UUID()
	var name: String
	var hostname: String
	var port: Int
	var username: String
	var authMethod: AuthMethod
	var keyIDs: Set<UUID>?
	var passwordID: UUID?
	
	// authMethod == 0
	init(id: UUID = UUID(), name: String, hostname: String, port: Int, username: String, authMethod: AuthMethod, keyIDs: Set<UUID>) {
		self.id = id
		self.name = name
		self.hostname = hostname
		self.port = port
		self.username = username
		self.authMethod = authMethod
		self.keyIDs = keyIDs
	}
	
	// authMethod == 1
	init(id: UUID = UUID(), name: String, hostname: String, port: Int, username: String, authMethod: AuthMethod, passwordID: UUID) {
		self.id = id
		self.name = name
		self.hostname = hostname
		self.port = port
		self.username = username
		self.authMethod = authMethod
		self.passwordID = passwordID
	}
}
