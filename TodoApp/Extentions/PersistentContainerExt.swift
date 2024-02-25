//
//  PersistenceControllerExt.swift
//  TodoApp
//
//  Created by Ifran Ali on 25/2/2024.
//

import Foundation
import CoreData

extension NSPersistentContainer {
	
	private var focusedProjectKey: String {
		return "focusedProject"
	}
	
	var focusedProject: Project? {
		get {
			
			guard let url = UserDefaults.standard.url(forKey: focusedProjectKey) else {
				return nil
			}
			
			guard let managedObjectID = persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
				return nil
			}
			
			return viewContext.object(with: managedObjectID) as? Project
		}
		
		set {
			guard let newValue = newValue else {
				UserDefaults.standard.removeObject(forKey: focusedProjectKey)
				return
			}
			
			UserDefaults.standard.set(newValue.objectID.uriRepresentation(), forKey: focusedProjectKey)
		}
	}
}
