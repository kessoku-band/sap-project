//
//  ServiceWidgetLine.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ServiceWidgetLine {
	var indicator: String
	var evalValue: String
	var evalColor: String
	var unit: String
	var order: Int
	
	init(indicator: String, evalValue: String, evalColor: String, unit: String, order: Int) {
		self.indicator = indicator
		self.evalValue = evalValue
		self.evalColor = evalColor
		self.unit = unit
		self.order = order
	}
}
