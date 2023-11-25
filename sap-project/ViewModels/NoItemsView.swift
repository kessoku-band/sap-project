//
//  NoItemsView.swift
//  sap-project
//
//  Created by Brandon Li on 26/11/23.
//

import SwiftUI

struct NoItemsView: View {
	let enabled: Bool
	let name: String
	
	var body: some View {
		if enabled {
			VStack(alignment: .center) {
				Text("No \(name)")
					.foregroundStyle(.secondary)
			}
			.frame(minHeight: 0, maxHeight: .infinity, alignment: .bottom)
		}
	}
}

#Preview {
	NoItemsView(enabled: true, name: "Tests")
}
