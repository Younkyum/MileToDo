//
//  SharedModelContext.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/29/24.
//

import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        TodoModel.self,
        ProjectModel.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
