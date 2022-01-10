//
//  File.swift
//  
//
//  Created by Joao Pires on 10/01/2022.
//

import Foundation

public struct Node: Codable, Hashable {
    public let distance: Int?
    public let id: Int?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case distance = "Distancia"
        case id = "NodeID"
        case name = "Nome"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(distance)
        hasher.combine(name)
    }
}

