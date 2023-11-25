//
//  ContentView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	var body: some View {
		TabView {
			DashboardView()
				.tabItem {
					Label("Dashboard", systemImage: "text.and.command.macwindow")
				}
			
			ServicesView()
				.tabItem {
					Label("Services", systemImage: "mosaic")
				}
		}
	}
}

#Preview {
	ContentView()
}
