//
//  PriorityView.swift
//  TodoApp
//
//  Created by Ifran Ali on 29/1/2024.
//

import SwiftUI

struct PriorityView: View {
	@Binding var priorityValue: Int16
	
	private var priority: Priority {
		return Priority.toPriority(Int16(priorityValue))
	}
	
	var body: some View {
		
		HStack(alignment: .bottom, spacing: 2) {
			Image(systemName: "arrow.up.arrow.down.square")
//				.foregroundColor(.secondary)
			Text(priority.description)
		}
		.foregroundStyle(priority.color)
    }
}

#Preview {
	List {
		PriorityView(priorityValue: .constant(0))
		PriorityView(priorityValue: .constant(1))
		PriorityView(priorityValue: .constant(2))
		PriorityView(priorityValue: .constant(3))
		PriorityView(priorityValue: .constant(4))
	}
	.font(.caption)
}
