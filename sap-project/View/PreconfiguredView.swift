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
						ServiceWidgetLine(indicator: "running", value: "2 cont.", color: 0),
						ServiceWidgetLine(indicator: "exited", value: "2 exited", color: 1)
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
