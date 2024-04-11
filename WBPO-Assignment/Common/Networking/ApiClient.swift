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
    
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable(of: T.self) { response in
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
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
