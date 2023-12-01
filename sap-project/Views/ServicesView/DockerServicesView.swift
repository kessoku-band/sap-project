//
//  DockerServicesView.swift
//  sap-project
//
//  Created by Brandon Li on 1/12/23.
//

import SwiftUI

struct DockerServicesView: View {
	var dockerServer: DockerServer
	
	@State private var selectedContainers = Set<Container>()
	
    var body: some View {
		NavigationStack {
			List(selection: $selectedContainers) {
				ForEach(dockerServer.retrieveContainers()) { container in
					HStack {
						Text(container.name)
					}
				}
			}
		}
    }
}

//#Preview {
//    DockerServicesView()
//}
