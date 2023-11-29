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
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	@Query var fetchedServiceWidgetGroups: [ServerWidgetGroup]
	@Query var fetchedServers: [Server]
	
	@State private var servers: [Server] = []
	@State private var lines: [ServiceWidgetLine] = []
	
	@State private var showNewWidgetSheet = false
	@State private var addIsEnabled = true
	
	let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
	
	var body: some View {
		NavigationStack {
			NoItemsView(enabled: fetchedServiceWidgetGroups.isEmpty, name: "Configured Widgets")
			
			List {
				ForEach(fetchedServiceWidgetGroups) { serverWidget in
					Section(header: SectionHeader(
						title: fetchedServers.filter { return $0.id == serverWidget.serverID } [0].name,
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
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					EditButton()
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showNewWidgetSheet.toggle()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $showNewWidgetSheet) {
				if fetchedServers.isEmpty {
					ServerEditor(server: nil, servers: $servers)
				} else {
					ServiceWidgetEditor(serviceWidgetData: nil)
				}
			}
			.onAppear {
				servers = fetchedServers
			}
		}
	}
}

#Preview {
	DashboardView()
}

