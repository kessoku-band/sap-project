//
//  String.swift
//  sap-project
//
//  Created by Brandon Li on 26/11/23.
//

import Foundation

extension String {
	var isNumber: Bool {
		return self.range(
			of: "^[0-9]*$",
			options: .regularExpression) != nil
	}
}
