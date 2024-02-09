//
//  ProjectsView.swift
//  TodoApp
//
//  Created by Ifran Ali on 31/1/2024.
//

import SwiftUI
import CoreData

struct ProjectsView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Project.created, ascending: true)],
		animation: .default)
	private var items: FetchedResults<Project>
	
	// For stack navigation.
	@State private var path = NavigationPath()

	var body: some View {
		NavigationStack(path: $path) {
		
			VStack(alignment: .leading, spacing: 0) {
				
				List(items) { item in
					Button {
						path.append(item)
					} label: {
						ProjectListItemView(project: item)
					}
					.listRowSeparator(.hidden)
					.listRowBackground(Color.clear)

				}
				.scrollContentBackground(.hidden)
				.listStyle(.plain)
				.padding(.top, 12)
				.navigationDestination(for: Project.self) { project in
					ProjectDetailView(project: project)
				}
				.navigationTitle("Projects")
				.toolbar {
					ToolbarItem {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
				}
			}
			
		}
	}
	
	private func addItem() {
		// Add new Project
		withAnimation {
			let newItem = Project(context: viewContext)
			newItem.created = Date()
			newItem.name = "New Project"
			newItem.summary = "Untitled"
			
			do {
				try viewContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}
	


#Preview {
	ProjectsView()
		.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
