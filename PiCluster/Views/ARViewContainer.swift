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
    @ObservedObject private var dataModel = ClusterDataModel.shared
    
    @Binding  var clickedPI: String?
    
    func makeUIView(context: Context) -> ARView {
        #if DEBUG
        //arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        #endif
        print("Created !!!")
        
        // Handle ARSession events via delegate
        dataModel.arView.session.delegate = context.coordinator
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        runARSession(withAdditionalReferenceImages: referenceImages)
                
        return dataModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        print("Updated !!!")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) //(clickedPI: $clickedPI)
    }
    
    func runARSession(withAdditionalReferenceImages additionalReferenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()) {
        if let currentConfiguration = (dataModel.arView.session.configuration as? ARWorldTrackingConfiguration) {
            // Add the additional reference images to the current AR session.
            currentConfiguration.detectionImages = currentConfiguration.detectionImages.union(additionalReferenceImages)
            currentConfiguration.maximumNumberOfTrackedImages = currentConfiguration.detectionImages.count
            dataModel.arView.session.run(currentConfiguration)
        } else {
            // Initialize a new AR session with App Clip Code tracking and image tracking.
            dataModel.arView.automaticallyConfigureSession = false
            let newConfiguration = ARWorldTrackingConfiguration()
            newConfiguration.detectionImages = additionalReferenceImages
            newConfiguration.maximumNumberOfTrackedImages = newConfiguration.detectionImages.count
            newConfiguration.automaticImageScaleEstimationEnabled = true
            newConfiguration.appClipCodeTrackingEnabled = true
            dataModel.arView.session.run(newConfiguration)
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            //debugPrint("Anchors added to the scene: ", anchors)
            
            for anchor in anchors {
                if anchor is ARAppClipCodeAnchor {
                    print("AppClip found !!")
                }
                
                if let imageAnchor = anchor as? ARImageAnchor,
                   let productKey = imageAnchor.referenceImage.name
                {
                    generatePIClusterAvatars(switchIP: productKey, imageAnchor: imageAnchor)
                }
            }
        }

        private func generatePIClusterAvatars(switchIP: String, imageAnchor: ARImageAnchor) {
            //guard let arView else { return }
            
            print("** \(switchIP)")
            parent.dataModel.arView.scene.anchors.removeAll()
            
            // This is the reference anchor of the recognized barcode//image
            let barcodeAnchor = AnchorEntity(anchor: imageAnchor)
            parent.dataModel.arView.scene.addAnchor(barcodeAnchor)
            
            // Now the indicators for each Pi in the row
            let piScene = try! Experience.loadPi()
            let bulbEntity = piScene.bulb!.children[0] as! ModelEntity
            
            // The scale
            bulbEntity.scale = SIMD3<Float>.one * 0.7
            
            // We need a lot of them
            let nodes = parent.dataModel.nodes.filter { $0.switchIP == switchIP }
            
            for (i, node) in nodes.enumerated() {
                let newEntity = bulbEntity.clone(recursive: true)
                newEntity.position.x = Float(i) * 0.01 // 1cm
                
                // Changing the color
                let myColor = node.cpu.value > 80.0 ? UIColor.red : .blue
                let material = SimpleMaterial(color: myColor, isMetallic: false)
                // (newEntity.children[0] as! ModelEntity).model!.materials = [material]
                newEntity.model!.materials = [material]
                
                // Register taps
                newEntity.name = node.ip
                newEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: newEntity.model!.mesh)])
                parent.dataModel.arView.installGestures(.all, for: newEntity)
                
                // Showtime
                barcodeAnchor.addChild(newEntity)
            }
            // print(arView.scene.anchors)
            
            // Taps
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(onTap))
            parent.dataModel.arView.addGestureRecognizer(tapGesture)
        }
        
        @IBAction func onTap(_ sender: UITapGestureRecognizer) {
            let tapLocation = sender.location(in: parent.dataModel.arView)
            
            // Get the entity at the location we've tapped, if one exists
            if let tapped = parent.dataModel.arView.entity(at: tapLocation) {
                print("Tapped \(tapped.name)")
                parent.clickedPI = tapped.name
            }
        }
        
        
        func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor,
                   let productKey = imageAnchor.referenceImage.name
                {
                    print("** removed \(productKey)")
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

extension Entity {
    func present(on parent: Entity) {
        /* The sunflower model's hardcoded scale.
         An app may wish to assign a unique scale value per App Clip Code model. */
        let finalScale = SIMD3<Float>.one //* 5
        
        parent.addChild(self)
        // To display the model, initialize it at a small scale, then animate by transitioning to the original scale.
        self.move(
            to: Transform(
                scale: SIMD3<Float>.one * (1.0 / 1000),
                rotation: simd_quatf.init(angle: Float.pi, axis: SIMD3<Float>(x: 0, y: 1, z: 0))
            ),
            relativeTo: self
        )
        self.move(
            to: Transform(
                scale: finalScale,
                rotation: simd_quatf.init(angle: Float.pi, axis: SIMD3<Float>(x: 0, y: 1, z: 0))
            ),
            relativeTo: self,
            duration: 3
        )
    }
}
