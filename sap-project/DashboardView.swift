//
//  OverviewView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct DashboardView: View {
	let lines: [MonitorWidgetLine] = [
		MonitorWidgetLine(key: "running", value: "2 cont.", color: 0),
		MonitorWidgetLine(key: "exited", value: "2 exited", color: 1)
	]
	
    var body: some View {
		NavigationStack {
			HStack {
				MonitorWidget(title: "Docker", lines: lines)
				MonitorWidget(title: "Docker", lines: lines)
			}
			.navigationTitle("Dashboard")
		}
    }
}

#Preview {
    DashboardView()
}
