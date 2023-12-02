//
//  TestView.swift
//  sap-project
//
//  Created by Brandon Li on 2/12/23.
//

import SwiftUI

struct TestView: View {
	@State private var selection = Set<String>()
	
	let names = [
		"Cyril",
		"Lana",
		"Mallory",
		"Sterling"
	]
	
	var body: some View {
		NavigationStack {
			List(names, id: \.self, selection: $selection) { name in
				Text(name)
			}
			.navigationTitle("List Selection")
			.toolbar {
				EditButton()
			}
		}
	}
}

#Preview {
	TestView()
}
