//
//  TodoModel.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftData
import SwiftUI

@Model
class TodoModel {
    let id: UUID = UUID()
    var todoName: String
    var isFinished: Bool = false
    var deadLineDate: Date
    
    init(todoName: String, isFinished: Bool, deadLineDate: Date) {
        self.todoName = todoName
        self.isFinished = isFinished
        self.deadLineDate = deadLineDate
    }
}
