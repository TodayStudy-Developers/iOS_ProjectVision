//
//  RoomTwoCameraView.swift
//  ProjectVision
//
//  Created by 이명지 on 3/26/25.
//

import AVFoundation
import SwiftUI

struct RoomTwoCameraView: View {
    // MARK: - SwiftUI Properties

    @StateObject private var cameraController: CameraController = .init()

    // MARK: - Computed Properties

    var isSuccess: Bool {
        (cameraController.handShakeCount ?? 0) >= 3
    }

    // MARK: - Content Properties

    var body: some View {
        ZStack {
            CameraPreview(controller: cameraController)
                .ignoresSafeArea()

            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .frame(height: 60)

                    HStack {
                        if isSuccess {
                            Text("성공")
                                .bold()
                                .font(.title2)
                                .foregroundColor(.green)
                        } else {
                            Text("손을 좌우로 흔들어주세요")
                                .bold()
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()

                // 손 흔든 횟수 표시
                if let count = cameraController.handShakeCount, count > 0 {
                    Text("(\(count)/3)")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
