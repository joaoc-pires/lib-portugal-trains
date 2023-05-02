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
    private let serviceType = "INTERNACIONAL,%20ALFA,%20IC,%20IR,%20REGIONAL,%20URB%7CSUBUR,%20ESPECIAL,%20MERCADORIAS,%20SERVI%C3%87O"
    public struct StationQueryReply: Codable {
        public let response: [Node]?
    }
    
    public struct StationReply: Codable {
        public let response: [StationTimeTable]?
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
        let url = "\(stationDetails)\(stationId)/\(startTime.ipFormated)/\(endTime.ipFormated)/\(serviceType)"
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
