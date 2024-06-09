//
//  ProjectTitle.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI

struct ProjectTitle: View {
    @Bindable var projectData: ProjectModel    
    @State var isTodoAppendAppear = false
    @State var isProjectEditAppear = false
    
    @State var isTodoAppendDataIsSavable = false
    @State var isTodoAppendShowAlertSheet = false
    
    var body: some View {
        HStack {
            Text(projectData.projectName)
                .font(.system(size: 14, weight: .regular))
                .lineLimit(1)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(hex: projectData.projectColor))
                .clipShape(Capsule())
            
            
            Button(action: {
                isProjectEditAppear = true
            }, label: {
                Image(systemName: "pencil")
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(Color(hex: projectData.projectColor))
                    .clipShape(Circle())
            })
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {
                isTodoAppendAppear = true
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(Color(hex: projectData.projectColor))
                    .clipShape(Circle())
            })
            .buttonStyle(BorderlessButtonStyle())
        }
        .listRowSeparator(.hidden)
        .sheet(isPresented: $isTodoAppendAppear,onDismiss: {
            if isTodoAppendDataIsSavable {
                isTodoAppendShowAlertSheet = true
            }
        }, content: {
            TodoAppend(selectedProject: projectData, isTodoAppendSheetAppear: $isTodoAppendAppear)
        })
        .sheet(isPresented: $isProjectEditAppear, content: {
            ProjectEdit(targetProject: projectData, isProjectEditAppear: $isProjectEditAppear)
        })

    }
}

#Preview {
    Home()
}


extension ProjectTitle {
    func setColor() {
        
    }
}
