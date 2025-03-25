//
//  CameraPreview.swift
//  ProjectVision
//
//  Created by Daehoon Lee on 3/25/25.
//

import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    // MARK: - SwiftUI Properties

    @Binding var camera: Camera

    // MARK: - Functions

    func makeUIView(context _: Context) -> some UIView {
        let view: PreviewView = .init()

        view.videoPreviewLayer.session = camera.session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        return view
    }

    /// No implementation needed.
    func updateUIView(_: UIViewType, context _: Context) { }
}

class PreviewView: UIView {
    // MARK: - Overridden Properties

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    // MARK: - Computed Properties

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        layer as? AVCaptureVideoPreviewLayer ?? AVCaptureVideoPreviewLayer()
    }
}
