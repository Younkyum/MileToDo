//
//  MilestoneComponents.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/11/24.
//

import SwiftUI

enum MileStoneCase {
    case none, left, right, full, line, only
}



struct MileStoneComponent: View {
    @State var color: Color = .blue
    @State var direction: MileStoneCase = .none
    
    
    var body: some View {
        HStack{
            ZStack {
                LineView()
                CircleView()
            }
            .frame(height: 14)
            .padding(.horizontal, -4)
        }
        .padding(.top, 6)
    }
    
    
    
    @ViewBuilder
    func CircleView() -> some View {
        switch direction {
        case .only:
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
            
            Circle()
                .fill(.backgroundWhite)
                .frame(width: 6, height: 6)
        case .none, .line:
            Rectangle()
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: 4)
        case .left, .right, .full:
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
            
            Circle()
                .fill(.backgroundWhite)
                .frame(width: 6, height: 6)
        }
    }
    
    
    
    
    
    
    @ViewBuilder
    func LineView() -> some View {
        HStack{
            switch direction {
            case .none, .only:
                Rectangle()
                    .fill(.backgroundWhite)
                    .frame(maxWidth: .infinity, maxHeight: 4)
                Rectangle()
                    .fill(.backgroundWhite)
                    .frame(maxWidth: .infinity, maxHeight: 4)
            case .left:
                Rectangle()
                    .fill(color)
                    .frame(maxWidth: .infinity, maxHeight: 4)
                Rectangle()
                    .fill(.backgroundWhite)
                    .frame(maxWidth: .infinity, maxHeight: 4)
            case .right:
                Rectangle()
                    .fill(.backgroundWhite)
                    .frame(maxWidth: .infinity, maxHeight: 4)
                Rectangle()
                    .fill(color)
                    .frame(maxWidth: .infinity, maxHeight: 4)
            case .full, .line:
                Rectangle()
                    .fill(color)
                    .frame(maxWidth: .infinity, maxHeight: 4)
            }
        }
    }
}



#Preview {
    MileStoneComponent(color: .blue, direction: .full)
}
