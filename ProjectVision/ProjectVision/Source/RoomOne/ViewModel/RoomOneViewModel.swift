//
//  RoomOneViewModel.swift
//  ProjectVision
//
//  Created by 권승용 on 3/27/25.
//

import Foundation

/// 첫번째 방을 나타내는 뷰모델
@Observable
class RoomOneViewModel {
    // MARK: - Properties

    var currentPage: Int = 0
    var isShowingQuestion: Bool = false
    let roomQuestion: RoomQuestion =
        .init(storyPages: [Page(description: "이곳은 아주 특이한 학교...\n주기적으로 열림 공간이 생겨난다.",
                                image: .roomOneImage1),
                           Page(description: "열림 공간에 적혀 있는 문제를 풀어서 닫지 않는다면, 아주 끔찍한 일이 생긴다...",
                                image: .roomOneImage1),
                           Page(description: "나는 이를 막기 위해생겨난 교내 공간 개척 동아리의 일원으로 생명과학과에 있는 공간을 배정받게 되었다.",
                                image: .roomOneImage1),
                           Page(description: "잘 모르는 분야라 생명과학 개론 과목을 청강하고 있다.",
                                image: .roomOneImage1),
                           Page(description: "자료를 찾으러 도서관에 가봐야겠다...",
                                image: .roomOneImage1),
                           Page(description: "어라? 생명과학 코너에 누가 있네.\n전공자인가? 수업 때 봤던 친구 같은데.",
                                image: .roomOneImage2),
                           Page(description: "어쩌면 답을 알고 있지 않을까?\n쪽지로 질문을 남겨봐야겠다.",
                                image: .roomOneImage2)],
              answer: "물")

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
