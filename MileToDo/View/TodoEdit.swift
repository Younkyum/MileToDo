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
            .navigationTitle("투두 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        if isChanged {
                            isSaveAlertAppear = true
                        } else {
                            isTodoSheetAppear = false
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        saveTodo()
                        isTodoSheetAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("변경 사항 폐기", role: .destructive) {
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
        Section {
            TextField("투두 입력", text: $todoTitle)
                .onChange(of: todoTitle) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        Section {
            DatePicker("데드라인 설정", selection: $deadLineDate, displayedComponents: .date)
                .onChange(of: deadLineDate) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        
        Section {
            Picker("프로젝트", selection: $selectedProject) {
                ForEach(projectLists, id: \.self) { project in
                    Text(project.projectName)
                        .lineLimit(1)
                }
            }
        }
    }
}
