//
//  URLExtensions.swift
//  Clima
//
//  Created by Adan on 13/06/21.
//

import Foundation

public extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
    
    func queryValueFor(key : String) -> String?{
        let component = URLComponents(string: self.absoluteString)
        let value = component?.queryItems?.first(where: {$0.name == key})?.value
        return value
    }
}
