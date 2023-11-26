//
//  Password.swift
//  sap-project
//
//  Created by Brandon Li on 26/11/23.
//

import Foundation
import SwiftData

@Model
final class Password {
	var id = UUID()
	
	init(id: UUID = UUID()) {
		self.id = id
	}
}
