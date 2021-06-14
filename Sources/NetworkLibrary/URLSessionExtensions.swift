//
//  URLSessionExtensions.swift
//  Clima
//
//  Created by Adan on 13/06/21.
//

import Foundation
import Combine

public extension URLSession{
    
    func fetchJson<T : Codable>(request : URLRequest, jsonType : T.Type) -> AnyPublisher<T,Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: jsonType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
