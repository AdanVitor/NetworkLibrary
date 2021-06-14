//
//  URLRequestExtensions.swift
//  Clima
//
//  Created by Adan on 13/06/21.
//

import Foundation
import Combine

public extension URLRequest{
    
    init(url : URL, httpMethod: HTTPMethod,
         headerParameters : [String : String?]? = nil,
         bodyParameters : [String : String?]? = nil){
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue
        if let headerParams = headerParameters{
            headerParams.forEach{ key, value in
                self.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let bodyParams = bodyParameters{
            self.httpBody = URLRequest.createRequestBody(values: bodyParams)
        }
    }
    
    mutating func setHeader(parameters : [String : String?]){
        parameters.forEach{ key, value in
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    // https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
    static func createRequestBody(values : [String : String?]) -> Data?{
        var components = URLComponents()
        components.queryItems = values.map{ key, value in
            URLQueryItem(name: key , value: value)
        }
        return components.query?.data(using: .utf8)
    }
    
    func createJsonPublisherRequest<T : Codable>(jsonType : T.Type) -> AnyPublisher<T,Error>{
        return URLSession.shared.fetchJson(request: self,
                                                      jsonType: jsonType)
    }
}

public enum URLRequestError : Error{
    case requestNotBuilt
}

public extension Optional where Wrapped == URLRequest{
    
    func fetchJsonPublisher<T : Codable>(jsonType : T.Type) -> AnyPublisher<T,Error>{
        guard let self = self else {
            return Fail<T,Error>(error : URLRequestError.requestNotBuilt).eraseToAnyPublisher()}
        return URLSession.shared.fetchJson(request: self,jsonType: jsonType)
    }
    
    func testFetchJson(){
        guard let request = self else {
            print("Request is null")
            return
        }
        let requestTask = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data , error == nil else{
                print(error?.localizedDescription ?? "")
                return
            }
            do{
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(jsonObject)
            }catch{
                print(error.localizedDescription)
            }
        }
        requestTask.resume()
    }
}
