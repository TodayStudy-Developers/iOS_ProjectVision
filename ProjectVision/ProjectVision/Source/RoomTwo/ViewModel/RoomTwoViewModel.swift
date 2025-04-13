//
//  RoomTwoViewModel.swift
//  ProjectVision
//
//  Created by minsong kim on 4/13/25.
//

import Foundation

@Observable
class RoomTwoViewModel {
    // MARK: - Properties

    var currentPage: Int = 0
    var isShowingQuestion: Bool = false
    var isComplete: Bool = false
    let roomQuestion: RoomQuestion =
        .init(storyPages: [Page(description: "강의실을 가야하다니... 너무 귀찮다.",
                                image: .mainCharacter),
                           Page(description: "저번 그 친구를 우리 동아리에 데려오면 좋을 것 같은데",
                                image: .mainCharacter),
                           Page(description: "이번에 강의실에 가면 있으려나?",
                                image: .mainCharacter),
                           Page(description: "오, 다행히 있다!",
                                image: .roomTwo),
                           Page(description: "뭐라고 말을 건네야 하지?",
                                image: .roomTwo),
                           Page(description: "일단 손을 흔들어 인사를 해보자.",
                                image: .roomTwo)],
              answer: "5번 손 흔들기")

    // MARK: - Functions

    func increasePage() {
        if currentPage < roomQuestion.storyPages.count - 1 {
            currentPage += 1
        }
    }

    func decreasePage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}
