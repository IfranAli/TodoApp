//
//  DashboardSettings.swift
//  TodoApp
//
//  Created by Ifran Ali on 9/2/2024.
//

import SwiftUI

struct DashboardSettings: View {
    @Environment(\.managedObjectContext) private var viewContext
	
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
						.tag(nil as Project?)
						
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
		.onDisappear {
			// Save the focused project to UserDefaults when the view disappears
			PersistenceController.shared.container.focusedProject = self.focusedProject
		}
	}
}

#Preview {
	 NavigationStack {
		DashboardSettings(focusedProject: .constant(nil))
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
