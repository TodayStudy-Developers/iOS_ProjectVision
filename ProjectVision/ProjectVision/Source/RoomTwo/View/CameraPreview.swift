//
//  CameraPreview.swift
//  ProjectVision
//
//  Created by 이명지 on 3/26/25.
//

import AVFoundation
import Foundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    // MARK: - Properties

    private let cameraQueue: DispatchQueue = .init(label: "CameraQueue")
    private var captureSession: AVCaptureSession = .init()
    private var currentInput: AVCaptureDeviceInput?

    // MARK: - Lifecycle

    init(cameraPosition: AVCaptureDevice.Position) {
        configureCaptureSession(cameraPosition: cameraPosition)
    }

    // MARK: - Functions

    func makeUIView(context _: Context) -> UIView {
        let view: PreviewView = .init()
        view.backgroundColor = .black
        if let previewLayer = view.previewLayer {
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoRotationAngle = 90.0
        }
        return view
    }

    func updateUIView(_: UIView, context _: Context) { }

    func requestCamearaPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authStatus in
                if authStatus {
                    cameraQueue.async {
                        captureSession.startRunning()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            cameraQueue.async {
                captureSession.startRunning()
            }
        default:
            print("Permission not granted")
        }
    }

    mutating func configureCamera(cameraPosition: AVCaptureDevice.Position) {
        let discoverySession = AVCaptureDevice
            .DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera],
                              mediaType: .video,
                              position: cameraPosition)

        guard let cameraDevice = discoverySession.devices.first else {
            fatalError("no camera device is available")
        }

        do {
            if let currentInput {
                captureSession.removeInput(currentInput)
            }
            let deviceInput = try AVCaptureDeviceInput(device: cameraDevice)
            captureSession.addInput(deviceInput)
            currentInput = deviceInput
        } catch {
            print("error = \(error.localizedDescription)")
        }
    }

    private mutating func configureCaptureSession(cameraPosition: AVCaptureDevice.Position) {
        let videoOutput: AVCaptureVideoDataOutput = .init()
        captureSession.addOutput(videoOutput)

        configureCamera(cameraPosition: cameraPosition)
    }
}

private class PreviewView: UIView {
    // MARK: - Overridden Properties

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    // MARK: - Computed Properties

    var previewLayer: AVCaptureVideoPreviewLayer? {
        layer as? AVCaptureVideoPreviewLayer
    }
}
