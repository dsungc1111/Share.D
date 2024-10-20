//
//  TargetType.swift
//  Agewise
//
//  Created by 최대성 on 8/14/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try baseURL.asURL()
        
        var component = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        
        if let queryItems = queryItems {
            component?.queryItems = queryItems
        }
        guard let finalUrl = component?.url else {
            throw URLError(.badURL)
        }
        
        var request = try URLRequest(url: finalUrl, method: method)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        
        return request
    }
    
}
