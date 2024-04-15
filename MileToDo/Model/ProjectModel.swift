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
    var projectColor: String
    var isSelected: Bool = true
    var dateLists: [String] = []
    
    @Relationship(deleteRule: .cascade) var todoLists: [TodoModel]
    
    init(projectName: String, projectColor: String, dateLists: [String], todoLists: [TodoModel]) {
        self.projectName = projectName
        self.projectColor = projectColor
        self.dateLists = dateLists
        self.todoLists = todoLists
    }
}
