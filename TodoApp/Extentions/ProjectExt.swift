//
//  ProjectExt.swift
//  TodoApp
//
//  Created by Ifran Ali on 29/1/2024.
//

import Foundation
import SwiftUI

extension Project {
	public var projectColor: Color {
		if let color = self.color {
			return Color.init(hex: color)
		}
		
		return Color.card
	}
}
