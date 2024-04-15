//
//  ProjectTodo.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI

struct ProjectTodo: View {
    @Environment(\.modelContext) var context
    
    
    @Bindable var todoData: TodoModel
    
    
    @State var isAlertAppear: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            TodoButton()
            
            if !todoData.isFinished {
                TodoDataText()
            } else {
                TodoDataTextWithStrike()
            }
            Spacer()
            TodoMeetBall()
        }
    }
}

#Preview {
    Home()
}


/// Todo Button
extension ProjectTodo {
    @ViewBuilder
    func TodoButton() -> some View {
        Button {
            if todoData.isFinished {
                todoData.isFinished = false
                todoData.finishedDate = nil
            } else {
                todoData.isFinished = true
                todoData.finishedDate = Date.init()
            }
        } label: {
            if !todoData.isFinished{
                Image(systemName: "circle")
                    .padding(0.5)
                    .foregroundStyle(Color(hex: todoData.project.projectColor))
                    .frame(width: 22, height: 22)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .padding(0.5)
                    .foregroundStyle(Color(hex: todoData.project.projectColor))
                    .frame(width: 22, height: 22)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(.top, 5)
        
    }
}


/// Todo Data Texts
extension ProjectTodo {
    @ViewBuilder
    func TodoDataText() -> some View {
        VStack(alignment: .leading){
            Text(todoData.todoName)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.textBlack)
            
            
            Text("\(todoData.deadLineDate.format("~ YYYY.M.dd"))")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
        .padding(.leading, 4)
    }
    
    @ViewBuilder
    func TodoDataTextWithStrike() -> some View {
        VStack(alignment: .leading){
            Text(todoData.todoName)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.gray)
                .strikethrough()
            
            Text("\(todoData.deadLineDate.format("~ YYYY.M.dd")) | 완료됨: \(todoData.finishedDate?.format("YYYY.M.dd") ?? "2024.04.15")")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
        .padding(.leading, 4)
    }
}


/// Todo MeetBalls
extension ProjectTodo {
    @ViewBuilder
    func TodoMeetBall() -> some View {
        Button {
            isAlertAppear = true
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color(hex: todoData.project.projectColor))
                .frame(width: 20, height: 20)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(6)
        .confirmationDialog("", isPresented: $isAlertAppear, titleVisibility: .hidden) {
            Button("Todo 삭제하기", role: .destructive) {
                todoData.isKilled = true
                //context.delete(todoData)
                todoData.project.dateLists.remove(at: todoData.project.dateLists.firstIndex(of: todoData.deadLineDate.format("YYYYMMdd"))!)
                todoData.project.dateLists.sort()
            }
        }
    }
}
