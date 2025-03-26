//
//  RoomOneView.swift
//  ProjectVision
//
//  Created by 권승용 on 3/25/25.
//

import SwiftUI

struct RoomOneView: View {
    // MARK: - SwiftUI Properties

    @State private var showCamera: Bool = false
    @State private var hasPhoto: Bool = false
    @State private var imageData: Data?

    // MARK: - Content Properties

    var body: some View {
        VStack(spacing: 16) {
            if hasPhoto {
                RoomOneOCRView(showCamera: $showCamera, imageData: $imageData)
            } else {
                HStack {
                    Text("문제 1.")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                Text(Question.first.description)
                Spacer()

                Button {
                    showCamera = true
                } label: {
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
        }
        .padding()
        .fullScreenCover(isPresented: $showCamera) {
            CameraUI(showCamera: $showCamera, hasPhoto: $hasPhoto, imageData: $imageData)
        }
    }
}

#Preview {
    RoomOneView()
}
