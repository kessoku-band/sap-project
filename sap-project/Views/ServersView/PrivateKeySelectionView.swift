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
	
	@Binding var keys: [PrivateKey]
	
	@State private var keyName: String = ""
	@State private var keyText: String = ""
	
	let keyTypes = ["rsa", "ed25519", "ed25519-sk", "dsa", "ecdsa", "ecdsa-sk"]
	@State private var selectedKeyType: String = "rsa"
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Info") {
					LabeledContent("Key Name") {
						TextField("Required", text: $keyName)
					}
				}
				
				Section("Private Key") {
					TextField("Required", text: $keyText)
				}
				
				Section {
					Picker("Key Type", selection: $selectedKeyType) {
						ForEach(keyTypes, id: \.self) {
							Text($0)
						}
					}
				}
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
						save()
						dismiss()
					}
				}
				
			}
		}
	}
	
	private func save() {
		let newPrivateKey = PrivateKey(
			name: keyName,
			keyType: selectedKeyType
		)
	}
}

struct PrivateKeySelectionView: View {
	@Query var fetchedKeys: [PrivateKey]
	@Binding var selectedKeys: Set<UUID>
	
	@State var keys: [PrivateKey] = []
	@State var showNewPrivateKeySheet: Bool = false
	
	@State var newKeyText: String = ""
	@State var newKeyType: String = ""
	
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
				NewPrivateKeyView(keys: $keys)
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
