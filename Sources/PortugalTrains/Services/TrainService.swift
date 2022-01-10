//
//  TrainService.swift
//  
//
//  Created by Joao Pires on 10/01/2022.
//

import Foundation

public struct TrainService: NetworkService {
    private let url = "https://servicos.infraestruturasdeportugal.pt/negocios-e-servicos/horarios-ncombio/"
    
    public struct TrainReply: Codable {
        public let response: TrainTimeTable?
    }

    
    public init() { }
    
    /// This method returns a Result object which contains the array of results
    /// - Parameters:
    ///   - trainId: the Train Id
    ///   - day: The day which to get the timetable for inf formate yyyy-MM-dd.
    ///   - completion: return a Result which if successfull contains a TrainReply object with an object detailling the train route.
    public func getTimeTable(forTrainId trainId: Int, day: Date = Date(), completion: @escaping( Result<TrainReply, NetworkError>) -> ()) {
        
        let url = "\(url)\(trainId)/\(day.ipFormatedDay)"
        getRequest(from: url) { result in
            
            switch result {
                    
                case .success(let data):
                    do {
                        
                        let decoder = JSONDecoder()
                        let reply = try decoder.decode(TrainReply.self, from: data)
                        completion(.success(reply))
                    }
                    catch let error {
                        
                        print(error.localizedDescription)
                        completion(.failure(.unknown(error)))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    
    
    /// This method returns asynchronously a Result object which contains the array of results
    /// - Parameters:
    ///   - trainId: the Train Id
    ///   - day: The day which to get the timetable for inf formate yyyy-MM-dd.
    /// - Returns: Result which if successfull contains a TrainReply object with an object detailling the train route.
    public func getTimeTable(forTrainId trainId: Int, day: Date = Date()) async throws -> TrainReply {
        
        let url = "\(url)\(trainId)/\(day.ipFormatedDay)"
        let result = try await getRequest(from: url)
        do {
            
            let decoder = JSONDecoder()
            let reply = try decoder.decode(TrainReply.self, from: result)
            return reply
        }
        catch let error {
            
            print(error.localizedDescription)
            throw GeneralError.unknown(error)
        }
    }
}

public struct TrainTimeTable: Codable {
    public var arrivalTime: String?
    public var departureTime: String?
    public var destiny: String?
    public var duration: String?
    public var company: String?
    public var origin: String?
    public var status: String?
    public var serviceType: String?
    public var nodes: [TrainTimeTableElement]?

    public enum CodingKeys: String, CodingKey {
        case arrivalTime = "DataHoraDestino"
        case departureTime = "DataHoraOrigem"
        case destiny = "Destino"
        case duration = "DuracaoViagem"
        case company = "Operador"
        case origin = "Origem"
        case status = "SituacaoComboio"
        case serviceType = "TipoServico"
        case nodes = "NodesPassagemComboio"
    }
}

public struct TrainTimeTableElement: Codable, Hashable, Equatable {
    public var hasPassed: Bool?
    public var scheduledTime: String?
    public var nodeID: Int
    public var stationName: String?
    public var notes: String?
    
    public enum CodingKeys: String, CodingKey {
        case hasPassed = "ComboioPassou"
        case scheduledTime = "HoraProgramada"
        case nodeID = "NodeID"
        case stationName = "NomeEstacao"
        case notes = "Observacoes"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hasPassed)
        hasher.combine(scheduledTime)
        hasher.combine(nodeID)
        hasher.combine(stationName)
        hasher.combine(notes)
    }
}
