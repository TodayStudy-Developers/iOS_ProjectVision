//
//  CameraUI.swift
//  ProjectVision
//
//  Created by Daehoon Lee on 3/25/25.
//

import SwiftUI

struct CameraUI: View {
    // MARK: - SwiftUI Properties

    @State var camera: Camera = .init()
    @State var didSetup: Bool = .init()

    @Binding var showCamera: Bool
    @Binding var hasPhoto: Bool
    @Binding var imageData: Data?

    // MARK: - Content Properties

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreview(camera: $camera)
                .task {
                    if await camera.checkCameraAuthorization() {
                        didSetup = camera.setup()
                    } else {
                        showCamera = false
                    }

                    if !didSetup {
                        print("Camera setup failed.")
                        showCamera = false
                    }
                }
                .ignoresSafeArea()

            cameraControls
        }
    }

    @ViewBuilder var cameraControls: some View {
        if !camera.hasPhoto {
            Button {
                camera.capturePhoto()
            } label: {
                ZStack {
                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .frame(width: 70)

                    Circle()
                        .fill(.white)
                        .frame(width: 60)
                }
            }
            .buttonStyle(CaptureButtonStyle())
        } else {
            Button("Done") {
                imageData = camera.photoData
                showCamera = false
                hasPhoto = true
            }
            .buttonStyle(DoneButtonStyle())
        }
    }
}

struct DoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color.white)
            .foregroundStyle(.black)
            .font(.title2)
            .clipShape(Capsule())
    }
}

struct CaptureButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
