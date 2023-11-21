//
//  ServerView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI

struct ServerView: View {
   var body: some View {
       NavigationStack() {
           Form {
               Section(header: Text("Configured workflows")) {
                   Text("Refresh SSL Certificates")
                   Text("Push to docker registry")
                   Text("Upgrade packages")
                   Button {
                       print("New Workflow")
                   } label: {
                       Text("Add new workflow")
                   }
                   
               }
               
               Section(header: Text("Service widgets")) {
                   Text("Docker")
                   Text("systemd")
                   Button {
                       
                   } label: {
                       Text("Add service widget")
                   }
               }
           
              
           }
           .navigationTitle("Server 1")
       }
   }
}

#Preview {
    ServerView()
}
