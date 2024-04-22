//
//  ProjectDetail.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/15/24.
//

import SwiftUI
import SwiftData

struct ProjectDetail: View {
    @Query(sort: \ProjectModel.orderIndex) var projectList: [ProjectModel]
    @Binding var isProjectDetailSheetAppear: Bool
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack {
            List {
                Section("Show/Hide and Change Order") {
                    ForEach(projectList, id: \.id) { project in
                        HStack {
                            Button {
                                project.isSelected.toggle()
                            } label: {
                                if !project.isSelected {
                                    Image(systemName: "circle")
                                        .resizable()
                                        .padding(0.5)
                                        .foregroundStyle(Color(hex: project.projectColor))
                                        .frame(width: 22, height: 22)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .padding(0.5)
                                        .foregroundStyle(Color(hex: project.projectColor))
                                        .frame(width: 22, height: 22)
                                }
                            }


                            Text(project.projectName)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let project = projectList[index]
                            context.delete(project)
                            try? context.save()
                        }
                    }
                    .onMove { source, destination in
                        var tempList = projectList
                        tempList.move(fromOffsets: source, toOffset: destination)
                        
                        for (i, tempProject) in tempList.enumerated() {
                            if let project = projectList.filter( {$0.id == tempProject.id} ).first {
                                project.orderIndex = i
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Projects")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isProjectDetailSheetAppear = false
                    }
                }
                
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
            })
            .toolbar(.visible, for: .navigationBar)
        }
        
    }
}

#Preview {
    Home()
}


