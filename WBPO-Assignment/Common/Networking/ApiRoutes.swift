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
    case users(page: Int)

    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: ApiConstants.baseUrl) else {
            throw AFError.createURLRequestFailed(error: NSError(domain: "Unable to create URLComponents", code: -1000))
        }

        urlComponents.path = path

        if let queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw AFError.createURLRequestFailed(error: NSError(domain: "Unable to create URL", code: -1000))
        }

        var urlRequest = URLRequest(url: url)
    
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
    
    private var baseUrl: String {
        switch self {
        default:
            return "https://reqres.in"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        case .users:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .register:
            return "/api/register"
        case .users:
            return "/api/users"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .users(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        default:
            return nil
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .register(let credentials):
            return credentials.parameterRepresentation
        case .users:
            return nil
        }
    }

}

struct ApiConstants {
    
    static let baseUrl = "https://reqres.in/api/"
    
    enum ContentType: String {
        case json = "application/json"
        case image = "image/jpeg"
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
