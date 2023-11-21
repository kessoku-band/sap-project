//
//  WorkflowView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI

struct WorkflowView: View {
       
   var body: some View {
       NavigationStack {
           Text("New Workflow")
               .bold()
           Form {
               Section {
                   Text("Name")
                  
               }
               
           }
           
       }
   }
}

#Preview {
    WorkflowView()
}
