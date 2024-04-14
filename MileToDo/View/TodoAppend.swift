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
            .navigationTitle("새로운 투두 생성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        if isChanged {
                            isSaveAlertAppear = true
                        } else {
                            isTodoAppendSheetAppear = false
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        saveTodo()
                        isTodoAppendSheetAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("변경 사항 폐기", role: .destructive) {
                    isTodoAppendSheetAppear = false
                }
            }
        }
    }
}

#Preview {
    Home()
}


extension TodoAppend {
    func saveTodo() {        
        let newTodo = TodoModel(todoName: todoTitle,
                                deadLineDate: deadLineDate,
                                project: selectedProject)
        
        print(selectedProject.currentEndDate)
        
        if (selectedProject.currentEndDate.format("YYYYMMdd") < deadLineDate.format("YYYYMMdd")) {
            selectedProject.currentEndDate = deadLineDate
        }
        
        print(selectedProject.currentEndDate)
        
        context.insert(newTodo)
        selectedProject.todoLists.append(newTodo)
        
        let _: ()? = try? context.save()
    }
}


/// List Rows
extension TodoAppend {
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
                }
            }
        }
    }
}