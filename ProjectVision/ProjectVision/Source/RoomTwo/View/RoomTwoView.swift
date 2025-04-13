//
//  RoomTwoView.swift
//  ProjectVision
//
//  Created by minsong kim on 3/25/25.
//

import SwiftUI

struct RoomTwoView: View {
    // MARK: - SwiftUI Properties

    @State private var viewModel: RoomTwoViewModel = .init()

    // MARK: - Content Properties

    var body: some View {
        if viewModel.isComplete {
            VStack {
                Image(.escapeComplete)
                    .resizable()
                    .scaledToFit()

                Text("성공~!")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.black)
            }
        } else if viewModel.isShowingQuestion {
            NavigationStack {
                NavigationLink(destination: RoomTwoCameraView(viewModel: $viewModel)) {
                    Text("인사하러 가기")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.black)
                        }
                }
            }
        } else {
            VStack {
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
    }
}

#Preview {
    RoomTwoView()
}
