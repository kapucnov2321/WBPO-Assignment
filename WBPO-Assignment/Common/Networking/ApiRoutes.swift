//
//  ApiRoutes.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import Foundation
import Alamofire

enum ApiRoutes: URLRequestConvertible {
    
    case register(credentials: RegisterRequestModel)
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApiConstants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ApiConstants.ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")

        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    private var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .register:
            return "register"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .register(let credentials):
            return credentials.parameterRepresentation
        }
    }

}

struct ApiConstants {
    
    static let baseUrl = "https://reqres.in/api/"
    
    enum ContentType: String {
        case json = "application/json"
    }
    
}

enum ApiError: Error {
    case forbidden
    case notFound
    case internalServerError
    case error(String)
}

extension ApiError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .forbidden:
            return "Wrong authorization. Try again later"
        case .notFound:
            return "Endpoint not found. Try again later"
        case .internalServerError:
            return "Internal server error. Try again later"
        case .error(let errorMessage):
            return errorMessage
        }
    }

}
