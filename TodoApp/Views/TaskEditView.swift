//
//  TaskEditView.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import SwiftUI
import CoreData

struct TaskEditView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.dismiss) var dismiss
	
	@State var task: Task
	@State var name = ""
	@State var summary = ""
	@State var priority: Priority = .medium
	@State var state: TaskState = .todo
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			
			VStack(alignment: .leading, spacing: 10) {
				TextField("Task title", text: $name)
					.font(.title3)
				
				Divider()
				
				VStack {
					TextEditor(text: $summary)
						.font(.callout)
						.scrollContentBackground(.hidden)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.background(Color.uiBackground)
						.cornerRadius(10)
				}
				
			}
			
			HStack {
				PriorityPicker(selectedPriority: $priority)
					.pickerStyle(.menu)
				
				Picker("State", selection: $state) {
					ForEach(TaskState.allCases) { state in
						Text(state.description).tag(state)
					}
				}
			}
			
			HStack {
				
				Button("Dismiss") {
					withAnimation {
						dismiss()
					}
				}
				.padding(8)
				.cornerRadius(10)
				
				Spacer()
				
				Button("Save") {
					withAnimation {
						task.name = name
						task.summary = summary
						task.priority = Int16(priority.rawValue)
						task.state = Int16(state.rawValue)
						
						if let _ = try? viewContext.save() {
							dismiss()
						}
					}
				}
			}
			
		}
		.padding(20)
		.background(Color.appBackground)
		.onDisappear() {
		}
		.onAppear() {
			self.name = task.name ?? ""
			self.summary = task.summary ?? ""
			self.priority = Priority.toPriority(task.priority)
			self.state = TaskState.toTaskState(task.state)
		}
	}

}

#Preview {
	let c = PersistenceController.preview.container.viewContext

	let project = CoreDataUtility.fetchProjects(context: c, sortDescriptors: [
		NSSortDescriptor(key: "created", ascending: true)], fetchLimit: 1).first!
	let tasks = CoreDataUtility.fetchTasks(context: c, project: project)
	
	return NavigationStack() {
		TaskEditView(
			task: tasks.first!
		)
		.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
