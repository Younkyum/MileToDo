//
//  ProjectAppend.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI
import SwiftData

struct ProjectAppend: View {
    @Environment(\.modelContext) var context
    @Query var projectList: [ProjectModel]
    
    
    @State var projectNameText = ""
    @State var projectStartDate = Date()
    @State var projectMainColorList = ["Blue", "Red", "Orange", "Green", "Purple", "Sky Blue", "Yellow"]
    @State var projectMainColorRawList = ["007AFF", "FF2D55", "FF9500", "5FDE92", "AF52DE", "5AD2FF", "FFCD00"]
    @State var projectMainColor = "Blue"
    
    
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
            .navigationTitle("새 프로잭트 만들기")
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
                    Button("저장") {
                        saveProject()
                        isProjectAppendSheetAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("변경사항 삭제하기", role: .destructive) {
                    isProjectAppendSheetAppear = false
                }
            }
        }
    }
}

#Preview {
    Home()
}


/// List Rows
extension ProjectAppend {
    @ViewBuilder
    func ProjectRow() -> some View {
        Section("Project Name") {
            TextField("Project Name", text: $projectNameText)
                .onChange(of: projectNameText) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        Section {
            DatePicker("Project Start Date", selection: $projectStartDate, displayedComponents: .date)
                .onChange(of: projectStartDate) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        
        Section {
            Picker("Project Main Color", selection: $projectMainColor) {
                ForEach(projectMainColorList, id: \.self) { color in
                    Text(color)
                }
            }
        }
    }
}



/// Save to SwiftData
extension ProjectAppend {
    private func saveProject() {
        var dateLists: [String] = []
        dateLists = [projectStartDate.format("YYYYMMdd")]
        
        let newProject = ProjectModel(projectName: projectNameText,
                                      projectColor: projectMainColorRawList[projectMainColorList.firstIndex(of: projectMainColor)!],
                                      dateLists: dateLists,
                                      orderIndex: projectList.count,
                                      todoLists: [])
        context.insert(newProject)
        
        let _: ()? = try? context.save()
    }
}
