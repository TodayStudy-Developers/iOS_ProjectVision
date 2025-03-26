//
//  RoomOneOCRView.swift
//  ProjectVision
//
//  Created by Daehoon Lee on 3/25/25.
//

import SwiftUI
import Vision

struct RoomOneOCRView: View {
    // MARK: - SwiftUI Properties

    @Binding var showCamera: Bool
    @Binding var imageData: Data?

    @State private var imageOCR: OCR = .init()
    @State private var languageCorrection = false
    @State private var selectedLanguage = Locale.Language(identifier: "ko-KR")

    // MARK: - Computed Properties

    /// Watch for changes to the request settings.
    var settingChanges: [String] { [languageCorrection.description,
                                    imageData?.description,
                                    selectedLanguage.maximalIdentifier].compactMap { $0 } }

    // MARK: - Content Properties

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: TranscriptView(imageOCR: $imageOCR)) {
                    Text("View Text")
                        .padding()
                        .font(.headline)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }

                // Convert the image data to a `UIImage`, and display it in an `Image` view.
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            ForEach(imageOCR.observations, id: \.uuid) { observation in
                                Box(observation: observation)
                                    .stroke(.red, lineWidth: 1)
                            }
                        }
                        .padding()
                }
            }
            // Initially perform the request, and then perform the request when changes occur to the
            // request settings.
            .onChange(of: settingChanges, initial: true) {
                updateRequestSettings()
                Task {
                    guard let imageData else {
                        return
                    }
                    try await imageOCR.performOCR(imageData: imageData)
                }
            }
        }
    }

    // MARK: - Functions

    /// Update the request settings based on the selected options on the `ImageView`.
    func updateRequestSettings() {
        // A Boolean value that indicates whether the system applies the language-correction model.
        imageOCR.request.usesLanguageCorrection = languageCorrection

        imageOCR.request.recognitionLanguages = [selectedLanguage]

        //        switch selectedRecognitionLevel {
        //        case "Fast":
        //            imageOCR.request.recognitionLevel = .fast
        //        default:
        //            imageOCR.request.recognitionLevel = .accurate
        //        }
    }
}

@Observable
class OCR {
    // MARK: - Properties

    /// The array of `RecognizedTextObservation` objects to hold the request's results.
    var observations: [RecognizedTextObservation] = .init()

    /// The Vision request.
    var request: RecognizeTextRequest = .init()

    // MARK: - Functions

    func performOCR(imageData: Data) async throws {
        // Clear the `observations` array for photo recapture.
        observations.removeAll()

        // Perform the request on the image data and return the results.
        let results = try await request.perform(on: imageData)

        // Add each observation to the `observations` array.
        for observation in results {
            observations.append(observation)
        }
    }
}

/// Create and dynamically size a bounding box.
struct Box: Shape {
    // MARK: - Properties

    private let normalizedRect: NormalizedRect

    // MARK: - Lifecycle

    init(observation: any BoundingBoxProviding) {
        normalizedRect = observation.boundingBox
    }

    // MARK: - Functions

    func path(in rect: CGRect) -> Path {
        let rect = normalizedRect.toImageCoordinates(rect.size, origin: .upperLeft)
        return Path(rect)
    }
}
