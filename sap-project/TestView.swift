//
//  TestView.swift
//  sap-project
//
//  Created by Brandon Li on 2/12/23.
//

import SwiftUI

struct TestView: View {
	@State private var presentedNumbers = [Int]()

		var body: some View {
			NavigationStack(path: $presentedNumbers) {
				List(1..<50) { i in
					NavigationLink(value: i) {
						Label("Row \(i)", systemImage: "\(i).circle")
					}
				}
				.navigationDestination(for: Int.self) { i in
					VStack {
						Text("Detail \(i)")

						Button("Go to Next") {
							presentedNumbers.append(i + 1)
						}
					}
				}
				.navigationTitle("Navigation")
			}
		}
}

#Preview {
	TestView()
}
