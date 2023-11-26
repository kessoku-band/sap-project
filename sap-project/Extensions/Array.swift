//
//  Array.swift
//  sap-project
//
//  Created by Brandon Li on 26/11/23.
//

import Foundation

extension Array where Element == String {
	func joinedFormatted() -> String {
		if isEmpty {
			return ""
		} else if count == 1 {
			return self[0]
		} else {
			return dropLast().joined(separator: ", ") + " and " + last!
		}
	}
}
