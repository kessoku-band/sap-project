//
//  PrivateKey.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData

@Model
final class PrivateKey {
	var id = UUID()
	var name: String
	var keyType: String
	var serversUsing: Set<UUID> = Set<UUID>()
	
	init(id: UUID = UUID(), name: String, keyType: String) {
		self.id = id
		self.name = name
		self.keyType = keyType
	}
}
