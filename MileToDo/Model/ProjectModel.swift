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
    let id: UUID = UUID()
    var projectName: String
    var isDone: Bool = false
    var createdAt: Date
    var currentEndDate: Date
    
    init(projectName: String, isDone: Bool, createdAt: Date, currentEndDate: Date) {
        self.projectName = projectName
        self.isDone = isDone
        self.createdAt = createdAt
        self.currentEndDate = currentEndDate
    }
}
