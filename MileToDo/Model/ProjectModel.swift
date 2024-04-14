//
//  PorjectModel.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftData
import SwiftUI

@Model
class ProjectModel {
    @Attribute(.unique) let id: UUID = UUID()
    var projectName: String
    var isDone: Bool = false
    var projectColor: String
    var createdAt: Date
    var currentEndDate: Date
    
    @Relationship var todoLists: [TodoModel]
    
    init(projectName: String, projectColor: String, createdAt: Date, currentEndDate: Date, todoLists: [TodoModel]) {
        self.projectName = projectName
        self.projectColor = projectColor
        self.createdAt = createdAt
        self.currentEndDate = currentEndDate
        self.todoLists = todoLists
    }
}
