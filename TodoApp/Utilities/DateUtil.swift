//
//  DateUtil.swift
//  TodoApp
//
//  Created by Ifran Ali on 29/1/2024.
//

import Foundation

class DateUtility {
	
	// Date object from date string.
	static func dateFromStr(dateStr: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
		
		guard let date = dateFormatter.date(from: dateStr) else {
			return nil
		}
		
		return date
	}
	
	// Format date object to standard date format.
	static func format(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
		
		return dateFormatter.string(from: date)
	}
	
	private let itemFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()
}
