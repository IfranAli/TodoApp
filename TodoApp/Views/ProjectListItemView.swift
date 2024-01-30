//
//  ProjectListItemView.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import SwiftUI

struct ProjectListItemView: View {
	
	@State var project: Project
	
	private var completed: Int {
		return project.task?.filtered(using: NSPredicate(format: "state = 0")).count ?? 0
	}
	
	private var tasksCount : Int {
		project.task?.count ?? 0
	}
	
	private var priority: Priority {
		Priority.toPriority(project.priority)
	}
	
	var body: some View {
		HStack {
			
			RoundedRectangle(cornerRadius: 2)
				.fill(project.projectColor)
				.frame(width: 10, height: 70)
			
			VStack(alignment: .leading) {
				
				// Task counter
				HStack {
					Text(project.name ?? "Untitled")
						.font(.callout)
					
					Spacer()
					
					HStack {
						Text("\(completed)/\(tasksCount)")
					}
					.font(.caption)
				}
				
				// Summary
				Text(project.summary ?? "No description available")
					.font(.footnote)
					.foregroundColor(.secondary)
				
				// Status
				HStack(alignment: .bottom, spacing: 2) {
					
					PriorityView(priorityValue: $project.priority)
					
					Spacer()
					
					if let date = project.created {
						Image(systemName: "clock")
						Text(DateUtility.format(date: date))
					}
					
				}
				.padding(.top, 2)
				.font(.caption)
				.foregroundColor(Color.secondary)
			}
		}
//		.padding(12)
//		.background(Color.uiBackground)
//		.clipShape(RoundedRectangle(cornerRadius: 10))
	}
	
}

#Preview {
	let c = PersistenceController.preview.container.viewContext
	let project = CoreDataUtility.fetchProjects(context: c, sortDescriptors: [
		NSSortDescriptor(key: "created", ascending: true)], fetchLimit: 1).first!
	
	return ProjectListItemView(project: project)
}
