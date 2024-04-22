//
//  TodoDetail.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/16/24.
//

import SwiftUI
import SwiftData

struct TodoDetail: View {
    @Environment(\.modelContext) var context
    @Query(filter: #Predicate<TodoModel> { todo in !todo.isKilled})
    var todoList: [TodoModel]
    
    @State var todoSeachText = ""
    @Binding var isTodoDetailSheetAppear: Bool
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchedTodoList, id: \.id) { todo in
                    HStack {
                        TodoIndicator(todo)
                        
                        if todo.isFinished {
                            TodoDataTextWithStrike(todo)
                        } else {
                            TodoDataText(todo)
                        }
                    }
                }
            }
            .searchable(text: $todoSeachText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(.plain)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Todos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isTodoDetailSheetAppear = false
                    }
                }                
            })
            .toolbar(.visible, for: .navigationBar)
        }
    }
    
    
    var searchedTodoList: [TodoModel] {
        if todoSeachText == "" {
            return todoList
        } else {
            return todoList.filter { $0.todoName.contains(todoSeachText) || $0.project.projectName.contains(todoSeachText) || $0.deadLineDate.format("YYYY.M.d").contains(todoSeachText) }
        }
    }
}


extension TodoDetail {
    @ViewBuilder
    func TodoIndicator(_ todoData: TodoModel) -> some View {
            Image(systemName: "circle.fill")
                .padding(0.5)
                .foregroundStyle(Color(hex: todoData.project.projectColor))
                .frame(width: 22, height: 22)

        
        
    }
}


extension TodoDetail {
    @ViewBuilder
    func TodoDataText(_ todoData: TodoModel) -> some View {
        VStack(alignment: .leading){
            HStack {
                Text(todoData.todoName)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.textBlack)
                
            }
            
            Text("\(todoData.project.projectName) | \(todoData.deadLineDate.format("~ YYYY.M.d"))")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
        .padding(.leading, 4)
    }
    
    @ViewBuilder
    func TodoDataTextWithStrike(_ todoData: TodoModel) -> some View {
        VStack(alignment: .leading){
            Text(todoData.todoName)
                .lineLimit(1)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.gray)
                .strikethrough()
            
            Text("\(todoData.project.projectName) | \(todoData.deadLineDate.format("~ YYYY.M.d")) | Done: \(todoData.finishedDate?.format("YYYY.M.d") ?? "2024.04.15")")
                .lineLimit(1)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
        .padding(.leading, 4)
    }
}
