//
//  PrivateKey.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation

struct PrivateKey: Identifiable, Codable {
	var id = UUID()
	var name: String
	var keyType: String
}
