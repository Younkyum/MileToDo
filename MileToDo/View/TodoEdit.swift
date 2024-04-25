//
//  TodoEdit.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/17/24.
//

import SwiftUI
import SwiftData

struct TodoEdit: View {
    @Environment(\.modelContext) var context
    
    @State var todoTitle = ""
    @State var deadLineDate = Date()
    @State var selectedProject: ProjectModel
    
    @State var isChanged = false
    @State var isSaveAlertAppear = false
    
    
    @Bindable var targetTodo: TodoModel
    @Binding var isTodoSheetAppear: Bool
    
    
    @Query var projectLists: [ProjectModel]
    
    var body: some View {
        NavigationStack {
            List {
                TodoRow()
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Edit Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if isChanged {
                            isSaveAlertAppear = true
                        } else {
                            isTodoSheetAppear = false
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveTodo()
                        isTodoSheetAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("Delete Changes", role: .destructive) {
                    isTodoSheetAppear = false
                }
            }
        }
        .onAppear(perform: {
            todoTitle = targetTodo.todoName
            deadLineDate = targetTodo.deadLineDate
            selectedProject = targetTodo.project
        })
    }
}

#Preview {
    Home()
}


/// Save Todo
extension TodoEdit {
    func saveTodo() {
        if deadLineDate != targetTodo.deadLineDate {
            targetTodo.project.dateLists.append(deadLineDate.format("YYYYMMdd"))
            targetTodo.project.dateLists.remove(at: targetTodo.project.dateLists.firstIndex(of: targetTodo.deadLineDate.format("YYYYMMdd"))!)
            targetTodo.project.dateLists.sort()
        }
        
        targetTodo.todoName = todoTitle
        targetTodo.deadLineDate = deadLineDate
        targetTodo.project = selectedProject
        
        let _: ()? = try? context.save()
    }
}


/// List Rows
extension TodoEdit {
    @ViewBuilder
    func TodoRow() -> some View {
        Section("Todo Title") {
            TextField("Todo Title", text: $todoTitle)
                .onChange(of: todoTitle) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        Section {
            DatePicker("Todo Deadline", selection: $deadLineDate, displayedComponents: .date)
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
