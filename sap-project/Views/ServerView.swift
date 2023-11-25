//
//  ServerView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI

struct ServerView: View {
    
    // Function to handle button tap and log to the console
    func logNewWorkflow() {
        print("New Workflow")
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Configured workflows"), footer: Text("Workflows will be added as bash scripts, and automated with cron.")) {
                    Button(action: {logNewWorkflow()}) {Text("Refresh SSL certificates").foregroundStyle(.black)}
                    Button(action: {logNewWorkflow()}) {Text("Push to docker registry").foregroundStyle(.black)}
                    Button(action: {logNewWorkflow()}) {Text("Upgrade packages").foregroundStyle(.black)}
                    Button(action: {logNewWorkflow()}) {
                        Label("Add new workflow", systemImage: "plus")
                    }
                }
                Section(header: Text("Service widgets")) {
                    Button(action: {logNewWorkflow()}) {Text("Docker").foregroundStyle(.black)}
                    Button(action: {logNewWorkflow()}) {Text("systemd").foregroundStyle(.black)}
                    Button(action: {logNewWorkflow()}) {
                        Label("Add service widget", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Server 1")
        }
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
