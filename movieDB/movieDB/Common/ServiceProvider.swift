//
//  ServiceProvider.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
    case empty
}

class ServiceProvider<T: Service> {
    var urlSession = URLSession.shared

    init() { }

    func load(service: T, completion: @escaping (Result<Data>) -> Void) {
        call(service.urlRequest, completion: completion)
    }

    func load<U>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) where U: Decodable {
        call(service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    completion(.success(resp))
                }
                catch {
                    completion(.failure(NetworkError.decodingFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            case .empty:
                completion(.empty)
            }
        }
    }
}

extension ServiceProvider {
    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data>) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
           guard appDelegate.isConnectedToInternet else {
               completion(.failure(NetworkError.noNetwork))
               return
           }
       }
        
        urlSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                deliverQueue.async {
                    completion(.failure(error))
                }
            } else if let data = data {
                deliverQueue.async {
                    completion(.success(data))
                }
            } else {
                deliverQueue.async {
                    completion(.empty)
                }
            }
            }.resume()
    }
}

