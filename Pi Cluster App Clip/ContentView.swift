//
//  ContentView.swift
//  Pi Cluster App Clip
//
//  Created by Bogdan Farca on 31.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var clipMsg = "Nope"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world Clip! \(clipMsg)")
        }
        .padding()
        .onAppear {
            print("On !")
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
            guard let incomingURL = activity.webpageURL
                  // let components = NSURLComponents (url: incomingURL, resolvingAgainstBaseURL: true)
            else {
                return
            }

            clipMsg = "\(incomingURL)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
