//
//  ProjectDetailView.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import SwiftUI
import CoreData

extension DV {
	class ProjectDetailViewModel: ObservableObject {
		@Published var project: Project
		@Published var tasks: [Task] = []
		
		init(project: Project) {
			self.project = project
			fetchTasks()
		}
		
		func fetchTasks() {
			if let results = project.task?.allObjects as? [Task] {
				tasks = []
				tasks = results.sorted(by: sortByPriority)
			}
		}
		
		func addTask() {
			// Add new Task
			let newItem = Task(context: PersistenceController.shared.container.viewContext)
			newItem.origin = self.project
			newItem.name = ""
			newItem.summary = ""
			newItem.created = Date()
			newItem.priority = Int16(Priority.medium.rawValue)
			
			fetchTasks()
		}
		
		func save() {
			do {
				try PersistenceController.shared.container.viewContext.save()
			} catch {
				fatalError("Unresolved error \(error), \(error.localizedDescription)")
			}
		}
		
		func deleteProject() {
			PersistenceController.shared.container.viewContext.delete(project)
			save()
		}
		
		func deleteTask(at offsets: IndexSet) {
			let context = PersistenceController.shared.container.viewContext
			
			for i in offsets {
				context.delete(tasks[i])
			}
			
			tasks.remove(atOffsets: offsets)
			save()
		}
		
		func sortByPriority(lhs: Task, rhs: Task) -> Bool {
			if lhs.state != rhs.state {
				return lhs.state < rhs.state
			}
			
			return lhs.priority > rhs.priority
		}
	}

}

struct DV: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.dismiss) var dismiss
	
	@StateObject private var viewModel: ProjectDetailViewModel
	
	@State private var showingEditTaskSheet = false
	@State private var showingEditProjectSheet = false
	@State private var selectedTask: Task? = nil
	
	init(project: Project) {
		_viewModel = StateObject(wrappedValue: ProjectDetailViewModel(project: project))
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			
			// Heading
			//
			VStack(alignment: .leading, spacing: 5) {
				
				Text(viewModel.project.name ?? "").font(.title)
				Text(viewModel.project.summary ?? "").foregroundColor(.secondary)
				
				HStack {
					// Required spacer for UI effect.
					Spacer()
				}
				
			}
			.padding(.horizontal)
			.padding(.bottom, 30)
			.background(Color.card)
			
			// Content
			//
			VStack {
//				EditButton()
				
				List() {
					ForEach($viewModel.tasks.indices, id: \.self) { idx in
						Button(action: {
							selectedTask = viewModel.tasks[idx]
							showingEditTaskSheet = true
						}) {
							TaskListItemView(task: $viewModel.tasks[idx])
						}
						.listRowSeparator(.hidden)
						.listRowBackground(idx % 2 == 0 ? Color.appBackground : Color.uiBackground)
						.listRowInsets(EdgeInsets())
						.padding(14)
					}
					.onDelete(perform: { indexSet in
						viewModel.deleteTask(at: indexSet)
					})
				}
					.listStyle(.plain)
//				List($viewModel.tasks) { i in
//					Button(action: {
//						selectedTask = i.wrappedValue
//						showingEditTaskSheet = true
//						print(viewModel.tasks)
//					}, label: {
//						TaskListItemView(task: i)
//					})
////					.padding(14)
////					.listRowInsets(EdgeInsets())
////					.listRowSeparator(.hidden)
//				}
				Spacer()
			}
			
		}
		.background(Color.appBackground)
		.onAppear() {
			viewModel.fetchTasks()
		}
		
		.sheet(item: $selectedTask, onDismiss: {
			viewModel.fetchTasks()
		}) { task in
			TaskEditView(task: task)
				.presentationDetents([.medium, .large])
		}
		
		.sheet(isPresented: $showingEditProjectSheet, onDismiss: {
			viewModel.fetchTasks()
		}) {
			ProjectEdit(project: $viewModel.project)
				.presentationDetents([.medium, .large])
		}
		.navigationTitle(viewModel.project.name ?? "Untitled Project")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button("Edit Project") {
					showingEditProjectSheet.toggle()
				}
			}
			ToolbarItem(placement: .bottomBar) {
				Button("Add Task") {
					viewModel.addTask()
				}
			}
			ToolbarItem(placement: .destructiveAction) {
				Button("Delete") {
					viewModel.deleteProject()
					dismiss()
				}
				.tint(.red)
			}
		}
		
	}
	
}


#Preview {
	let c = PersistenceController.preview.container.viewContext
	let project = CoreDataUtility.fetchProjects(context: c, sortDescriptors: [
		NSSortDescriptor(key: "created", ascending: true)], fetchLimit: 1).first!
	
	return NavigationStack() {
		DV(project: project)
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
