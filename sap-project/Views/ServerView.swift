//
//  ServerView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI

func logNewWorkflow() {
    print("New Workflow")
}

struct ServerView: View {
    
    // State to control the presentation of the sheet
    @State private var isShowingSheet = false
    @State private var newWorkflowLabel = ""
    
    // Function to handle button tap and show the sheet
    func showAddWorkflowSheet() {
        isShowingSheet = true
    }
    
    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Configured workflows"), footer: Text("Workflows will be added as bash scripts, and automated with cron.")) {
                    Button(action: { logNewWorkflow() }) { Text("Refresh SSL certificates").foregroundStyle(.black) }
                    Button(action: { logNewWorkflow() }) { Text("Push to docker registry").foregroundStyle(.black) }
                    Button(action: { logNewWorkflow() }) { Text("Upgrade packages").foregroundStyle(.black) }
                    Button(action: { showAddWorkflowSheet() }) {
                        Label("Add new workflow", systemImage: "plus")
                    }
                }
                Section(header: Text("Service widgets")) {
                    Button(action: { logNewWorkflow() }) { Text("Docker").foregroundStyle(.black) }
                    Button(action: { logNewWorkflow() }) { Text("systemd").foregroundStyle(.black) }
                    Button(action: { logNewWorkflow() }) {
                        Label("Add service widget", systemImage: "plus")
                    }
                }
            }
            
        }
        .navigationTitle("Server 1")
        .sheet(isPresented: $isShowingSheet) {
            // Sheet content for adding a new workflow with a label
            VStack {
                TextField("Enter Workflow Label", text: $newWorkflowLabel)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add Workflow") {
                    // Perform actions when "Add Workflow" is tapped
                    print("New Workflow Added with label: \(newWorkflowLabel)")
                    
                    // Close the sheet after adding the workflow
                    isShowingSheet = false
                }
                .padding()
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
