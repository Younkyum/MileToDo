//
//  MileToDoApp.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/11/24.
//

import SwiftUI
import SwiftData

@main
struct MileToDoApp: App {
    
    var modelContainer: ModelContainer = {
        let schema = Schema([ProjectModel.self, TodoModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could Not Create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
