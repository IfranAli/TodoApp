//
//  ContentView.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
	
	var body: some View {
		TabView {
			NavigationStack {
				Dashboard()
			}
			.tabItem {
				Label("Dashboard", systemImage: "chart.bar")
			}
				
			ProjectsView()
			.tabItem {
				Label("Projects", systemImage: "list.bullet")
			}
		}
	}

}


#Preview {
	ContentView()
		.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
