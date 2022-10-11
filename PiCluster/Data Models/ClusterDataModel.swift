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
    
    func loadCluster() {
        self.nodes = []
        
        self.cancellable = fetchNodesData()
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
                    print("*")
                }
            }
    }
    
    private func fetchNodesData() -> AnyPublisher<[Node], Error>{
//        let url = URL(string: "https://g2f4dc3e5463897-ardata.adb.uk-london-1.oraclecloudapps.com/ords/picluster/AR/DigitalTwin")!
//
//        return URLSession.shared
//            .dataTaskPublisher(for: url)
//            .map (\.data)

        return CurrentValueSubject<Data, Error>(testJSON.data(using: .utf8)!)
            .decode(type: Cluster.self, decoder: JSONDecoder())
            .map(\.items)
            .eraseToAnyPublisher()
    }
    
    
    private var testJSON: String =
    """
    {
    "items": [
        {
            "CPU": "27.0%",
            "MemoryFree": 7478.9,
            "MemoryTotal": 7847.7,
            "MemoryPercentage": "4.7%",
            "DiskFree": 22.1,
            "DiskTotal": 29.0,
            "DiskPercentage": "20.4%",
            "CPUTemperature": "65.7'C",
            "ip": "192.168.1.221",
            "mac": "dc:a6:32:e9:31:ba",
            "port": "1",
            "switch_ip": "1.2.3.4",
            "processes": [
                [
                    {
                        "pid": 1,
                        "name": "systemd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 2,
                        "name": "kthreadd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 29087,
                        "name": "kworker/2:2H",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 29111,
                        "name": "kworker/0:2-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31586,
                        "name": "kworker/0:1H",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31727,
                        "name": "kworker/1:2-mm_percpu_wq",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31742,
                        "name": "kworker/2:0-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 32353,
                        "name": "kworker/3:0-mm_percpu_wq",
                        "cpu_percent": 0.0
                    }
                ]
            ],
            "data": {},
            "status": "true"
        },
        {
            "CPU": "92.3%",
            "MemoryFree": 7478.9,
            "MemoryTotal": 7847.7,
            "MemoryPercentage": "4.7%",
            "DiskFree": 22.1,
            "DiskTotal": 29.0,
            "DiskPercentage": "20.4%",
            "CPUTemperature": "65.7'C",
            "ip": "192.168.1.222",
            "mac": "dc:a6:32:e9:31:bb",
            "port": "2",
            "switch_ip": "1.2.3.4",
            "processes": [
                [
                    {
                        "pid": 1,
                        "name": "systemd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 3341,
                        "name": "sshd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 3358,
                        "name": "sshd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 3359,
                        "name": "bash",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 3789,
                        "name": "kworker/3:2-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 32353,
                        "name": "kworker/3:0-mm_percpu_wq",
                        "cpu_percent": 0.0
                    }
                ]
            ],
            "data": {},
            "status": "true"
        },
        {
            "CPU": "27.0%",
            "MemoryFree": 7478.9,
            "MemoryTotal": 7847.7,
            "MemoryPercentage": "4.7%",
            "DiskFree": 22.1,
            "DiskTotal": 29.0,
            "DiskPercentage": "20.4%",
            "CPUTemperature": "65.7'C",
            "ip": "192.168.1.223",
            "mac": "dc:a6:32:e9:31:bc",
            "port": "3",
            "switch_ip": "1.2.3.4",
            "processes": [
                [
                    {
                        "pid": 1,
                        "name": "systemd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 29111,
                        "name": "kworker/0:2-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31586,
                        "name": "kworker/0:1H",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31727,
                        "name": "kworker/1:2-mm_percpu_wq",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31742,
                        "name": "kworker/2:0-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 32353,
                        "name": "kworker/3:0-mm_percpu_wq",
                        "cpu_percent": 0.0
                    }
                ]
            ],
            "data": {},
            "status": "true"
        },
            {
            "CPU": "12.0%",
            "MemoryFree": 7478.9,
            "MemoryTotal": 7847.7,
            "MemoryPercentage": "4.7%",
            "DiskFree": 22.1,
            "DiskTotal": 29.0,
            "DiskPercentage": "20.4%",
            "CPUTemperature": "65.7'C",
            "ip": "192.168.1.224",
            "mac": "dc:a6:32:e9:31:bd",
            "port": "4",
            "switch_ip": "1.2.3.4",
            "processes": [
                [
                    {
                        "pid": 1,
                        "name": "systemd",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 29111,
                        "name": "kworker/0:2-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31586,
                        "name": "kworker/0:1H",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31727,
                        "name": "kworker/1:2-mm_percpu_wq",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 31742,
                        "name": "kworker/2:0-events",
                        "cpu_percent": 0.0
                    },
                    {
                        "pid": 32353,
                        "name": "kworker/3:0-mm_percpu_wq",
                        "cpu_percent": 0.0
                    }
                ]
            ],
            "data": {},
            "status": "true"
        }
    ],
    "hasMore": false,
    "limit": 0,
    "offset": 0,
    "count": 328,
    "links": [
        {
            "rel": "self",
            "href": "https://g2f4dc3e5463897-ardata.adb.uk-london-1.oraclecloudapps.com/ords/picluster/AR/v2/"
        },
        {
            "rel": "edit",
            "href": "https://g2f4dc3e5463897-ardata.adb.uk-london-1.oraclecloudapps.com/ords/picluster/AR/v2/"
        },
        {
            "rel": "describedby",
            "href": "https://g2f4dc3e5463897-ardata.adb.uk-london-1.oraclecloudapps.com/ords/picluster/metadata-catalog/AR/v2/"
        }
    ]
    }
    """
    
}
