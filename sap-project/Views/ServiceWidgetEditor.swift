//
//  ServiceWidgetEditor.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI
import SwiftData

struct ServiceWidgetLineFieldsView: View {
	@Binding var line: ServiceWidgetLine
	
	var body: some View {
		LabeledContent("Indicator") {
			SpecialTextField("Required", text: $line.indicator)
				.multilineTextAlignment(.trailing)
		}
		LabeledContent("Value") {
			SpecialTextField("Required", text: $line.evalValue)
				.multilineTextAlignment(.trailing)
		}
		LabeledContent("Unit") {
			SpecialTextField("Required", text: $line.unit)
				.multilineTextAlignment(.trailing)
		}
		LabeledContent("Color") {
			SpecialTextField("Required", text: $line.evalColor)
				.multilineTextAlignment(.trailing)
		}
	}
}

struct ServiceWidgetEditor: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	@Query var fetchedServerWidgetGroups: [ServerWidgetGroup]
	@Query var servers: [Server]
	
	var serviceWidgetData: ServiceWidgetData?
	var navPath: NavigationPath
	
	@State private var isShowingSheet: Bool = false
	
	@State private var selectedServer: UUID = UUID()
	@State private var name: String = ""
	@State private var lines: [ServiceWidgetLine] = []
	
	@State private var editing = false
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
					Picker("Server", selection: $selectedServer) {
						ForEach(servers, id: \.self) { server in
							Text(server.name)
								.tag(server.id)
						}
					}
					.disabled(editing)
				}
				
				Section {
					LabeledContent("Widget Name") {
						SpecialTextField("Required", text: $name)
							.multilineTextAlignment(.trailing)
					}
				}
				
				Section {
					Button {
						isShowingSheet.toggle()
					} label: {
						Text("Use Preconfigured")
					}
					.sheet(isPresented: $isShowingSheet, content: {
						PreconfiguredView(lines: lines, isShowingSheet: $isShowingSheet)
					})
				}
				
				ForEach(lines.indices, id: \.self) { index in
					Section(header: Text("Monitor line \(index+1)")) {
						ServiceWidgetLineFieldsView(line: $lines[index])
					}
				}
			}
			.navigationTitle("New Service Widget")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if !editing {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel", role: .cancel) {
							dismiss()
						}
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("Done") {
						save()
						dismiss()
					}
				}
			}
			.onAppear {
				print(navPath)
				if let serviceWidgetData {
					selectedServer = serviceWidgetData.serverID
					name = serviceWidgetData.name
					lines = serviceWidgetData.serviceWidgetLines
					
					editing = true
				} else {
					selectedServer = servers[0].id
					lines = (0..<3).map { i in return ServiceWidgetLine(indicator: "", evalValue: "", evalColor: "", unit: "", order: i) }
				}
			}
		}
	}
	
	private func save() {
		if let serviceWidgetData {
			serviceWidgetData.name = name
		} else {
			let newServiceWidgetData = ServiceWidgetData(
				name: name,
				serverID: selectedServer,
				serviceWidgetLines: lines
			)
			
			let serverWidgetGroup = fetchedServerWidgetGroups.filter { $0.serverID == selectedServer }
			
			if !serverWidgetGroup.isEmpty {
				serverWidgetGroup[0].serviceWidgetDatas.append(newServiceWidgetData)
			} else {
				let newServerWidgetGroup = ServerWidgetGroup(serverID: selectedServer, serviceWidgetDatas: [newServiceWidgetData])
				
				modelContext.insert(newServerWidgetGroup)
			}
		}
	}
}

//#Preview {
//	ServiceWidgetEditor()
//}
