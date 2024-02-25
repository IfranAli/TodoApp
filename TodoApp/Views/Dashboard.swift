//
//  Dashboard.swift
//  TodoApp
//
//  Created by Ifran Ali on 31/1/2024.
//

import SwiftUI
import CoreData

extension Dashboard {
	class DashboardViewModel: ObservableObject {
		@Published var tasks: [Task] = []
		
		@Published var focusedProject: Project?
		
		init() {
			print("Init")
			if let focus = PersistenceController.shared.container.focusedProject {
				setFocusedProject(project: focus)
			}
			
		}
		
		func setFocusedProject(project: Project) -> Void {
			self.focusedProject = project
		}
		
		func fetchTasks(context: NSManagedObjectContext) {
			var predicates: [NSPredicate] = [
				NSPredicate(
					format: "state != %@ AND state != %@",
					argumentArray: [TaskState.done.rawValue, TaskState.blocked.rawValue]
				)
			]
			
			if let focusedProject = focusedProject {
				let projectFilter = NSPredicate(format: "origin == %@", argumentArray: [focusedProject])
				predicates.append(projectFilter)
			}
			
			let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
			fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
			fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.priority, ascending: false)]
			
			do {
				let result = try context.fetch(fetchRequest)
				tasks = result
			} catch {
				print("Error fetching tasks: \(error.localizedDescription)")
			}
		}
	}
	
}

struct Dashboard: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@StateObject private var viewmodel: DashboardViewModel
	
	@State private var selectedTask: Task? = nil
	
	init() {
		_viewmodel = StateObject(wrappedValue: DashboardViewModel())
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			
			HStack {
				Text(viewmodel.focusedProject?.name ?? "Showing All")
			}
			.padding()
			
			List($viewmodel.tasks) { task in
				
				HStack {
					Button(action: {
						selectedTask = task.wrappedValue
					}) {
						TaskListItemView(task: task)
					}
					
				}
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
				
			}
			.listStyle(.plain)
		}
		.sheet(item: $selectedTask, onDismiss: {
			viewmodel.fetchTasks(context: viewContext)
		}) { task in
			TaskEditView(task: task)
				.presentationDetents([.medium, .large])
		}
		.onAppear() {
			viewmodel.fetchTasks(context: viewContext)
		}
		
		// Navigaton and Toolbar
		//
		.navigationTitle("Priority Tasks")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				NavigationLink(destination: {
					DashboardSettings(focusedProject: $viewmodel.focusedProject)
				}) {
					Label("Settings", systemImage: "gear")
				}
			}
		}
	}
	
}

#Preview {
	NavigationStack {
		Dashboard()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
