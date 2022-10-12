// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Cluster: Decodable {
    let nodes: [ClusterNode]
    
    enum CodingKeys: String, CodingKey {
        case nodes = "CLUSTER"
    }
}

struct ClusterNode: Decodable {
    let node: Node
    
    enum CodingKeys: String, CodingKey {
        case node = "DATA"
    }
}

struct Node: Decodable {
    let cpu: Percent
    let memoryFree, memoryTotal: Double
    let memoryPercentage: Percent
    let diskFree: Double
    let diskTotal: Int
    let diskPercentage: Percent
    let cpuTemperature: Temperature
    let ip, mac: String
    let port: PortType
    let switchIP: IPType
    // let processes: [[Process]]
    
    enum CodingKeys: String, CodingKey {
        case cpu = "CPU"
        case memoryFree = "MemoryFree"
        case memoryTotal = "MemoryTotal"
        case memoryPercentage = "MemoryPercentage"
        case diskFree = "DiskFree"
        case diskTotal = "DiskTotal"
        case diskPercentage = "DiskPercentage"
        case cpuTemperature = "CPUTemperature"
        case ip, mac, port
        case switchIP = "switch_ip"
        // case processes
    }
}

struct Process: Codable {
    let pid: Int
    let name: String
    let cpuPercent: Int
    
    enum CodingKeys: String, CodingKey {
        case pid, name
        case cpuPercent = "cpu_percent"
    }
}

// -------------------------------

struct Percent: Decodable {
    let value: Float
    
    init(from decoder: Decoder) throws {
        let floatString = try decoder.singleValueContainer().decode(String.self)
        if let myFloat = Float(floatString.replacingOccurrences(of: "%", with: "", options: .literal, range: nil)) {
            self.value = myFloat
        } else {
            throw DecodingError.typeMismatch(Percent.self, .init(codingPath: decoder.codingPath, debugDescription: "\(floatString) is not in the expected format"))
        }
    }
}

struct Temperature: Decodable {
    let value: Float
    
    init(from decoder: Decoder) throws {
        let floatString = try decoder.singleValueContainer().decode(String.self)
        if let myFloat = Float(floatString.replacingOccurrences(of: "'C", with: "", options: .literal, range: nil)) {
            self.value = myFloat
        } else {
            throw DecodingError.typeMismatch(Percent.self, .init(codingPath: decoder.codingPath, debugDescription: "\(floatString) is not in the expected format"))
        }
    }
}

struct PortType: Decodable {
    let value: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            value = try container.decode(Int.self)
        } catch DecodingError.typeMismatch {
            if let myValue = Int(try container.decode(String.self)) {
                value = myValue
            } else {
                throw DecodingError.typeMismatch(Percent.self, .init(codingPath: decoder.codingPath, debugDescription: "`Port` is not in the expected format"))
            }
        }
    }
}

struct IPType: Decodable {
    let value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            value = try container.decode(String.self)
        } catch DecodingError.typeMismatch {
            value = String(try container.decode(Int.self))
        }
    }
}
