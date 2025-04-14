//
//  DialogueBox.swift
//  ProjectVision
//
//  Created by 권승용 on 3/27/25.
//

import SwiftUI

/// 대화창을 나타내는 뷰
struct DialogueBox: View {
    // MARK: - Properties

    let text: String
    let action: () -> Void

    // MARK: - Content Properties

    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                Button {
                    action()
                } label: {
                    Text("Next")
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.gray)
                        }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 1)
        }
    }
}
