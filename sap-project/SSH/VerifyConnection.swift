//
//  VerifyConnection.swift
//  sap-project
//
//  Created by Brandon Li on 26/11/23.
//

import Foundation

enum ConnectionTest {
	case untested
	case success
	case failed
}

func VerifyConnection() -> ConnectionTest {
	return ConnectionTest.success
}
