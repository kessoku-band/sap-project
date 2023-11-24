//
//  MonitorWidget.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct ServiceWidgetLine {
    var indicator: String
    var value: String
    var color: Int
    
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

struct ServiceWidget: View {
    let title: String
    let lines: [ServiceWidgetLine]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
            }
			
			Spacer()
				.frame(height: 10)
            
            ForEach(lines, id: \.indicator) { line in
                HStack {
                    Text(line.indicator)
						.foregroundStyle(.secondary)
					Spacer()
                    Text(line.value)
                        .foregroundStyle(line.extractColor())
                }
            }
        }
        .frame(minWidth: 125, alignment: .topLeading)
        .padding(EdgeInsets(top: 12, leading: 13, bottom: 12, trailing: 13))
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}

let lines: [ServiceWidgetLine] = [
    ServiceWidgetLine(indicator: "running", value: "2 cont.", color: 0),
    ServiceWidgetLine(indicator: "exited", value: "2 exited", color: 1)
]

#Preview {
    ServiceWidget(title: "Docker", lines: lines)
}
