//
//  ProjectEdit.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/23/24.
//

import SwiftUI

struct ProjectEdit: View {
    @Environment(\.modelContext) var context
    
    @Bindable var targetProject: ProjectModel
    @State var targetProjectTitle: String = ""
    @State var projectMainColor = "Blue"
    @State var projectMainColorList = ["Blue", "Red", "Yellow", "Green"]
    @State var projectMainColorRawList = ["007AFF", "FF2D55", "FF9500", "5FDE92"]
    
    
    @Binding var isProjectEditAppear: Bool
    @State var isSaveAlertAppear = false
    @State var isChanged = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ProjectRow()
            }
            .listStyle(.insetGrouped)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if isChanged {
                            isSaveAlertAppear = true
                        } else {
                            isProjectEditAppear = false
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveProject()
                        isProjectEditAppear = false
                    }
                }
            })
            .toolbar(.visible, for: .navigationBar)
            .confirmationDialog("", isPresented: $isSaveAlertAppear, titleVisibility: .hidden) {
                Button("Delete Changes", role: .destructive) {
                    isProjectEditAppear = false
                }
            }
        }
        .onAppear(perform: {
            projectMainColor = projectMainColorList[projectMainColorRawList.firstIndex(of: targetProject.projectColor)!]
            targetProjectTitle = targetProject.projectName
        })
    }
}

#Preview {
    Home()
}


/// List Rows
extension ProjectEdit {
    @ViewBuilder
    func ProjectRow() -> some View {
        Section("Project Name") {
            TextField("Project Name", text: $targetProjectTitle)
                .onChange(of: targetProjectTitle) { oldValue, newValue in
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
extension ProjectEdit {
    private func saveProject() {
        
        targetProject.projectName = targetProjectTitle
        targetProject.projectColor = projectMainColorRawList[projectMainColorList.firstIndex(of: projectMainColor)!]
        
        let _: ()? = try? context.save()
    }
}
