//
//  ProjectTodo.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI

struct ProjectTodo: View {
    @Environment(\.modelContext) var context
    
    
    @State var todoData: TodoModel
    
    
    @State var isAlertAppear: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                todoData.isFinished = true
            } label: {
                Circle()
                    .stroke(Color(hex: todoData.project.projectColor), lineWidth: 1)
                    .padding(0.5)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 5)
            
            VStack(alignment: .leading){
                Text(todoData.todoName)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.black)
                
                Text("\(todoData.deadLineDate.format("~ YYYY.M.dd"))")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            .padding(.leading, 4)
            
            Spacer()
            
            Button {
                isAlertAppear = true
            } label: {
                Image(systemName: "ellipsis")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(6)
            .confirmationDialog("", isPresented: $isAlertAppear, titleVisibility: .hidden) {
                Button("Todo 삭제하기", role: .destructive) {
                    todoData.isKilled = true
                    
                    if todoData.deadLineDate.format("YYYYMMdd") == todoData.project.currentEndDate.format("YYYYMMdd") {
                        var project = todoData.project
                        
                        // CHANGE EndDate of Project
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
}
