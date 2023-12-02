//
//  sap_projectApp.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI
import SwiftData

@main
struct sap_projectApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: [
					DockerServer.self,
					PrivateKey.self,
					Password.self,
					ServiceWidgetLine.self,
					ServiceWidgetData.self,
					ServerWidgetGroup.self,
					Server.self
				])
		}
	}
}
