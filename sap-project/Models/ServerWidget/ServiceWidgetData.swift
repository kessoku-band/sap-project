//
//  ServiceWidgetData.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData

@Model
final class ServiceWidgetData {
	var name: String
	var serverID: UUID
	@Relationship(deleteRule: .cascade) var serviceWidgetLines: [ServiceWidgetLine]
	
	init(name: String, serverID: UUID, serviceWidgetLines: [ServiceWidgetLine]) {
		self.name = name
		self.serverID = serverID
		self.serviceWidgetLines = serviceWidgetLines
	}
}
