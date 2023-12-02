//
//  ServerView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI
import SwiftData

func logNewWorkflow() {
	print("New Workflow")
}

struct ServerView: View {
	@Environment(\.modelContext) private var modelContext
	
	@Query var servers: [Server]
	
	@State private var isShowingSheet = false
	
	@Binding var server: Server
	
	var body: some View {
		NavigationStack {
			List {
				// byebye workflows.
				
				Section(header: Text("Service widgets")) {
					Button(action: {
						isShowingSheet.toggle()
					}) {
						Label("Add service widget", systemImage: "plus")
					}
				}
			}
			.navigationTitle(server.name)
			.sheet(isPresented: $isShowingSheet) {
				ServerEditor()
			}
			.onAppear {
				var lines = (0..<3).map { _ in return ServiceWidgetLine(indicator: "", evalValue: "", evalColor: "") }
				
				for line in lines {
					modelContext.insert(line)
				}
			}
		}
	}
}

struct ServerView_Previews: PreviewProvider {
	static var previews: some View {
		ServerView(server: .constant(Server(name: "test", hostname: "Test", port: 10, username: "jhkdgkdgjdh", authMethod: .password, keyIDs: [])))
	}
}
