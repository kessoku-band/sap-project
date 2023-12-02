//
//  PreconfiguredView.swift
//  sap-project
//
//  Created by Brandon Li on 21/11/23.
//

import SwiftUI

struct PreconfiguredDetailsView: View {
	@Environment(\.dismiss) private var dismiss
	
	let lines: [ServiceWidgetLine]
	@Binding var detailedView: String
	@Binding var isShowingSheet: Bool
	
	@State var containerName = ""
	
	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Info"), footer: Text("Fill in required parameters in order to use this preconfigured widget.")) {
					switch detailedView {
					case "container":
						LabeledContent("Container Name") {
							SpecialTextField("Required", text: $containerName)
								.multilineTextAlignment(.trailing)
						}
					default: EmptyView()
					}
				}
			}
			.navigationTitle("Configure Widget")
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
						isShowingSheet = false
					}
					.disabled(containerName.isEmpty)
				}
			}
		}
	}
	
	private func save() {
		switch detailedView {
		case "container":
			lines[0].indicator = ""
			lines[0].evalValue = ""
			lines[0].evalColor = ""
			lines[0].unit = ""
			lines[0].order = 0
			
			lines[1].indicator = "status"
			lines[1].evalValue = "docker inspect --format '{{.State.Status}}' \(containerName) 2>/dev/null || echo \"removed\""
			lines[1].evalColor = "docker inspect --format '{{.State.Status}}' \(containerName) 2>/dev/null || echo \"removed\" | awk '{print ($1 == \"running\") ? 2 : ($1 == \"exited\" || $1 == \"removed\") ? 1 : 0}'"
			lines[1].unit = ""
			lines[1].order = 1
			
			lines[2].indicator = "uptime"
			lines[2].evalValue = "docker ps -a | grep \(containerName) | grep -oP 'Up \\K(\\d+ [a-zA-Z]+)'"
			lines[2].evalColor = "echo 0"
			lines[2].unit = ""
			lines[2].order = 2
		default: return
		}
	}
}

struct PreconfiguredView: View {
	@Environment(\.dismiss) private var dismiss
	
	let lines: [ServiceWidgetLine]
	@Binding var isShowingSheet: Bool
	
	@State private var detailedView: String = ""
	@State private var showPreconfiguredDetailsSheet: Bool = false
	
	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Preconfigured Widgets"), footer: Text("Using preconfigured widgets will automatically fill in all required parameters.")) {
					Button("Docker") {
						lines[0].indicator = ""
						lines[0].evalValue = ""
						lines[0].evalColor = ""
						lines[0].unit = ""
						lines[0].order = 0
						
						lines[1].indicator = "running"
						lines[1].evalValue = "docker ps --filter \"status=running\" -q | wc -l"
						lines[1].evalColor = "echo 0"
						lines[1].unit = "cont."
						lines[1].order = 1
						
						lines[2].indicator = "exited"
						lines[2].evalValue = "docker ps --filter \"status=exited\" -q | wc -l"
						lines[2].evalColor = "docker ps --filter \"status=exited\" -q | wc -l | awk '{print ($1 > 0) ? 1 : 2}'"
						lines[2].unit = "cont."
						lines[2].order = 2
						
						dismiss()
					}
					
					Button("Docker Container") {
						detailedView = "container"
						showPreconfiguredDetailsSheet = true
					}
					
					Button("systemd") {
						lines[0].indicator = "enabled"
						lines[0].evalValue = "systemctl list-unit-files --state=enabled | grep -c '\\.service'"
						lines[0].evalColor = "echo 0"
						lines[0].unit = "serv."
						lines[0].order = 0
						
						lines[1].indicator = "running"
						lines[1].evalValue = "systemctl list-units --type=service --state=running | grep -c '\\.service'"
						lines[1].evalColor = "echo 0"
						lines[1].unit = "serv."
						lines[1].order = 1
						
						lines[2].indicator = "exited"
						lines[2].evalValue = "systemctl list-units --type=service --state=exited | grep -c '\\.service'"
						lines[2].evalColor = "systemctl list-units --type=service --state=exited | grep -c '\\.service' | awk '{print ($1 > 0) ? 1 : 2}'"
						lines[2].unit = "serv."
						lines[2].order = 2
						dismiss()
					}
					
					Button("APT") {
						lines[0].indicator = "installed"
						lines[0].evalValue = "apt-mark showmanual | wc -l"
						lines[0].evalColor = "echo 0"
						lines[0].unit = "pkgs"
						lines[0].order = 0
						
						lines[1].indicator = "deps."
						lines[1].evalValue = "apt-mark showmanual | xargs apt-cache depends --installed | grep -c \"Depends\""
						lines[1].evalColor = "echo -"
						lines[1].unit = "pkgs"
						lines[1].order = 1
						
						lines[2].indicator = "upgradable"
						lines[2].evalValue = "apt list --upgradable 2>/dev/null | grep -c '/'"
						lines[2].evalColor = "apt list --upgradable 2>/dev/null | grep -c '/' | awk '{print ($1 > 0) ? 2 : 0}'"
						lines[2].unit = "pkgs"
						lines[2].order = 2
						dismiss()
					}
				}
			}
		}
		.navigationTitle("Preconfigured Widgets")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $showPreconfiguredDetailsSheet) {
			PreconfiguredDetailsView(lines: lines, detailedView: $detailedView, isShowingSheet: $isShowingSheet)
		}
	}
}

//#Preview {
//	PreconfiguredView(lines: [])
//}
