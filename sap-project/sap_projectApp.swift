//
//  sap_projectApp.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

@main
struct sap_projectApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: [
					PrivateKey.self,
					ServiceWidgetLine.self,
					Server.self
				])
		}
	}
}
