//
//  ServiceWidgetView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI

struct ServiceWidgetLineFieldsView: View {
	@Binding var line: ServiceWidgetLine
	
	var body: some View {
		LabeledContent("Indicator") {
			TextField("Indicator", text: $line.indicator)
				.multilineTextAlignment(.trailing)
		}
		LabeledContent("Value") {
			TextField("Value", text: $line.value)
				.multilineTextAlignment(.trailing)
		}
		LabeledContent("Color") {
			TextField("Color", value: $line.color, formatter: NumberFormatter())
				.multilineTextAlignment(.trailing)
		}
	}
}

struct NewServiceWidgetView: View {
	@State private var name: String = ""
	@State private var path: String = ""
	
	@State private var isShowingSheet: Bool = false
	
	@State private var lines: [ServiceWidgetLine] = []
	
	var body: some View {
		NavigationStack {
			Form {
				Section() {
					LabeledContent("Service Name") {
						TextField("Name", text: $name)
							.multilineTextAlignment(.trailing)
					}
					
					LabeledContent("Binary Path") {
						TextField("Path", text: $path)
							.multilineTextAlignment(.trailing)
					}
				}
				
				Section() {
					Button {
						isShowingSheet = true
					} label: {
						Text("Use Preconfigured")
					}
					.sheet(isPresented: $isShowingSheet, content: {
						NavigationStack {
							List {
								Section(header: Text("Preconfigured Services"), footer: Text("Using preconfigured services will automatically fill in all required parameters. Some may require additional parameters.")) {
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
