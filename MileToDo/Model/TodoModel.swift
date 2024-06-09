//
//  TodoModel.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftData
import SwiftUI

typealias TodoModel = TodoSchemaV2.TodoModel

/// TodoModel V1 -> 1.0.1부터 1.1.1까지 사용됨
enum TodoSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        return [TodoModel.self]
    }
    
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
}

/// TodoModel V2 -> 1.2.0 부터 X.X.X까지 사용됨
enum TodoSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(1, 0, 1)
    static var models: [any PersistentModel.Type] {
        return [TodoModel.self]
    }
    
    @Model
    public class TodoModel {
        @Attribute(.unique) var id: UUID = UUID()
        var todoName: String
        var finishedDate: Date?
        var isFinished: Bool = false
        var isKilled: Bool = false
        var deadLineDate: Date
        var todoNote: String
        
        /// New in V2
        var isTimeSelected: Bool = false
        var isNotificationSelected: Bool = false
        var notificationPlan: String = NotificationPlan.none.rawValue
        
        @Relationship var project: ProjectModel
        
        init(todoName: String, deadLineDate: Date, project: ProjectModel, todoNote: String = "", isTimeSelected: Bool = false, isNotificationSelected: Bool = false, notificationPlan: String = "none") {
            self.todoName = todoName
            self.deadLineDate = deadLineDate
            self.project = project
            self.todoNote = todoNote
            self.isTimeSelected = isTimeSelected
            self.isNotificationSelected = isNotificationSelected
            self.notificationPlan = notificationPlan
        }
    }
}
