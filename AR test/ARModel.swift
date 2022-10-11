//
//  ARModel.swift
//  PiCluster
//
//  Created by Bogdan Farca on 31.08.2022.
//

import Foundation
import RealityKit
import ARKit

final class ARModel: ObservableObject {
    static var shared = ARModel()
    
    @Published var arView: ARView
    
    init () {        
        // Create the 3D view
        arView = ARView(frame: .zero)
        
        //arView.session.delegate = self
        //runARSession()
                
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
    }
}
