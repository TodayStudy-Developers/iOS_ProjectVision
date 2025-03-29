//
//  VideoOutputDelegate.swift
//  ProjectVision
//
//  Created by 이명지 on 3/27/25.
//

import AVFoundation
import Vision

protocol VideoOuputDelegate

final class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Properties

    private let handPoseRequest: VNDetectHumanHandPoseRequest
    private var lastWristPoint: CGPoint?
    private var handshakeDirectionToRight = false
    private var handshakeCount = 0
    private var lastHandShkeTime: Date?
    private let handshakeTimeLimit: TimeInterval = 3.0
    private let handshakeDistanceLimit: CGFloat = 0.05
    
    weak var delegate: VideoOutputDelegateDelegate?

    // MARK: - Lifecycle

    init(handPoseRequest: VNDetectHumanHandPoseRequest) {
        self.handPoseRequest = handPoseRequest
    }

    // MARK: - Functions

    func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
                       from _: AVCaptureConnection) {
        let handler: VNImageRequestHandler = .init(cmSampleBuffer: sampleBuffer, orientation: .up,
                                                   options: [:])

        do {
            try handler.perform([handPoseRequest])

            guard let observation = handPoseRequest.results?
                .first as? VNRecognizedPointsObservation else {
                return
            }

            guard let allPoints = try? observation.recognizedPoints(forGroupKey: .all),
                  let wristPoints =
                  allPoints[VNHumanHandPoseObservation.JointName.wrist.rawValue],
                  wristPoints.confidence > 0.5
            else {
                return
            }

            print(wristPoints)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
