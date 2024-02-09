//
//  DashboardSettings.swift
//  TodoApp
//
//  Created by Ifran Ali on 9/2/2024.
//

import SwiftUI

struct DashboardSettings: View {
	@Binding private var focusedProject: Project?
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Project.created, ascending: true)],
		animation: .default)
	private var items: FetchedResults<Project>
	
	init(focusedProject: Binding<Project?>) {
		_focusedProject = focusedProject
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			
			List {
				
				// Picker view for selection of a focused project
				HStack {
					Picker(selection: $focusedProject, label: Text("Focus")) {
						
						// Default selection
						Text("All")
						.tag(Optional<Project>(nil))
						
						ForEach(items) { project in
							Text(project.name ?? "Unkown")
								.tag(Optional(project))
						}
						
					}
					.pickerStyle(MenuPickerStyle())
				}
			}
			
		}
		.navigationTitle("Settings")
		.toolbarTitleDisplayMode(.inline)
	}
}

#Preview {
	 NavigationStack {
		DashboardSettings(focusedProject: .constant(nil))
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
