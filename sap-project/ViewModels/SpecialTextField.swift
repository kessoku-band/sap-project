//
//  SpecialTextField.swift
//  sap-project
//
//  Created by AlphaSolid on 27/11/23.
//

import SwiftUI

struct SpecialTextField: View {
    var title: String
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        TextField(title, text: $text)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}
