//
//  PrivateKeySelectionView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI

struct PrivateKeySelectionView: View {
	@State private var keys: [PrivateKey] = [PrivateKey(name: "Default", keyType: "ED25519")]
	@Binding var selectedKeys: Set<UUID>
	
	var body: some View {
		NavigationStack {
			List($keys, editActions: .all) { $key in
				NavigationLink {
					PrivateKeyDetailsView(key: $key)
				} label: {
					HStack {
						Image(systemName: selectedKeys.contains(key.id) ? "checkmark.circle.fill" : "circle")
							.onTapGesture {
								selectedKeys = selectedKeys.symmetricDifference(Set([key.id]))
							}
						VStack(alignment: .leading) {
							Text(key.name)
							Text(key.keyType)
								.font(.caption)
								.foregroundStyle(.secondary)
						}
					}
				}
			}
			.navigationTitle("Private Keys")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					EditButton()
				}
				
				
			}
		}
	}
}

#Preview {
	PrivateKeySelectionView(selectedKeys: .constant([]))
}
