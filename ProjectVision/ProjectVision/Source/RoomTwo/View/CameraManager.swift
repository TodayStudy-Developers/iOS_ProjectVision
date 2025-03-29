//
//  CameraManager.swift
//  ProjectVision
//
//  Created by minsong kim on 3/28/25.
//

import AVFoundation

class CameraManager: NSObject {
    // MARK: - Properties

    weak var delegate: CameraFrameDelegate?

    // 미디어 캡쳐를 위한 객체
    private let session: AVCaptureSession = .init()
    private let videoOutput: AVCaptureVideoDataOutput = .init()

    // MARK: - Functions

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupSession()
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let layer: AVCaptureVideoPreviewLayer = .init(session: session)
        layer.videoGravity = .resizeAspectFill
        return layer
    }

    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            return
        }

        session.addInput(input)

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
            videoOutput.alwaysDiscardsLateVideoFrames = true
        }

        session.commitConfiguration()
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from _: AVCaptureConnection) {
        delegate?.sendFrameOutput(from: self, didOutput: sampleBuffer)
    }
}
