//
//  PrivateKeySelectionView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData

struct PrivateKeyLabelView: View {
	@Binding var selectedKeys: Set<UUID>
	@Binding var key: PrivateKey
	
	var body: some View {
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
}

struct NewPrivateKeyView: View {
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			Form {
				
			}
			.navigationTitle("New Private Key")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel", role: .cancel) {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("Done") {
						dismiss()
					}
				}
				
			}
		}
	}
}

struct PrivateKeySelectionView: View {
	@Query var fetchedKeys: [PrivateKey]
	@Binding var selectedKeys: Set<UUID>
	
	@State var keys: [PrivateKey] = []
	@State var showNewPrivateKeySheet: Bool = false
	
	var body: some View {
		NavigationStack {
			NoItemsView(enabled: fetchedKeys.isEmpty, name: "Configured Private Keys")
			
			List($keys, editActions: .all) { key in
				PrivateKeyLabelView(selectedKeys: $selectedKeys, key: key)
			}
			.navigationTitle("Private Keys")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					EditButton()
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showNewPrivateKeySheet.toggle()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $showNewPrivateKeySheet) {
				NewPrivateKeyView()
			}
		}
		.onAppear() {
			keys = fetchedKeys
		}
	}
}

#Preview {
	PrivateKeySelectionView(selectedKeys: .constant([]))
}
