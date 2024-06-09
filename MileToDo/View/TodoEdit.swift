//
//  TodoEdit.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/17/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TodoEdit: View {
    @Environment(\.modelContext) var context
    
    @State var todoTitle: String = ""
    @State var isTimeSelected: Bool = false
    @State var deadLineDate: Date = Date()
    @State var notificationPlan: NotificationPlan = NotificationPlan.none
    @State var selectedProject: ProjectModel
    
    @State var isChanged: Bool = false
    @State var isSaveAlertAppear: Bool = false
    @State var isRowHidden = true
    
    
    @Bindable var targetTodo: TodoModel
    @Binding var isTodoSheetAppear: Bool
    
    
    @Query var projectLists: [ProjectModel]
    
    var body: some View {
        NavigationStack {
            List {
                TodoDefaultRow()
                
                DeadLineRow()
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("투두 편집하기")
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
                Button("변경사항 삭제하기", role: .destructive) {
                    isTodoSheetAppear = false
                }
            }
        }
        .onAppear(perform: {
            todoTitle = targetTodo.todoName
            deadLineDate = targetTodo.deadLineDate
            isTimeSelected = targetTodo.isTimeSelected
            selectedProject = targetTodo.project
            isTimeSelected = targetTodo.isTimeSelected
            let tempNotificationPlan = NotificationPlan(rawValue: targetTodo.notificationPlan)
            notificationPlan = tempNotificationPlan ?? NotificationPlan.none
            
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
        targetTodo.isTimeSelected = isTimeSelected
        targetTodo.project = selectedProject
        
        if targetTodo.notificationPlan != notificationPlan.rawValue {
            targetTodo.notificationPlan = notificationPlan.rawValue
            let notificationManager = NotificationManager(targetModel: targetTodo)
            notificationManager.removeNotification()
            notificationManager.registerNotification()
        }
        
        if notificationPlan == .none {
            let notificationManager = NotificationManager(targetModel: targetTodo)
            notificationManager.removeNotification()
            targetTodo.notificationPlan = notificationPlan.rawValue
        }
        
        
        let _: ()? = try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}


extension TodoEdit {
    @ViewBuilder
    func TodoDefaultRow() -> some View {
        Section("투두 정보") {
            TextField("제목", text: $todoTitle)
                .onChange(of: todoTitle) { oldValue, newValue in
                    isChanged = true
                }
            
            Picker("프로젝트", selection: $selectedProject) {
                ForEach(projectLists, id: \.self) { project in
                    Text(project.projectName)
                        .lineLimit(1)
                }
                
            }
        }
    }
}


extension TodoEdit {
    @ViewBuilder
    func DeadLineRow() -> some View {
        Section("데드라인") {
            
            DatePicker("날짜", selection: $deadLineDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .onChange(of: deadLineDate) { oldValue, newValue in
                    isChanged = true
                }
            
            
            HStack{
                VStack(alignment: .leading) {
                    Text("시간")
                    if isTimeSelected {
                        Text(deadLineDate.format("a h:mm"))
                            .foregroundStyle(.blue)
                            .font(.system(size: 13))
                    }
                }
                
                Spacer()
                
                Toggle(isOn: $isTimeSelected, label: {})
                    .onChange(of: isTimeSelected) { oldValue, newValue in
                        isRowHidden = false
                    }
                    
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isRowHidden.toggle()
            }
            .animation(.bouncy, value: UUID())
            
            
            if !isRowHidden && isTimeSelected  {
                DatePicker(selection: $deadLineDate, displayedComponents: .hourAndMinute) {
                    Text("")
                }
                .datePickerStyle(.wheel)
            }
            
            if isTimeSelected {
                Picker("미리 알림", selection: $notificationPlan) {
                    ForEach(NotificationPlan.allCases, id: \.self) { notificationPlan in
                        Text(notificationPlan.getSting())
                    }
                }
            }
        }
    }
}
