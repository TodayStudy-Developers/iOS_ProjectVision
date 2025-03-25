//
//  RoomOneView.swift
//  ProjectVision
//
//  Created by 권승용 on 3/25/25.
//

import SwiftUI

struct RoomOneView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("문제 1.")
                    .font(.largeTitle.bold())
                Spacer()
            }
            Text(Question.first.description)
            Spacer()

            Button { } label: {
                Text("문제 맞추기")
                    .bold()
                    .padding()
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.blue)
                    }
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    RoomOneView()
}
