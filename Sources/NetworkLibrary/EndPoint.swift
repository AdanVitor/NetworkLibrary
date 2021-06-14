//
//  EndPoint.swift
//  Clima
//
//  Created by Adan on 13/06/21.
//
// Base code
// https://www.swiftbysundell.com/articles/constructing-urls-in-swift/

import Foundation
import Combine

public struct EndPoint{
    
    let baseUrl : String
    let queryItems : [URLQueryItem]
    
    public init(baseUrl: String, queryItems : [URLQueryItem] = []) {
        self.baseUrl = baseUrl
        self.queryItems = queryItems
    }
    
    public init(baseUrl: String, queryItemsAsDictionary : [String : String?]){
        let queryItems = queryItemsAsDictionary.map{key, value in
            URLQueryItem(name: key, value: value)
        }
        self.init(baseUrl: baseUrl, queryItems: queryItems)
    }
    
}

public extension EndPoint {
    
    var urlOptional: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.path = self.baseUrl
        components.queryItems = queryItems
        return components.url
    }
    
    func createURLRequest(httpMethod : HTTPMethod,
                          headerParameters : [String : String?]? = nil,
                          bodyParameters: [String : String?]? = nil) -> URLRequest?{
        guard let url = urlOptional else { return nil }
        return URLRequest(url: url,
                          httpMethod: httpMethod,
                          headerParameters: headerParameters,
                          bodyParameters: bodyParameters)
    }
}


