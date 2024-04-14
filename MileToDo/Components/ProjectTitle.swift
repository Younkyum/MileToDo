//
//  ProjectTitle.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI

struct ProjectTitle: View {
    @State var projectData: ProjectModel = ProjectModel(projectName: "Apple Developer Acadmey", 
                                                        projectColor: "007AFF",
                                                        createdAt: Date(),
                                                        currentEndDate: Date(), 
                                                        todoLists: [])
    
    @State var isTodoAppendAppear = false
    
    var body: some View {
        HStack {
            Text(projectData.projectName)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(hex: projectData.projectColor))
                .clipShape(Capsule())
            
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
        .sheet(isPresented: $isTodoAppendAppear, content: {
            TodoAppend(selectedProject: projectData, isTodoAppendSheetAppear: $isTodoAppendAppear)
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
