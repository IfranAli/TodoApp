//
//  Persistence.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
		
		// Setup test data
		let project = Project(context: viewContext)
		project.name = "First Project 1"
		project.summary = "Summary Here"
		project.color = "#FB4934"
		project.created = DateUtility.dateFromStr(dateStr: "20/01/2024 10:30");
		
		let project2 = Project(context: viewContext)
		project2.name = "Another Project 2"
		project2.summary = "Another Summary"
		project2.color = "#B8BB26"
		project2.created = DateUtility.dateFromStr(dateStr: "25/01/2024 12:30");

		let project3 = Project(context: viewContext)
		project3.name = "Custom Project 3"
		project3.summary = "Custom Summary"
		project3.color = "#FABD2F"
		project3.created = DateUtility.dateFromStr(dateStr: "26/01/2024 14:30");
		
        do {
            try viewContext.save()
		} catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
		
		let task1 = Task(context: viewContext)
		task1.origin = project
		task1.name = "Task 1"
		task1.priority = Int16(Priority.low.rawValue)
		task1.created = DateUtility.dateFromStr(dateStr: "24/01/2024 10:30");
		task1.state = Int16(TaskState.todo.rawValue)
		
		let task2 = Task(context: viewContext)
		task2.origin = project
		task2.name = "Task 2"
		task2.summary = "Task 2 summary"
		task2.priority = Int16(Priority.medium.rawValue)
		task2.created = DateUtility.dateFromStr(dateStr: "25/01/2024 10:30");
		task2.state = Int16(TaskState.in_progress.rawValue)
		
		let task3 = Task(context: viewContext)
		task3.origin = project
		task3.name = "Task 3"
		task3.summary = "Task 3 summary"
		task3.priority = Int16(Priority.high.rawValue)
		task3.created = DateUtility.dateFromStr(dateStr: "26/01/2024 10:30");
		task3.state = Int16(TaskState.done.rawValue)
		
		let task4 = Task(context: viewContext)
		task4.origin = project
		task4.name = "Task 4"
		task4.summary = "Task 4 summary"
		task4.priority = Int16(Priority.high.rawValue)
		task4.created = DateUtility.dateFromStr(dateStr: "26/01/2024 11:30");
		task4.state = Int16(TaskState.blocked.rawValue)
		
		let task5 = Task(context: viewContext)
		task5.origin = project2
		task5.name = "Task 5 project 2"
		task5.summary = "Task 5 summary"
		task5.priority = Int16(Priority.high.rawValue)
		task5.created = DateUtility.dateFromStr(dateStr: "26/01/2024 11:30");
		task5.state = Int16(TaskState.todo.rawValue)

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
