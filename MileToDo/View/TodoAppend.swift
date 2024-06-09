//
//  TodoAppend.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TodoAppend: View {
    @Environment(\.modelContext) var context
    
    @State var todoTitle: String = ""
    @State var isTimeSelected: Bool = false
    @State var deadLineDate: Date = Date()
    @State var notificationPlan: NotificationPlan = .none
    @State var selectedProject: ProjectModel
    
    @State var isChanged: Bool = false
    @State var isSaveAlertAppear: Bool = false
    @State var isRowHidden = true
    @Binding var isTodoAppendSheetAppear: Bool
    @FocusState private var isFocused: Bool
    
    @Query var projectLists: [ProjectModel]
    
    var body: some View {
        NavigationStack {
            List {
                TodoDefaultRow()
                
                DeadLineRow()
                
                if isTimeSelected{
                    NotificationRow()
                }
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("새 투두 생성")
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
                    .disabled(todoTitle.isEmpty)
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("변경사항 삭제", role: .destructive) {
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
        let isNotificationSelected = notificationPlan == .none ? false : true
        let newTodo = TodoModel(todoName: todoTitle,
                                deadLineDate: deadLineDate,
                                project: selectedProject,
                                isTimeSelected: isTimeSelected,
                                isNotificationSelected: isNotificationSelected)
        
        if isNotificationSelected {
            newTodo.notificationPlan = notificationPlan.rawValue
            let notificationManager = NotificationManager(targetModel: newTodo)
            notificationManager.registerNotification()
        }
        
        selectedProject.dateLists.append(deadLineDate.format("YYYYMMdd"))
        selectedProject.dateLists.sort()
        
        context.insert(newTodo)
        selectedProject.todoLists.append(newTodo)
        
        
        let _: ()? = try? context.save()
    }
}


extension TodoAppend {
    @ViewBuilder
    func TodoDefaultRow() -> some View {
        Section("투두 정보") {
            TextField("투두 이름", text: $todoTitle)
                .onChange(of: todoTitle) { oldValue, newValue in
                    isChanged = true
                }
                .focused($isFocused)
            
            Picker("프로젝트", selection: $selectedProject) {
                ForEach(projectLists, id: \.self) { project in
                    Text(project.projectName)
                        .lineLimit(1)
                }
                
            }
        }
    }
}


extension TodoAppend {
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
                .animation(.bouncy, value: UUID())
                
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
        }
    }
}

extension TodoAppend {
    @ViewBuilder
    func NotificationRow() -> some View {
        Section("미리 알림") {
            Picker("미리 알림", selection: $notificationPlan) {
                ForEach(NotificationPlan.allCases, id: \.self) { notificationPlan in
                    if  notificationPlan == .none {
                        Section{
                            Text(notificationPlan.getSting())
                        }
                    } else {
                        Text(notificationPlan.getSting())
                    }
                }
            }
        }
    }
}





