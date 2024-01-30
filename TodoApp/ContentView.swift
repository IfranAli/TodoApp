//
//  ContentView.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Project.created, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Project>

    var body: some View {
        NavigationStack {
			
			VStack(alignment: .leading, spacing: 0) {
				
				// Heading
				VStack(alignment: .leading, spacing: 0) {
					Text("Manage your projects.")
						.foregroundColor(.secondary)
					
					HStack {
						// Required spacer for UI effect.
						Spacer()
					}
				}
				.padding(.horizontal)
				.padding(.bottom, 30)
				.background(Color.card)
				.onAppear() {
				}
				
				List() {
					ForEach(items.indices, id: \.self) { idx in
						NavigationLink(value: items[idx]) {
							ProjectListItemView(project: items[idx])
						}
						.listRowSeparator(.hidden)
						.listRowBackground(idx % 2 == 0 ? Color.appBackground : Color.uiBackground)
						.listRowInsets(EdgeInsets())
						.padding(14)
					}
				}
				
				.padding(.top, 12)
				
				.navigationDestination(for: Project.self) { project in
					ProjectDetailView(project: project)
				}
				.scrollContentBackground(.hidden)
				.listStyle(.plain)
				.navigationTitle("Projects")
				.toolbar {
					ToolbarItem {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
				}
			}
			.background(Color.appBackground)
			
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
    ContentView()
		.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
