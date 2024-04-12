//
//  ProjectAddButton.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/12/24.
//

import SwiftUI

struct ProjectAppendButton: View {
    @State var buttonTitle: String = "프로젝트 추가하기"
    @Binding var isProjectAppendSheetAppear: Bool
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    isProjectAppendSheetAppear = true
                }, label: {
                    Text(buttonTitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.vertical, 13.5)
                        .padding(.horizontal, 13)
                        .background(.black)
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