//
//  NodeView.swift
//  Pi Cluster
//
//  Created by Bogdan Farca on 12.10.2022.
//

import SwiftUI

struct NodeView: View {
    let node: Node
    
    var body: some View {
        NavigationView {
            List {
                Section("Networking") {
                    HStack {
                        Text("IP")
                        Spacer()
                        Text(node.ip)
                    }
                    HStack {
                        Text("Port")
                        Spacer()
                        Text("\(node.port.value)")
                    }
                    HStack {
                        Text("MAC")
                        Spacer()
                        Text(node.mac)
                    }
                }
                Section {
                    HStack {
                        Text("Switch")
                        Spacer()
                        Text(node.switchIP.value)
                    }
                }
                
                Section("CPU") {
                    HStack {
                        Text("CPU load")
                        Spacer()
                        Text("\(node.cpu.value, specifier: "%.1f")%")
                    }
                    HStack {
                        Text("CPU temperature")
                        Spacer()
                        Text("\(node.cpuTemperature.value, specifier: "%.1f") ℃")
                    }
                }
                
                Section("RAM") {
                    HStack {
                        Text("Memory free")
                        Spacer()
                        Text("\(node.memoryFree, specifier: "%.1f") MB")
                    }
                    HStack {
                        Text("Memory total")
                        Spacer()
                        Text("\(node.memoryTotal, specifier: "%.1f") MB")
                    }
                    HStack {
                        Text("Memory free percentage")
                        Spacer()
                        Text("\(node.memoryPercentage.value, specifier: "%.1f")%")
                    }
                }
                
                Section("Storage") {
                    HStack {
                        Text("Storage free")
                        Spacer()
                        Text("\(node.diskFree, specifier: "%.1f") GB")
                    }
                    HStack {
                        Text("Storage total")
                        Spacer()
                        Text("\(node.diskTotal) GB")
                    }
                    HStack {
                        Text("Storage free percentage")
                        Spacer()
                        Text("\(node.diskPercentage.value, specifier: "%.1f")%")
                    }
                }
            }
            .navigationTitle("Node details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
