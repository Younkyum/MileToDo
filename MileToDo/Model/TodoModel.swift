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
    @Attribute(.unique) var id: UUID = UUID()
    var todoName: String
    var finishedDate: Date?
    var isFinished: Bool = false
    var isKilled: Bool = false
    var deadLineDate: Date
    var todoNote: String
    
    @Relationship var project: ProjectModel
    
    init(todoName: String, deadLineDate: Date, project: ProjectModel, todoNote: String = "") {
        self.todoName = todoName
        self.deadLineDate = deadLineDate
        self.project = project
        self.todoNote = todoNote
    }
}
