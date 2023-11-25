//
//  MonitorWidget.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct ServiceWidget: View {
	let name: String
	@Binding var lines: [ServiceWidgetLine]
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(name)
					.font(.headline)
			}
			
			Spacer()
				.frame(height: 10)
			
			ForEach($lines, id: \.indicator) { $line in
				HStack {
					Text(line.indicator)
						.foregroundStyle(.secondary)
					Spacer()
					Text(line.evalValue)
					// 	.foregroundStyle(line.evalColor)
						.foregroundStyle(Color(UIColor.label))
				}
			}
		}
		.frame(minWidth: 125, alignment: .topLeading)
		.padding(EdgeInsets(top: 12, leading: 13, bottom: 12, trailing: 13))
		.background(Color(uiColor: .secondarySystemBackground))
		.clipShape(RoundedRectangle(cornerRadius: 10.0))
	}
}

#Preview {
	ServiceWidget(name: "Docker", lines: .constant([]))
}
