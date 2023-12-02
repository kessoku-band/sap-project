//
//  Execute.swift
//  sap-project
//
//  Created by Brandon Li on 1/12/23.
//

import Foundation
import Citadel
import KeychainAccess
import SwiftUI

class WidgetExecuteWrapper: ObservableObject {
	@Published var value = "-"
	@Published var color = Color.secondary
	
	func execute(server: Server, evalValue: String, evalColor: String) async {
		if server.authMethod == AuthMethod.password {
			let passwordKeychain = Keychain(service: "com.simonfalke.passwords")
			
			let password = passwordKeychain[server.passwordID?.uuidString ?? ""] ?? ""
			
			guard let client = try? await SSHClient.connect(
				host: server.hostname,
				authenticationMethod: .passwordBased(username: server.username, password: password),
				hostKeyValidator: .acceptAnything(),
				reconnect: .once
			) else { return }
			
			guard let evaluatedValue = try? await client.executeCommand(evalValue) else { return }
			
			guard let evaluatedColor = try? await client.executeCommand(evalColor) else { return }
			
			await MainActor.run {
				value = String(buffer: evaluatedValue).trimmingCharacters(in: .whitespacesAndNewlines)
			}
			
			await MainActor.run {
				color = retrieveColor(colorInt: Int(String(buffer: evaluatedColor).trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
			}
			
			try? await client.close()
		}
	}
	
	private func retrieveColor(colorInt: Int) -> Color {
		switch colorInt {
		case 0: return Color(UIColor.label)
		case 1: return Color.red
		case 2: return Color.green
		default: return Color(UIColor.label)
		}
	}
}
