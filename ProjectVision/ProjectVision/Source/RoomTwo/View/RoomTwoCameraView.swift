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

    @State var cameraPosition: AVCaptureDevice.Position = .back
    @State var cameraPreview: CameraPreview = .init(cameraPosition: .back)

    // MARK: - Content Properties

    var body: some View {
        ZStack {
            cameraPreview
                .ignoresSafeArea()
                .onAppear {
                    cameraPreview.requestCamearaPermission()
                }
            VStack {
                Text("손을 3번 이상 흔들어주세요.")
                    .bold()
                    .font(.title)
                Spacer()
            }
        }
    }
}
