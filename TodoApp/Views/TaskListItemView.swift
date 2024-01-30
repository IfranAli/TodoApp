//
//  TaskListItemView.swift
//  TodoApp
//
//  Created by Ifran Ali on 25/1/2024.
//

import SwiftUI

struct TaskListItemView: View {
	@Binding var task: Task
	
	private var state: TaskState {
		return TaskState.toTaskState(task.state)
	}
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				
				HStack {
					
					if state == .done {
						Text(task.name ?? "Untitled")
							.strikethrough()
							.font(.callout)
							.foregroundStyle(.secondary)
					} else {
						Text(task.name ?? "Untitled")
							.font(.callout)
					}
					
					Spacer()
					
					Text(state.description)
						.bold()
						.foregroundStyle(state.color)
						.font(.caption)
				}
				
				Text(task.summary ?? "No Summary")
					.lineLimit(1)
					.font(.footnote)
					.foregroundColor(.secondary)
				
				HStack(alignment: .bottom) {
					
					PriorityView(priorityValue: $task.priority)
					
					Spacer()
					
					if let date = task.created {
						Image(systemName: "clock")
						Text(DateUtility.format(date: date))
					}
					
				}
				.font(.caption)
				.foregroundColor(.secondary)
			}
			Spacer()
			
		}
	}
}

#Preview {
	let c = PersistenceController.preview.container.viewContext
	let project = CoreDataUtility.fetchProjects(context: c, sortDescriptors: [
		NSSortDescriptor(key: "created", ascending: true)], fetchLimit: 1).first!
	
	if let firstTask = (project.task?.allObjects as! [Task]).first {
		return TaskListItemView(task: .constant(firstTask))
	}
	
	return EmptyView()
}
