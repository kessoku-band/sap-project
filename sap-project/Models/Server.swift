//
//  Server.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation

struct Server: Identifiable, Codable {
	var id = UUID()
	var name: String
	var hostname: String
	var port: Int
	var authMethod: Int
	var keyID: String
	var passwordID: String
}
