//
//  NetworkService.swift
//  
//
//  Created by Joao Pires on 03/01/2022.
//

import Foundation

public enum GeneralError: Error {
    case failedToRead
    case failedNetwork
    case invalidParameter(Any?)
    case unknown(Error)
}

public enum NetworkError: Error {
    case unknown(Error)
    case httpCode(Int)
    case invalidResponse
    case invalidURL
    case failed
}

protocol NetworkService {
    func getRequest(from urlString: String, completion: @escaping(Result<Data, NetworkError>) -> ())
    func getRequest(from urlString: String) async throws -> Data
}

extension NetworkService {
    
    func getRequest(from urlString: String, completion: @escaping(Result<Data, NetworkError>) -> ()) {
        
        guard let requestUrl = URL(string: urlString) else {
            
            let result: Result<Data, NetworkError>
            result = .failure(.invalidURL)
            completion(result)
            return
        }
        let task = URLSession.shared.dataTask(with: requestUrl) {(data, response, error) in
            
            var result: Result<Data, NetworkError>
            guard error == nil else {
                
                print("Failed request at '\(urlString)' with error: '\(error!.localizedDescription)'")
                result = .failure(.unknown(error!))
                completion(result)
                return
            }
            guard let code = (response as? HTTPURLResponse)?.statusCode else {
                
                print("Failed request at '\(urlString)'. Response without status code.")
                result = .failure(.invalidResponse)
                completion(result)
                return
            }
            switch code {
                    
                case 200 ... 299:
                    print("Succeeded request at '\(urlString)'")
                    result = .success(data!)
                    completion(result)
                    return
                    
                default:
                    print("Failed request at '\(urlString)' with http status code: '\(code)'")
                    result = .failure(.httpCode(code))
                    completion(result)
                    return
            }
        }
        task.resume()
    }
    
    func getRequest(from urlString: String) async throws -> Data {
        
        guard let requestUrl = URL(string: urlString) else {
            
            print("Failed to make request '\(urlString)'. Invalid URL")
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: requestUrl)
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            
            print("Failed request at '\(urlString)'. Response without status code.")
            throw NetworkError.invalidResponse
        }
        switch code {
                
            case 200 ... 299:
                print("Succeeded request at '\(urlString)'")
                return data
                
            default:
                print("Failed request at '\(urlString)' with http status code: '\(code)'")
                throw NetworkError.httpCode(code)
        }
        
    }
}

