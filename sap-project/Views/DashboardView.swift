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

struct EmptySectionHeader: View {
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
		.background(Color(UIColor.systemBackground))
		.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
		.font(Font.caption)
		.foregroundColor(.accentColor)
		.frame(maxWidth: .infinity, alignment: .trailing)
		.overlay(
			Text(title),
			alignment: .leading
		)
	}
}

struct ServerWidgetGroupView: View {
	var serverWidgetGroup: ServerWidgetGroup
	var servers: [Server]
	
	@State private var isOn = true
	
	let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
	
	var body: some View {
		Section(header: SectionHeader(
			title: servers.filter({ $0.id == serverWidgetGroup.serverID }) [0].name,
			isOn: $isOn,
			onLabel: "Hide",
			offLabel: "Show"
		)) {
			if isOn {
				LazyVGrid(columns: columns, spacing: 11)  {
					ForEach(serverWidgetGroup.serviceWidgetDatas.sorted { $0.name < $1.name }) { serviceWidgetData in
						ServiceWidget(name: serviceWidgetData.name, server: servers.filter({ $0.id == serviceWidgetData.serverID })[0], lines: serviceWidgetData.serviceWidgetLines.sorted{ $0.order < $1.order })
					}
				}
			}
		}
	}
}

struct DashboardView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	@Query var fetchedServerWidgetGroups: [ServerWidgetGroup]
	@Query var fetchedServers: [Server]
	
	@State private var servers: [Server] = []
	@State private var lines: [ServiceWidgetLine] = []
	
	@State private var showNewWidgetSheet = false
	@State private var addIsEnabled = true
	
	var body: some View {
		NavigationStack {
			NoItemsView(enabled: fetchedServerWidgetGroups.isEmpty, name: "Configured Widgets")
			
			List {
				ForEach(fetchedServerWidgetGroups) { serverWidgetGroup in
					ServerWidgetGroupView(serverWidgetGroup: serverWidgetGroup, servers: fetchedServers)
				}
				Section(header:  EmptySectionHeader(
					title: "",
					isOn: .constant(false),
					onLabel: "Hide",
					offLabel: "Show"
				)) {}.hidden().opacity(0)
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

