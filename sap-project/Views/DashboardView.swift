//
//  OverviewView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI
import SwiftData

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
	@Query var fetchedServiceWidgetGroups: [ServerWidgetGroup]
	
	let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
	
	var body: some View {
		NavigationStack {
			NoItemsView(enabled: fetchedServiceWidgetGroups.isEmpty, name: "Configured Widgets")
			
			List {
				ForEach(fetchedServiceWidgetGroups) { serverWidget in
					Section(header: SectionHeader(
						title: serverWidget.name,
						isOn: Bindable(serverWidget).isOn,
						onLabel: "Hide",
						offLabel: "Show"
					)) {
						if serverWidget.isOn {
							LazyVGrid(columns: columns, spacing: 11)  {
								ForEach(serverWidget.serviceWidgetDatas) { serverWidgetData in
									ServiceWidget(name: serverWidgetData.name, lines: Bindable(serverWidgetData).serviceWidgetLines)
								}
							}
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

