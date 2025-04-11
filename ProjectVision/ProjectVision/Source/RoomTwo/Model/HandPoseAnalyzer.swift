//
//  HandPoseAnalyzer.swift
//  ProjectVision
//
//  Created by 이명지 on 3/28/25.
//

import Vision

class HandPoseAnalyzer {
    // MARK: - Properties

    private var handShakeCount: Int = 0
    private var isMovingRight: Bool? // 현재 움직임 방향
    private let request: VNDetectHumanHandPoseRequest = .init()
    private var lastThumbTipPoint: CGPoint = .zero

    // 이전 방향 기록 배열(노이즈 제거용)
    private var directionHistory: [Bool] = []
    private let historyLength = 5 // 방향 몇 개 기록할지

    /// '움직임'으로 인식하기 위한' 최소 거리
    private let minimumDistance: CGFloat = 0.03

    /// 최근 방향 전환 시간
    private var lastDirectionChangeTime: Date?

    /// 방향 전환 간 미니멈 시간
    private let minTimeBetweenDirectionChanges: TimeInterval = 0.2

    // MARK: - Lifecycle

    init() {
        request.maximumHandCount = 1
    }

    // MARK: - Functions

    func analyze(sampleBuffer: CMSampleBuffer,
                 completion: @escaping (_ thumbTip: CGPoint?) -> Void) {
        let handler: VNImageRequestHandler = .init(cmSampleBuffer: sampleBuffer, orientation: .up)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([self.request])
                guard let observation = self.request.results?.first else {
                    completion(nil)
                    return
                }

                let thumbPoints = try observation.recognizedPoints(.thumb)
                guard let thumbTip = thumbPoints[.thumbTip],
                      thumbTip.confidence > 0.3 else {
                    completion(nil)
                    return
                }

                let thumb: CGPoint = .init(x: thumbTip.location.x, y: 1 - thumbTip.location.y)
                completion(thumb)
            } catch {
                print("Vision error: \(error)")
                completion(nil)
            }
        }
    }

    func processThumbTip(thumbTip: CGPoint?) -> Int {
        guard let thumbPoint = thumbTip else {
            return handShakeCount
        }

        // 첫번째 감지인 경우
        if lastThumbTipPoint == .zero {
            lastThumbTipPoint = thumbPoint
            return handShakeCount
        }

        let distance = thumbPoint.x - lastThumbTipPoint.x

        // 움직임으로 인식 가능한 거리인 경우
        if abs(distance) > minimumDistance {
            // distance > 0 -> 오른쪽 방향
            // distance < 0 -> 왼쪽 방향
            let currentlyMovingRight = distance > 0

            // 배열에 현재 방향 추가
            updateDirectionHistory(currentlyMovingRight)

            // 첫번째 감지 or 방향이 초기화된 경우
            if isMovingRight == nil {
                isMovingRight = currentlyMovingRight
            }

            // 방향이 바뀐 경우
            else if isMovingRight != currentlyMovingRight && isConsistentDirectionChange() {
                // 시간 차이 확인
                let now: Date = .init()
                if lastDirectionChangeTime == nil ||
                    now
                    .timeIntervalSince(lastDirectionChangeTime!) >= minTimeBetweenDirectionChanges {
                    handShakeCount += 1
                    isMovingRight = currentlyMovingRight
                    lastDirectionChangeTime = now
                    print("💥 방향 전환! Hand Shake Count = \(handShakeCount)")
                }
            }
        }

        // 현재 엄지 위치로 업데이트
        lastThumbTipPoint = thumbPoint
        return handShakeCount
    }

    func resetHandShakeCount() {
        handShakeCount = 0
        isMovingRight = nil
        lastThumbTipPoint = .zero
        directionHistory.removeAll()
        lastDirectionChangeTime = nil
    }

    /// 이전 방향 배열 업데이트
    private func updateDirectionHistory(_ direction: Bool) {
        if directionHistory.count >= historyLength {
            directionHistory.removeFirst()
        }
        directionHistory.append(direction)
    }

    /// 방향 일관성 판단(노이즈 필터링)
    private func isConsistentDirectionChange() -> Bool {
        // 방향 배열이 짧으면 false
        if directionHistory.count < historyLength {
            return false
        }

        // 대부분의 기록이 같은 방향이면 true
        let majority = directionHistory.filter { $0 == directionHistory.last }.count
        return Double(majority) / Double(directionHistory.count) >= 0.6 // 60% 이상이 같은 방향
    }
}

// MARK: - CGPoint helpers

extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat {
        hypot(point.x - x, point.y - y)
    }

    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}
