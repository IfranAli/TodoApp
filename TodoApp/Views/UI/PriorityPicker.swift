//
//  PriorityPicker.swift
//  TodoApp
//
//  Created by Ifran Ali on 26/1/2024.
//

import SwiftUI

struct PriorityPicker: View {
	@Binding var selectedPriority: Priority
	
	var body: some View {
		Picker("Priority", selection: $selectedPriority) {
			ForEach(Priority.allCases) { priority in
				Text(priority.description).tag(priority)
			}
		}
	}
}

#Preview {
	@State var selectedPriority: Priority = .high
	
	return NavigationStack() {
		PriorityPicker(selectedPriority: $selectedPriority)
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
