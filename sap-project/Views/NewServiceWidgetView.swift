//
//  ServiceWidgetView.swift
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
		}
		LabeledContent("Color") {
			SpecialTextField("Required", text: $line.evalColor)
				.multilineTextAlignment(.trailing)
		}
	}
}

struct NewServiceWidgetView: View {
	@Environment(\.modelContext) private var modelContext
	
	@State private var name: String = ""
	@State private var path: String = ""
	
	@State private var isShowingSheet: Bool = false
	@State private var selectedServer: UUID = UUID()
    
    @State private var lines: [ServiceWidgetLine] = []
	
	@Query var fetchedServiceWidgetGroups: [ServerWidgetGroup]
	
	var body: some View {
		NavigationStack {
			Form {
				Section {
                    Picker("Server", selection: $selectedServer) {
                        ForEach(fetchedServiceWidgetGroups, id: \.self) { serverGroup in
                            Text(serverGroup.id.uuidString)
                        }
                    }
				}
				
				Section {
					LabeledContent("Service Name") {
                        SpecialTextField("Required", text: $name)
							.multilineTextAlignment(.trailing)
					}
					
					LabeledContent("Binary Path") {
                        SpecialTextField("Required", text: $path)
							.multilineTextAlignment(.trailing)
					}
				}
				
				Section {
					Button {
						isShowingSheet = true
					} label: {
						Text("Use Preconfigured")
					}
					.sheet(isPresented: $isShowingSheet, content: {
						NavigationStack {
							List {
								Section(header: Text("Preconfigured Services"), footer: Text("Using preconfigured services will automatically fill in all required parameters.")) {
									NavigationLink("Docker") {
										PreconfiguredView(title: "Docker", lines: $lines, isShowingSheet: $isShowingSheet)
									}
								}
							}
						}
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
		}
	}
}

#Preview {
	NewServiceWidgetView()
}
