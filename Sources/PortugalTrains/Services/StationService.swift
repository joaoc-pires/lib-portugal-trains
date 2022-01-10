//
//  StationService.swift
//  
//
//  Created by Joao Pires on 03/01/2022.
//

import Foundation

public struct StationService: NetworkService {
    
    private let stationSearch = "https://servicos.infraestruturasdeportugal.pt/negocios-e-servicos/estacao-nome/"
    private let stationDetails = "https://servicos.infraestruturasdeportugal.pt/negocios-e-servicos/partidas-chegadas/"
    
    public struct StationQueryReply: Codable {
        public let response: [Node]?
    }
    
    
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
    
    
    public struct StationReply: Codable {
        public let response: [TimeTable]?
    }
    
    
    public struct TimeTable: Codable, Equatable {
        public let nodeId: Int?
        public let stationName: String?
        public let tableType: TimeTableType?
        public let elements: [TimeTableElement]?
        
        enum CodingKeys: String, CodingKey {
            case stationName = "NomeEstacao"
            case nodeId = "NodeID"
            case tableType = "TipoPedido"
            case elements = "NodesComboioTabelsPartidasChegadas"
        }
    }
    
    public struct TimeTableElement: Codable, Equatable {
        public let hasPassed: Bool?
        public let time: String?
        public let timeToOrder: String?
        public let timeToOrder2: String?
        public let destinyStationId: Int?
        public let origineStationId: Int?
        public let trainId: Int?
        public let trainId2: Int?
        public let destinyStationName: String?
        public let origineStationName: String?
        public let observations: String?
        public let company: String?
        public let serviceType: String?

        enum CodingKeys: String, CodingKey {
            case hasPassed = "ComboioPassou"
            case time = "DataHoraPartidaChegada"
            case timeToOrder = "DataHoraPartidaChegada_ToOrderBy"
            case timeToOrder2 = "DataHoraPartidaChegada_ToOrderByi"
            case destinyStationId = "EstacaoDestino"
            case origineStationId = "EstacaoOrigem"
            case trainId = "NComboio1"
            case trainId2 = "NComboio2"
            case destinyStationName = "NomeEstacaoDestino"
            case origineStationName = "NomeEstacaoOrigem"
            case observations = "Observacoes"
            case company = "Operador"
            case serviceType = "TipoServico"
        }
    }
    
    public init() { }
    
    
    /// This method returns synchronously a Reply object that contains the array of results.
    /// - Note: NetworkError contains an Unknown case which can contain an more specific error inside!
    /// - Parameters:
    ///   - query: The String to search for
    ///   - completion: Called when the calls ends. Can return success with a Reply or failure with a Network Error
    public func search(for query: String, completion: @escaping( Result<StationQueryReply, NetworkError>) -> ()) {
        
        guard !query.isEmpty else {
            
            print("Can't make request with empty query")
            completion(.failure(.unknown(GeneralError.invalidParameter("Can't make request with empty query"))))
            return
        }
        let url = "\(stationSearch)\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)"
        getRequest(from: url) { result in
            
            switch result {
                
                case .success(let data):
                    do {
                        
                        let decoder = JSONDecoder()
                        let reply = try decoder.decode(StationQueryReply.self, from: data)
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
    
    
    /// This method returns asynchronously a Reply object that contains the array of results.
    /// - Note: NetworkError contains an Unknown case which can contain an more specific error inside!
    /// - Parameter query: The String to search for
    /// - Returns: return a Reply object or throws a Network Error.
    public func search(for query: String) async throws -> StationQueryReply {
        
        guard !query.isEmpty else { throw GeneralError.invalidParameter(query) }
        let url = "\(stationSearch)\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)"
        let result = try await getRequest(from: url)
        do {
            
            let decoder = JSONDecoder()
            let reply = try decoder.decode(StationQueryReply.self, from: result)
            return reply
        }
        catch let error {
            
            print(error.localizedDescription)
            throw GeneralError.unknown(error)
        }
    }
    
    
    /// This method returns a Result object which contains the array of results
    /// - Parameters:
    ///   - stationId: the Node Id of the station
    ///   - startTime: Lower limit of the time table. Leave blank to have current time.
    ///   - endTime: Upper limit of the time table. Leave blank to default to end of day
    ///   - completion: return a Result which if successfull contains a StationReply object with a list of departures and arrivals.
    public func getTimeTable(forStationId stationId: Int, startTime: Date = Date(), endTime: Date? = nil, completion: @escaping( Result<StationReply, NetworkError>) -> ()) {
        
        let endTime = endTime ?? Date.endOfDay
        let url = "\(stationDetails)\(stationId)/\(startTime.ipFormated)/\(endTime.ipFormated)"
        getRequest(from: url) { result in
            
            switch result {
                    
                case .success(let data):
                    do {
                        
                        let decoder = JSONDecoder()
                        let reply = try decoder.decode(StationReply.self, from: data)
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
    ///   - stationId: the Node Id of the station
    ///   - startTime: Lower limit of the time table. Leave blank to have current time.
    ///   - endTime: Upper limit of the time table. Leave blank to default to end of day
    /// - Returns: Result which if successfull contains a StationReply object with a list of departures and arrivals.
    public func getTimeTable(forStationId stationId: Int, startTime: Date = Date(), endTime: Date? = nil) async throws -> StationReply {
        
        let endTime = endTime ?? Date.endOfDay
        let url = "\(stationDetails)\(stationId)/\(startTime.ipFormated)/\(endTime.ipFormated)"
        let result = try await getRequest(from: url)
        do {
            
            let decoder = JSONDecoder()
            let reply = try decoder.decode(StationReply.self, from: result)
            return reply
        }
        catch let error {
            
            print(error.localizedDescription)
            throw GeneralError.unknown(error)
        }
    }
}
