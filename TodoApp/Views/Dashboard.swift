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
		
		init() {
		}
		
		func fetchTasks(context: NSManagedObjectContext) {
			let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
			fetchRequest.predicate = NSPredicate(
				format: "state != %@ AND state != %@",
				argumentArray: [TaskState.done.rawValue, TaskState.blocked.rawValue]
			)
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
			
			NavigationLink("Click", destination: {
				Text("Settings")
			})
			
			List($viewmodel.tasks) { task in
				
				HStack {
						Button(action: {
							selectedTask = task.wrappedValue
						}) {
							RoundedRectangle(cornerRadius: 2)
								.fill(task.origin.wrappedValue?.projectColor ?? .appBackground)
								.frame(width: 10, height: 70)
						}
					
					TaskListItemView(task: task)
				}
				.listRowSeparator(.hidden)
				.listRowBackground(Color.appBackground)
				
			}
			.listStyle(.plain)
		} 
		.background(Color.appBackground)
		.navigationTitle("Priority Tasks")
		.sheet(item: $selectedTask, onDismiss: {
			viewmodel.fetchTasks(context: viewContext)
		}) { task in
			TaskEditView(task: task)
				.presentationDetents([.medium, .large])
		}
		.onAppear() {
			viewmodel.fetchTasks(context: viewContext)
		}
	}
}

#Preview {
	NavigationStack {
		Dashboard()
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
