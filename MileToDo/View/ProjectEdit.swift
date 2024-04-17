//
//  ProjectEdit.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/17/24.
//

import SwiftUI
import SwiftData

struct ProjectEdit: View {
    @Environment(\.modelContext) var context
    @Query var projectList: [ProjectModel]
    @Bindable var targetProject: ProjectModel
    
    
    @State var projectNameText = ""
    @State var projectMainColorList = ["파란색", "빨간색", "노란색", "초록색"]
    @State var projectMainColorRawList = ["007AFF", "FF2D55", "FF9500", "5FDE92"]
    @State var projectMainColor = "파란색"
    
    
    @Binding var isProjectAppendSheetAppear: Bool
    @State var isChanged = false
    @State var isSaveAlertAppear = false
        
    
    var body: some View {
        NavigationStack {
            List {
                ProjectRow()
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("프로젝트 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        if isChanged {
                            isSaveAlertAppear = true
                        } else {
                            isProjectAppendSheetAppear = false
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("편집") {
                        saveProject()
                        isProjectAppendSheetAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("변경 사항 폐기", role: .destructive) {
                    isProjectAppendSheetAppear = false
                }
            }
        }
        .onAppear(perform: {
            projectNameText = targetProject.projectName
            projectMainColor = projectMainColorRawList[projectMainColorList.firstIndex(of: targetProject.projectColor) ?? 0]
        })
    }
}


/// List Rows
extension ProjectEdit {
    @ViewBuilder
    func ProjectRow() -> some View {
        Section {
            TextField("프로젝트 이름 입력", text: $projectNameText)
                .onChange(of: projectNameText) { oldValue, newValue in
                    isChanged = true
                }
        }
        

        Section {
            Picker("프로젝트 메인 색", selection: $projectMainColor) {
                ForEach(projectMainColorList, id: \.self) { color in
                    Text(color)
                }
            }
        }
    }
}



/// Save to SwiftData
extension ProjectEdit {
    private func saveProject() {
        
        targetProject.projectName = projectNameText
        targetProject.projectColor = projectMainColorRawList[projectMainColorList.firstIndex(of: projectMainColor)!]
        
        
        //context.insert(newProject)
        
        let _: ()? = try? context.save()
    }
}
