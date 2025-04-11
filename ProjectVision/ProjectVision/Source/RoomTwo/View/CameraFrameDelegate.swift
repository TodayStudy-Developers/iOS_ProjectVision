//
//  CameraFrameDelegate.swift
//  ProjectVision
//
//  Created by minsong kim on 3/28/25.
//

import CoreMedia

protocol CameraFrameDelegate: AnyObject {
    func sendFrameOutput(from manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer)
}
