//
//  RoomOneView.swift
//  ProjectVision
//
//  Created by 권승용 on 3/25/25.
//

import SwiftUI

/// 첫번째 방 문제를 나타내는 뷰
struct RoomOneView: View {
    // MARK: - SwiftUI Properties

    @State private var showCamera: Bool = false
    @State private var hasPhoto: Bool = false
    @State private var imageData: Data?
    @State private var viewModel: RoomOneViewModel = .init()

    // MARK: - Content Properties

    var body: some View {
        VStack {
            if hasPhoto {
                RoomOneOCRView(showCamera: $showCamera, imageData: $imageData)
            } else if viewModel.isShowingQuestion {
                Image(.roomOneQuesion)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)

                Button {
                    showCamera = true
                } label: {
                    Text("답장해 주러 가기")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.black)
                        }
                }
                .padding(.top, 50)

            } else {
                Image(viewModel.roomQuestion.storyPages[viewModel.currentPage].image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)

                DialogueBox(text: viewModel.roomQuestion.storyPages[viewModel.currentPage]
                    .description) {
                        if viewModel.currentPage == viewModel.roomQuestion.storyPages.count - 1 {
                            viewModel.isShowingQuestion = true
                        } else {
                            viewModel.increasePage()
                        }
                    }
                    .padding()
                    .frame(height: 200)
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraUI(showCamera: $showCamera, hasPhoto: $hasPhoto, imageData: $imageData)
        }
    }
}

#Preview {
    RoomOneView()
}
