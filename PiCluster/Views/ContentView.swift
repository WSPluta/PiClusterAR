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
    @State var showPopover = false
    
    var body: some View {
        ARViewContainer(clickedPI: $clickedPI)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                if !ARWorldTrackingConfiguration.supportsAppClipCodeTracking {
                    print("AppClips not supported on this device")
                }
            }
            .onChange(of: clickedPI) { newValue in
                showPopover = true
            }
            .sheet(isPresented: $showPopover) {
                Text(clickedPI ?? "none")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
