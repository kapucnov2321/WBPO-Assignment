//
//  ApiClient.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import Foundation
import Alamofire
import RxSwift

class ApiClient {
    
    static func register(credentials: RegisterRequestModel) -> Observable<RegisterResponseModel> {
        return request(ApiRoutes.register(credentials: credentials))
    }
    
    static func users(page: Int) -> Observable<UsersResponseModel> {
        return request(ApiRoutes.users(page: page))
    }
    
    static func image(urlString: String) -> Observable<Data> {
        guard let url = URL(string: urlString) else {
            return Observable.never()
        }

        var urlRequest = URLRequest(url: url)
    
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue(ApiConstants.ContentType.image.rawValue, forHTTPHeaderField: "Content-Type")
        
        guard let encodedRequest = try? URLEncoding.default.encode(urlRequest, with: nil) else {
            return Observable.never()
        }

        return requestData(encodedRequest)
    }
    
    private static func request<T: Codable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable(of: T.self) { response in
                Self.handleResponse(response: response, observer: observer)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private static func requestData(_ urlConvertible: URLRequestConvertible) -> Observable<Data> {
        return Observable<Data>.create { observer in
            let request = AF.request(urlConvertible).responseData { response in
                Self.handleResponse(response: response, observer: observer)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private static func handleResponse<T: Codable>(response: DataResponse<T,AFError>, observer: AnyObserver<T>) {
        switch response.result {
        case .success(let value):
            observer.onNext(value)
            observer.onCompleted()
        case .failure(let error):
            switch response.response?.statusCode {
            case 400:
                guard let responseData = response.data,
                      let errorData = try? JSONDecoder().decode(ErrorModel.self, from: responseData) else {
                    observer.onError(error)
                    return
                }
                observer.onError(ApiError.error(errorData.error))
            case 403:
                observer.onError(ApiError.forbidden)
            case 404:
                observer.onError(ApiError.notFound)
            case 500:
                observer.onError(ApiError.internalServerError)
            default:
                observer.onError(error)
            }
        }
    }
}
