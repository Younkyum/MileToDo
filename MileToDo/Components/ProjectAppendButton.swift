//
//  ProjectAddButton.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI

struct ProjectAppendButton: View {
    @State var buttonTitle: String = "프로젝트 추가"
    @Binding var isProjectAppendSheetAppear: Bool
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    isProjectAppendSheetAppear = true
                }, label: {
                    
                    Text("프로젝트 추가")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.backgroundWhite)
                        .padding(.vertical, 13.5)
                        .padding(.horizontal, 13)
                        .background(.textBlack)
                        .clipShape(Capsule())
                })
                .padding()
            }
        }
    }
}


#Preview {
    Home()
}
