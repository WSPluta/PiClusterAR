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
    @State var clickedPI: String? = nil
    
    var body: some View {
        if dataModel.nodes.count == 0 {
            HStack(spacing: 10) {
                Text("Loading data from cloud")
                ProgressView()
            }
        } else {
            ARViewContainer(clickedPI: $clickedPI)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if !ARWorldTrackingConfiguration.supportsAppClipCodeTracking {
                        print("AppClips not supported on this device")
                    }
                }
                .sheet(item: $clickedPI, content: { value in
                    Text(value)
                })
        }
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
