//
//  ARViewContainer.swift
//  AR test
//
//  Created by Bogdan Farca on 31.08.2022.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .zero)

    func makeUIView(context: Context) -> ARView {
        #if DEBUG
        //arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        #endif
                
        // Handle ARSession events via delegate
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator
        
        let newConfiguration = ARWorldTrackingConfiguration()
        newConfiguration.automaticImageScaleEstimationEnabled = true
        newConfiguration.appClipCodeTrackingEnabled = true
        arView.session.run(newConfiguration)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func runARSession(withAdditionalReferenceImages additionalReferenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()) {
        if let currentConfiguration = (arView.session.configuration as? ARWorldTrackingConfiguration) {
            // Add the additional reference images to the current AR session.
            currentConfiguration.detectionImages = currentConfiguration.detectionImages.union(additionalReferenceImages)
            currentConfiguration.maximumNumberOfTrackedImages = currentConfiguration.detectionImages.count
            arView.session.run(currentConfiguration)
        } else {
            // Initialize a new AR session with App Clip Code tracking and image tracking.
            arView.automaticallyConfigureSession = false
            let newConfiguration = ARWorldTrackingConfiguration()
            newConfiguration.detectionImages = additionalReferenceImages
            newConfiguration.maximumNumberOfTrackedImages = newConfiguration.detectionImages.count
            newConfiguration.automaticImageScaleEstimationEnabled = true
            newConfiguration.appClipCodeTrackingEnabled = true
            arView.session.run(newConfiguration)
        }
    }

    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            //guard let view = self.view else { return }
            //debugPrint("Anchors added to the scene: ", anchors)
            
            for anchor in anchors {
                if anchor is ARAppClipCodeAnchor {
                    print("AppClip found !!")
                }
            }
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let appClipCodeAnchor = anchor as? ARAppClipCodeAnchor, appClipCodeAnchor.urlDecodingState != .decoding {
                    let decodedURL: URL
                    switch appClipCodeAnchor.urlDecodingState {
                        case .decoded:
                            decodedURL = appClipCodeAnchor.url!
                            print("Successfully decoded ARAppClipCodeAnchor url: " + decodedURL.absoluteString)
                        case .failed:
                            print("Decoding failure. Trying scanning a code again.")
                        case .decoding:
                            continue
                        default:
                            continue
                    }
                }
            }
        }
    }
}
