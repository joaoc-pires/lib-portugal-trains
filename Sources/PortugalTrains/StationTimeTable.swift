//
//  TimeTable.swift
//  
//
//  Created by Joao Pires on 10/01/2022.
//

import Foundation

public struct StationTimeTable: Codable, Equatable {
    public let nodeId: Int?
    public let stationName: String?
    public let tableType: TimeTableType?
    public let elements: [StationTimeTableElement]?
    
    enum CodingKeys: String, CodingKey {
        case stationName = "NomeEstacao"
        case nodeId = "NodeID"
        case tableType = "TipoPedido"
        case elements = "NodesComboioTabelsPartidasChegadas"
    }
}

public struct StationTimeTableElement: Codable, Equatable {
    public let hasPassed: Bool?
    public let time: String?
    public let timeToOrder: String?
    public let timeToOrder2: String?
    public let destinyStationId: Int?
    public let originStationId: Int?
    public let trainId: Int?
    public let trainId2: Int?
    public let destinyStationName: String?
    public let originStationName: String?
    public let observations: String?
    public let company: String?
    public let serviceType: String?
    
    enum CodingKeys: String, CodingKey {
        case hasPassed = "ComboioPassou"
        case time = "DataHoraPartidaChegada"
        case timeToOrder = "DataHoraPartidaChegada_ToOrderBy"
        case timeToOrder2 = "DataHoraPartidaChegada_ToOrderByi"
        case destinyStationId = "EstacaoDestino"
        case originStationId = "EstacaoOrigem"
        case trainId = "NComboio1"
        case trainId2 = "NComboio2"
        case destinyStationName = "NomeEstacaoDestino"
        case originStationName = "NomeEstacaoOrigem"
        case observations = "Observacoes"
        case company = "Operador"
        case serviceType = "TipoServico"
    }
}
