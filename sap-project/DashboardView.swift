//
//  OverviewView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct DashboardView: View {
	let lines: [ServiceWidgetLine] = [
		ServiceWidgetLine(indicator: "running", value: "2 cont.", color: 0),
		ServiceWidgetLine(indicator: "exited", value: "2 exited", color: 1)
	]
	
    var body: some View {
		NavigationStack {
			HStack {
				ServiceWidget(title: "Docker", lines: lines)
				ServiceWidget(title: "Docker", lines: lines)
			}
			.navigationTitle("Dashboard")
		}
    }
}

#Preview {
    DashboardView()
}
