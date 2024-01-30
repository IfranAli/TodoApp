//
//  Priority.swift
//  TodoApp
//
//  Created by Ila Luvox on 26/1/2024.
//

import Foundation
import SwiftUI

enum Priority: Int, CaseIterable, Identifiable {
	case lowest, low, medium, high, highest
	var id: Self { self }
	var description: String {
		switch self {
		case .lowest: return "Lowest"
		case .low: return "Low"
		case .medium: return "Medium"
		case .high: return "High"
		case .highest: return "Highest"
		}
	}
	
	var color: Color {
		switch self {
		case .medium: return .blue
		case .high: return .orange
		case .highest: return .red
		default:
			return Color.secondary
		}
	}
	
	public static func toPriority(_ value: Int16) -> Priority {
		return Priority(rawValue: Int(value)) ?? Priority.medium
	}
}
