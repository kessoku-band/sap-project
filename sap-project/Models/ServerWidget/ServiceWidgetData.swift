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
	@Relationship(deleteRule: .cascade) var serviceWidgetLines: [ServiceWidgetLine]
	
	init(name: String, serviceWidgetLines: [ServiceWidgetLine]) {
		self.name = name
		self.serviceWidgetLines = serviceWidgetLines
	}
}
