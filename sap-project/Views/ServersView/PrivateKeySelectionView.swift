//
//  PrivateKeySelectionView.swift
//  sap-project
//
//  Created by Brandon Li on 25/11/23.
//

import SwiftUI
import SwiftData
import KeychainAccess


struct PrivateKeyLabelView: View {
	@Binding var selectedKeys: Set<UUID>
	@Binding var key: PrivateKey
	@Binding var keys: [PrivateKey]
	
	var body: some View {
		NavigationLink {
			PrivateKeyEditor(key: key, keys: $keys)
		} label: {
			HStack {
				Image(systemName: selectedKeys.contains(key.id) ? "checkmark.circle.fill" : "circle")
					.onTapGesture {
                        if let prev = selectedKeys.first {
                            selectedKeys.remove(prev)
                        }
                        selectedKeys.insert(key.id)
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

struct PrivateKeyEditor: View {
	let key: PrivateKey?
	
	let keychain = Keychain(service: "com.simonfalke.privatekeys")
	
	private var editorTitle: String {
		key == nil ? "New Private Key" : "Edit Private Key"
	}
	
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) private var modelContext
	
	@Binding var keys: [PrivateKey]
	
	let keyTypes = ["rsa", "ed25519", "ed25519-sk", "dsa", "ecdsa", "ecdsa-sk"]
	
	@State private var keyName: String = ""
	@State private var keyText: String = ""
	@State private var selectedKeyType: String = "rsa"
	
	@State private var editing: Bool = false
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Info") {
					LabeledContent("Key Name") {
                        SpecialTextField("Required", text: $keyName)
							.multilineTextAlignment(.trailing)
					}
				}
				
				Section("Private Key") {
                    SpecialTextField("Required", text: $keyText)
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
				if !editing {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel", role: .cancel) {
							dismiss()
                            
						}
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("Done") {
						save()
						dismiss()
					}
				}
				
			}
			.onAppear {
				if let key {
					keyName = key.name
					selectedKeyType = key.keyType
					keyText = keychain[key.id.uuidString] ?? ""
					
					editing = true
				}
			}
		}
	}
	
	private func save() {
		if let key {
			key.name = keyName
			key.keyType = selectedKeyType
			keychain[key.id.uuidString] = keyText
		} else {
			let newPrivateKey = PrivateKey(
				name: keyName,
				keyType: selectedKeyType
			)
			
			keychain[newPrivateKey.id.uuidString] = keyText
			
			modelContext.insert(newPrivateKey)
			
			keys.append(newPrivateKey)
		}
	}
}

struct PrivateKeySelectionView: View {
	@Environment(\.modelContext) private var modelContext
	
	@Query var fetchedKeys: [PrivateKey]
	@Binding var selectedKeys: Set<UUID>
	@Query var servers: [Server]
	
	@State var keys: [PrivateKey] = []
	@State var showNewPrivateKeySheet: Bool = false
	@State var showingAlert: Bool = false
	@State var keyInUse: String = ""
	@State var serversUsing: [String] = []
	
	@State var newKeyText: String = ""
	@State var newKeyType: String = ""
	
	var body: some View {
		NavigationStack {
			NoItemsView(enabled: fetchedKeys.isEmpty, name: "Configured Private Keys")
			
			List {
				ForEach($keys) { key in
					PrivateKeyLabelView(selectedKeys: $selectedKeys, key: key, keys: $keys)
				}
				.onDelete(perform: listDelete)
				.onMove(perform: onMove)
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
				PrivateKeyEditor(key: nil, keys: $keys)
			}
			.alert("\(keyInUse) is currently in use by \(serversUsing.joinedFormatted())", isPresented: $showingAlert) {
				Button("OK", role: .cancel) { }
				
			}
		}
		.onAppear() {
			keys = fetchedKeys
		}
	}
	
	private func listDelete(at offsets: IndexSet) {
		for index in offsets {
			if !keys[index].serversUsing.isEmpty {
				keyInUse = keys[index].name
				serversUsing = servers.filter { server in
					keys[index].serversUsing.contains(server.id)
				}
				.map { $0.name }
				showingAlert = true
			} else {
				modelContext.delete(keys[index])
				selectedKeys.remove(keys[index].id)
				
				keys.remove(at: index)
			}
		}
		
		print(keys)
		print(fetchedKeys)
		print(selectedKeys)
	}
	
	private func onMove(source: IndexSet, destination: Int) {
		keys.move(fromOffsets: source, toOffset: destination)
	}
	
}

#Preview {
	PrivateKeySelectionView(selectedKeys: .constant([]))
}
