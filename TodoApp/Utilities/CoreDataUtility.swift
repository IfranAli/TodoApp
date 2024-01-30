//
//  CoreDataUtility.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import Foundation
import CoreData

class CoreDataUtility {
	static func fetchProjects(context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = 0) -> [Project] {
		let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = sortDescriptors
		fetchRequest.fetchLimit = fetchLimit ?? 0
		
		do {
			return try context.fetch(fetchRequest)
		} catch {
			print("Error fetching projects: \(error.localizedDescription)")
			return []
		}
	}
	
	static func fetchTasks(context: NSManagedObjectContext, project: Project) -> [Task] {
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.origin, ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "origin == %@", argumentArray: [project])
		
		do {
			let result = try context.fetch(fetchRequest)
			
			return result
		} catch {
			print("Error tasks: \(error.localizedDescription)")
			return []
		}
	}
}

