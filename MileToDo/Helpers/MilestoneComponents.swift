//
//  MilestoneComponents.swift
//  MileToDo
//
//  Created by YounkyumJin on 4/11/24.
//

import SwiftUI

enum MileStoneCase {
    case none, left, right, full, line
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
    }
    
    
    
    @ViewBuilder
    func CircleView() -> some View {
        switch direction {
        case .none, .line:
            Rectangle()
                .fill(Color.clear)
                .frame(width: .infinity, height: 4)
        case .left, .right, .full:
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
            
            Circle()
                .fill(.white)
                .frame(width: 6, height: 6)
        }
    }
    
    
    
    
    
    
    @ViewBuilder
    func LineView() -> some View {
        HStack{
            switch direction {
            case .none:
                Rectangle()
                    .fill(.white)
                    .frame(width: .infinity, height: 4)
                Rectangle()
                    .fill(.white)
                    .frame(width: .infinity, height: 4)
            case .left:
                Rectangle()
                    .fill(color)
                    .frame(width: .infinity, height: 4)
                Rectangle()
                    .fill(.white)
                    .frame(width: .infinity, height: 4)
            case .right:
                Rectangle()
                    .fill(.white)
                    .frame(width: .infinity, height: 4)
                Rectangle()
                    .fill(color)
                    .frame(width: .infinity, height: 4)
            case .full, .line:
                Rectangle()
                    .fill(color)
                    .frame(width: .infinity, height: 4)
            }
        }
    }
}



#Preview {
    MileStoneComponent(color: .blue, direction: .full)
}
