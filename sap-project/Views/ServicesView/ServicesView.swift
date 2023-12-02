//
//  ServicesView.swift
//  sap-project
//
//  Created by Brandon Li on 15/11/23.
//

import SwiftUI

struct ServicesView: View {
	var body: some View {
		NavigationStack {
			List {
				NavigationLink {
					DockerServersView(navigationTitle: "Docker")
				} label: {
					Text("Docker")
				}
			}
			.navigationTitle("Services")
		}
	}
}

#Preview {
	ServicesView()
}
