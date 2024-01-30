//
//  ProjectEdit.swift
//  TodoApp
//
//  Created by Ifran Ali on 24/1/2024.
//

import SwiftUI

struct ProjectEdit: View {
    @Environment(\.managedObjectContext) private var viewContext
	@Environment(\.dismiss) var dismiss
	
	@Binding var project: Project
	@State var name = ""
	@State var summary = ""
	@State var priority: Priority = .medium
	@State var selectedColor: Color = .red
	
    var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			
			HStack {
				Text("").font(.callout).bold().foregroundStyle(.link)
				ColorPicker("Color", selection: $selectedColor)
				.labelsHidden()
				
				Spacer()
				
				Button("Save") {
					withAnimation {
						project.name = name
						project.summary = summary
						project.priority = Int16(priority.rawValue)
						project.color = selectedColor.toHex()
						
						do {
							try viewContext.save()
							dismiss()
						} catch {
							let nsError = error as NSError
							fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
						}
						
					}
				}
			}
			
			TextField("Title", text: $name)
				.textFieldStyle(.roundedBorder)
			
			TextEditor(text: $summary)
				.textFieldStyle(.roundedBorder)
				.cornerRadius(10)
			
			VStack {
				
				GroupBox {
					HStack {
						Text("Priority: ").font(.callout).bold()
						PriorityPicker(selectedPriority: $priority)
							.pickerStyle(.menu)
						
						Spacer()
					}
				}
				
			}
			
		}
		.padding()
		.background(Color.appBackground)
		.onAppear() {
			self.name = project.name ?? ""
			self.summary = project.summary ?? ""
			self.priority = Priority(rawValue: Int(project.priority )) ?? Priority.medium
			self.selectedColor = project.projectColor
		}
		.onDisappear() {
		}
	}
	
}

#Preview {
	let c = PersistenceController.preview.container.viewContext
	let p = Project(context: c)
	p.name = "Test Project"
	p.summary = "My project summary"
	p.created = Date();
	
	return NavigationStack() {
		ProjectEdit(project: .constant(p))
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
