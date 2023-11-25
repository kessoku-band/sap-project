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
	var name: String
	@Relationship(deleteRule: .cascade) var serviceWidgetDatas: [ServiceWidgetData]
	@Transient var isOn: Bool = true
	
	init(name: String, serviceWidgetDatas: [ServiceWidgetData], isOn: Bool) {
		self.name = name
		self.serviceWidgetDatas = serviceWidgetDatas
		self.isOn = isOn
	}
}
