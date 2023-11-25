//
//  PreconfiguredView.swift
//  sap-project
//
//  Created by Brandon Li on 21/11/23.
//

import SwiftUI

struct PreconfiguredView: View {
	let title: String
	@Binding var lines: [ServiceWidgetLine]
	@Binding var isShowingSheet: Bool
	
	var body: some View {
		NavigationStack {
			Form {
				Button("Test") {
					lines = [
						ServiceWidgetLine(indicator: "running", evalValue: "2 cont.", evalColor: "echo 0"),
						ServiceWidgetLine(indicator: "exited", evalValue: "2 exited", evalColor: "echo 0")
					]
					
					isShowingSheet = false
				}
			}
			.navigationTitle(title)
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
	PreconfiguredView(title: "Docker", lines: .constant([]), isShowingSheet: .constant(true))
}
