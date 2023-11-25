//
//  OverviewView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct SectionHeader: View {
	@State var title: String
	@Binding var isOn: Bool
	@State var onLabel: String
	@State var offLabel: String
	
	var body: some View {
		Button(action: {
			withAnimation {
				isOn.toggle()
			}
		}, label: {
			if isOn {
				Text(onLabel)
			} else {
				Text(offLabel)
			}
		})
		.font(Font.caption)
		.foregroundColor(.accentColor)
		.frame(maxWidth: .infinity, alignment: .trailing)
		.overlay(
			Text(title),
			alignment: .leading
		)
	}
}


struct DashboardView: View {
	let lines: [ServiceWidgetLine] = [
		ServiceWidgetLine(indicator: "running", evalValue: "2 cont.", evalColor: ""),
		ServiceWidgetLine(indicator: "exited", evalValue: "2 exited", evalColor: "")
	]
	
	let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
	
	@State private var showingSection: Bool = true
	
	var body: some View {
		NavigationStack {
			List {
				Section(header: SectionHeader(
						title: "Server 1",
						isOn: $showingSection,
						onLabel: "Hide",
						offLabel: "Show"
					)
				) {
					if showingSection {
						LazyVGrid(columns: columns, spacing: 11)  {
							ServiceWidget(title: "Docker", lines: .constant(lines))
							ServiceWidget(title: "Docker", lines: .constant(lines))
							ServiceWidget(title: "Docker", lines: .constant(lines))
							ServiceWidget(title: "Docker", lines: .constant(lines))
							ServiceWidget(title: "Docker", lines: .constant(lines))
							
							// And yes we can proceed to create a persisting plist for that stack of ServiceWidgets
						}
					}
				}
			}
			.listStyle(.inset)
			.headerProminence(.increased)
			.navigationTitle("Dashboard")
			
		}
	}
}

#Preview {
	DashboardView()
}

