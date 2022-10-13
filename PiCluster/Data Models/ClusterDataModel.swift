// *********************************************************************************************
// Copyright © 2021. Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at
// http://oss.oracle.com/licenses/upl
// *********************************************************************************************

//  Filename: SessionsDataModel.swift


import Foundation
import Combine
import RealityKit

final class ClusterDataModel: ObservableObject {
    static var shared = ClusterDataModel()
    
    @Published var nodes: [Node] = []
    @Published var arView: ARView
    
    private var cancellable: AnyCancellable?
    
    init() {
        // Create the 3D view
        arView = ARView(frame: .zero)
        
        // Load the sessions data from ATP
        loadCluster()
    }
    
    private func loadCluster() {
        self.nodes = []
        
        self.cancellable = Timer
            .publish(every: 60, on: .main, in: .default)
            .autoconnect()
            .merge(with: Just(Date())) // <- fires the first time immediately
            .flatMap { [self] _ in fetchNodesData() }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done loading API data")
                    case let .failure(error) :
                        print("Error loading API data: \(error)")
                }
                
            } receiveValue: { items in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.nodes = items
//                    for index in 0..<self.nodes.count {
//                        self.nodes[index].cpu.value = Float(Int.random(in: 1..<20))
//                    }
                    print("Nodes parsed")
                }
            }
    }
    
    private func fetchNodesData() -> AnyPublisher<[Node], Error> {
        let url = URL(string: "https://g2f4dc3e5463897-ardata.adb.uk-london-1.oraclecloudapps.com/ords/picluster/AR/v2/10000")!
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map (\.data)
            .decode(type: Cluster.self, decoder: JSONDecoder())
            .map(\.nodes)
            .map { $0.map(\.node) }
            .eraseToAnyPublisher()
    }
}
