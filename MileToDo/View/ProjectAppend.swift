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
    
    
    @State var projectNameText = ""
    @State var projectStartDate = Date()
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
            .navigationTitle("새로운 프로젝트 생성")
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
                Button("변경 사항 폐기", role: .destructive) {
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
        Section {
            TextField("프로젝트 이름 입력", text: $projectNameText)
                .onChange(of: projectNameText) { oldValue, newValue in
                    isChanged = true
                }
        }
        
        Section {
            DatePicker("시작 날짜 설정", selection: $projectStartDate, displayedComponents: .date)
                .onChange(of: projectStartDate) { oldValue, newValue in
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
extension ProjectAppend {
    private func saveProject() {
        var dateLists: [String] = []
        dateLists = [projectStartDate.format("YYYYMMdd")]
        
        let newProject = ProjectModel(projectName: projectNameText,
                                      projectColor: projectMainColorRawList[projectMainColorList.firstIndex(of: projectMainColor)!],
                                      dateLists: dateLists,
                                      todoLists: [])
        context.insert(newProject)
        
        let _: ()? = try? context.save()
    }
}
