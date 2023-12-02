//
//  MonitorWidget.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct ServiceWidgetLineView: View {
	let line: ServiceWidgetLine
	let server: Server

	@ObservedObject var widgetExecuteWrapper = WidgetExecuteWrapper()
	
	var body: some View {
		HStack {
			Text(line.indicator)
				.foregroundStyle(.secondary)
			Spacer()
			Text("\(widgetExecuteWrapper.value) \(line.unit)")
				.foregroundStyle(widgetExecuteWrapper.color)
		}
		.onAppear {
			Task {
				await widgetExecuteWrapper.execute(server: server, evalValue: line.evalValue, evalColor: line.evalColor)
			}
		}
	}
}

struct ServiceWidget: View {
	let name: String
	let server: Server
	let lines: [ServiceWidgetLine]
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(name)
					.font(.headline)
			}
			
			Spacer()
				.frame(height: 10)
			
			ForEach(lines, id: \.indicator) { line in
				if line.indicator.isEmpty {
					HStack {
						Text(".")
					}.hidden()
				} else {
					ServiceWidgetLineView(line: line, server: server)
				}
			}
		}
		.frame(minWidth: 125, minHeight: 95, maxHeight: 95, alignment: .topLeading)
		.padding(EdgeInsets(top: 12, leading: 13, bottom: 12, trailing: 13))
		.background(Color(uiColor: .secondarySystemBackground))
		.clipShape(RoundedRectangle(cornerRadius: 10.0))
	}
}

//#Preview {
//	ServiceWidget(name: "Docker", lines: .constant([]))
//}
