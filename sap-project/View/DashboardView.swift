//
//  OverviewView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct DashboardView: View {
    let lines: [ServiceWidgetLine] = [
        ServiceWidgetLine(indicator: "running", value: "2 cont.", color: 0),
        ServiceWidgetLine(indicator: "exited", value: "2 exited", color: 1)
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Server 1")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                LazyVGrid(columns: columns)  {
                    ServiceWidget(title: "Docker", lines: lines)
                    ServiceWidget(title: "Docker", lines: lines)
                    ServiceWidget(title: "Docker", lines: lines)
                    ServiceWidget(title: "Docker", lines: lines)
                    ServiceWidget(title: "Docker", lines: lines)
                    
                    // And yes we can proceed to create a persisting plist for that stack of ServiceWidgets
                }
            }
            .padding(10)
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}
