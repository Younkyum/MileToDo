//
//  TodoModelMigrationPlan.swift
//  MileToDo
//
//  Created by YounkyumJin on 5/12/24.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    /// Migration Target Schmas
    static var schemas: [any VersionedSchema.Type] {
        [TodoSchemaV1.self, TodoSchemaV2.self]
    }
    
    /// Mirgation Stage Plans
    static var stages: [MigrationStage] {
        [todoMigrateV1toV2]
    }
    
    
    /// Migrate V1 to V2
    static let todoMigrateV1toV2 = MigrationStage.lightweight(
        fromVersion: TodoSchemaV1.self, toVersion: TodoSchemaV2.self
    )
}
