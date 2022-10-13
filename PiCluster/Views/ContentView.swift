//
//  ContentView.swift
//  PiCluster
//
//  Created by Bogdan Farca on 29.08.2022.
//

import SwiftUI
import ARKit

struct ContentView: View {
    @StateObject var dataModel = ClusterDataModel.shared
    @State var clickedNode: Node? = nil
    
    var body: some View {
        if dataModel.nodes.count == 0 {
            HStack(spacing: 10) {
                Text("Loading data from cloud")
                ProgressView()
            }
        } else {
            ARViewContainer(clickedPI: $clickedNode)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if !ARWorldTrackingConfiguration.supportsAppClipCodeTracking {
                        print("AppClips not supported on this device")
                    }
                }
                .sheet(item: $clickedNode) { node in
                    NodeView(node: node)
                }
        }
    }
}

extension Node: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return mac.hash
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
