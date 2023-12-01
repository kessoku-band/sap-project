//
//  ServerWidgetGroup.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData

@Model
final class ServerWidgetGroup {
	var id = UUID()
	var serverID: UUID
	@Relationship(deleteRule: .cascade) var serviceWidgetDatas: [ServiceWidgetData]
	
	init(serverID: UUID, serviceWidgetDatas: [ServiceWidgetData]) {
		self.serverID = serverID
		self.serviceWidgetDatas = serviceWidgetDatas
	}
}
