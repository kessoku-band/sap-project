//
//  MonitorWidget.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct MonitorWidgetLine {
	let key: String
	let value: String
	let color: Int
	
	func extractColor() -> Color {
		switch color {
		case 0:
			return Color(UIColor.label)
		case 1:
			return Color.red
		case 2:
			return Color.green
		default:
			return Color(UIColor.label)
		}
	}
}

struct MonitorWidget: View {
	let title: String
	let lines: [MonitorWidgetLine]
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(title)
					.font(.headline)
			}
			
			ForEach(lines, id: \.key) { monitorWidgetLine in
				HStack {
					Text(monitorWidgetLine.key)
					Spacer()
					Text(monitorWidgetLine.value)
						.foregroundStyle(monitorWidgetLine.extractColor())
				}
			}
		}
		.frame(minWidth: 125, alignment: .topLeading)
		.padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 10.0))
	}
}

let lines: [MonitorWidgetLine] = [
	MonitorWidgetLine(key: "running", value: "2 cont.", color: 0),
	MonitorWidgetLine(key: "exited", value: "2 exited", color: 1)
]

#Preview {
	MonitorWidget(title: "Docker", lines: lines)
}
