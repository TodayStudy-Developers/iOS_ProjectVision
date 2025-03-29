//
//  CameraController.swift
//  ProjectVision
//
//  Created by minsong kim on 3/28/25.
//

import AVFoundation

class CameraController: NSObject, ObservableObject {
    // MARK: - Properties

    @Published var thumbTip: CGPoint?
    @Published var handShakeCount: Int?

    private let cameraManager: CameraManager = .init()
    private let analyzer: HandPoseAnalyzer = .init()

    // MARK: - Lifecycle

    override init() {
        super.init()
        cameraManager.delegate = self
    }

    // MARK: - Functions

    func start() {
        cameraManager.startSession()
    }

    func stop() {
        cameraManager.stopSession()
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        cameraManager.getPreviewLayer()
    }
}

extension CameraController: CameraFrameDelegate {
    func sendFrameOutput(from: CameraManager, didOutput sampleBuffer: CMSampleBuffer) {
        analyzer.analyze(sampleBuffer: sampleBuffer) { [weak self] thumb in
            Task { @MainActor in
                print("Analyzing hand pose...")
//                self?.handShakeCount = self?.analyzer.processPoints(thumbTip: thumb)
//                print("\(self?.handShakeCount)")
            }
        }
    }
}
