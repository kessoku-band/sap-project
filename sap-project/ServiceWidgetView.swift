//
//  ServiceWidgetView.swift
//  sap-project
//
//  Created by JingLin Yang on 18/11/23.
//

import SwiftUI

struct ServiceWidgetView: View {
   var body: some View {
       NavigationStack {
           Text("New Service Widget")
               .bold()
           Form {
               
               Section() {
                   Text("Name")
                   Text("Binary path")
                   
               }
               Section() {
                   Text("Preconfigured")
                     
                       
                       
                   
               }
               Section(header: Text("Monitor line 1")) {
                   Text("Indicator")
                   Text("Value")
                   Text("Color")
                   
               }
               Section(header: Text("Monitor line 2")) {
                   Text("Indicator")
                   Text("Value")
                   Text("Color")
                   
               }
               Section(header: Text("Monitor line 3")) {
                   Text("Indicator")
                   Text("Value")
                   Text("Color")
                   
               }
           }
       }
   }
}

#Preview {
    ServiceWidgetView()
}
