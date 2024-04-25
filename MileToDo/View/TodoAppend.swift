//
//  TodoAppend.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI
import SwiftData

struct TodoAppend: View {
    @Environment(\.modelContext) var context
    
    @State var todoTitle: String = ""
    @State var deadLineDate: Date = Date()
    @State var selectedProject: ProjectModel
    
    @State var isChanged: Bool = false
    @State var isSaveAlertAppear = false
    @Binding var isTodoAppendSheetAppear: Bool
    
    @Query var projectLists: [ProjectModel]
    
    var body: some View {
        NavigationStack {
            List {
                TodoRow()
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Create New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if isChanged {
                            isSaveAlertAppear = true
                        } else {
                            isTodoAppendSheetAppear = false
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveTodo()
                        isTodoAppendSheetAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("Delete Changes", role: .destructive) {
                    isTodoAppendSheetAppear = false
                }
            }
        }
    }
}

#Preview {
    Home()
}


/// Save Todo
extension TodoAppend {
    func saveTodo() {
        let newTodo = TodoModel(todoName: todoTitle,
                                deadLineDate: deadLineDate,
                                project: selectedProject)
        
        selectedProject.dateLists.append(deadLineDate.format("YYYYMMdd"))
        selectedProject.dateLists.sort()
        
        context.insert(newTodo)
        selectedProject.todoLists.append(newTodo)

        
        let _: ()? = try? context.save()
    }
}


/// List Rows
extension TodoAppend {
    @ViewBuilder
    func TodoRow() -> some View {
        Section("Todo Title") {
            TextField("Todo Title", text: $todoTitle)
                .onChange(of: todoTitle) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        Section {
            DatePicker("Todo DeadLine", selection: $deadLineDate, displayedComponents: .date)
                .onChange(of: deadLineDate) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        
        Section {
            Picker("Project", selection: $selectedProject) {
                ForEach(projectLists, id: \.self) { project in
                    Text(project.projectName)
                        .lineLimit(1)
                }
            }
        }
    }
}
