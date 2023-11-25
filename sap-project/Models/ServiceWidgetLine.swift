//
//  ServiceWidgetLine.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData

@Model
final class ServiceWidgetLine {
	var indicator: String
	var evalValue: String
	var evalColor: String
	
	init(indicator: String, evalValue: String, evalColor: String) {
		self.indicator = indicator
		self.evalValue = evalValue
		self.evalColor = evalColor
	}
}
