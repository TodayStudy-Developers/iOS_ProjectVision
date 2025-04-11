//
//  CameraView.swift
//  ProjectVision
//
//  Created by minsong kim on 3/28/25.
//

import AVFoundation
import SwiftUI

struct CameraView: UIViewRepresentable {
    // MARK: - SwiftUI Properties

    @ObservedObject var controller: CameraController

    // MARK: - Functions

    func makeUIView(context _: Context) -> UIView {
        let view: UIView = .init()
        let previewLayer = controller.getPreviewLayer()
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        controller.start()
        return view
    }

    func updateUIView(_: UIView, context _: Context) { }
}
