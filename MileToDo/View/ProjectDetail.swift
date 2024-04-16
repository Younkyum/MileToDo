//
//  ProjectDetail.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/15/24.
//

import SwiftUI
import SwiftData

struct ProjectDetail: View {
    @Query var projectList: [ProjectModel]
    @Binding var isProjectDetailSheetAppear: Bool
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack {
            List {
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
                        .buttonStyle(BorderlessButtonStyle())


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
                .onMove { from, to in
                    //projectList.move(fromOffsets: from, toOffset: to)
                }
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("등록된 프로젝트 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        isProjectDetailSheetAppear = false
                    }
                }
                
                
                ToolbarItem(placement: .topBarTrailing) {
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


