//
//  PrivateKeyDetailsView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI

struct PrivateKeyDetailsView: View {
	@Binding var key: PrivateKey
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
	PrivateKeyDetailsView(key: .constant(PrivateKey(name: "Test", keyType: "ED25519")))
}
