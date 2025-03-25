//
//  RoomTwoView.swift
//  ProjectVision
//
//  Created by minsong kim on 3/25/25.
//

import SwiftUI

struct RoomTwoView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("문제 2.")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Text(RoomTwoQuestion.first.description)
                .lineSpacing(4)
            Button("인사하러 가기") { }
                .bold()
                .padding()
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.blue)
                }
        }
        .padding()
    }
}

#Preview {
    RoomTwoView()
}
