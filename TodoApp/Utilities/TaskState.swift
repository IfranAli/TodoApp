//
//  TaskState.swift
//  TodoApp
//
//  Created by Ifran Ali on 26/1/2024.
//

import Foundation
import SwiftUI

enum TaskState: Int, CaseIterable, Identifiable {
	case in_progress, blocked, todo, done
	
	var id: Self { self }
	var description: String {
		switch self {
			case .in_progress: return "In-progress"
			case .blocked: return "Blocked"
			case .todo: return "Todo"
			case .done: return "Done"
		}
	}
	
	var color: Color {
		switch self {
			case .todo: return .secondary
			case .done: return .green
			case .in_progress: return .blue
			case .blocked: return .yellow
		}
	}
	
	public static func toTaskState(_ value: Int16) -> TaskState {
		return TaskState(rawValue: Int(value)) ?? TaskState.todo
	}
}
