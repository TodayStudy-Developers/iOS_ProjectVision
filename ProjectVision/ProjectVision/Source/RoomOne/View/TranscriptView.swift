//
//  TranscriptView.swift
//  ProjectVision
//
//  Created by Daehoon Lee on 3/25/25.
//

import SwiftUI
import Vision

struct TranscriptView: View {
    // MARK: - SwiftUI Properties

    @Binding var imageOCR: OCR

    // MARK: - Content Properties

    var body: some View {
        VStack {
            NavigationStack {
                if imageOCR.observations.isEmpty {
                    Text("No text found")
                        .foregroundStyle(.gray)
                } else {
                    Text("Text extracted from the image:")
                        .font(.title2)

                    ScrollView {
                        ForEach(imageOCR.observations, id: \.self) { observation in
                            Text(observation.topCandidates(1).first?.string ?? "No text recognized")
                                .textSelection(.enabled)
                        }
                        .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}
