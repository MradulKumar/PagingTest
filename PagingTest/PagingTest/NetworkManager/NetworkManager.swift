//
//  NetworkManager.swift
//  PagingTest
//
//  Created by Mradul Kumar on 19/04/2024.
//

import Foundation
import PromiseKit

enum ApiError: Error {
    case badURL
    case noData
}

enum ApiUrls: String {
    case posts = "https://jsonplaceholder.typicode.com/posts"
}

extension Error {
    
    var displayMessage: String {
        if let error = self as? ApiError {
            switch error {
            case .badURL:
                return "Bad Url Request"
            case .noData:
                return "No More Data To Show"
            }
        }
        
        return "Data Fetch Error"
    }
}

final class NetworkManager {
    
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
}

private extension NetworkManager {
    
    func getTestDataModelsFor(page: Int, limit: Int) -> Promise<[ApiData]> {
        return Promise { seal in
            let postsPath = ApiUrls.posts.rawValue
            guard let url = URL(string: postsPath) else { return seal.reject(ApiError.badURL) }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest,
                                                  completionHandler: ({ data, response, error in
                if let _ = response as? HTTPURLResponse {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode([ApiData].self, from: data)
                            seal.fulfill(decodedData)
                        } catch {
                            seal.reject(error)
                        }
                    } else {
                        print("Data is nil or can't be created from data")
                        seal.reject(ApiError.noData)
                    }
                } else {
                    print("Response error! Response is not HTTPURLResponse")
                    seal.reject(ApiError.noData)
                }
            }))
            task.resume()
        }
    }
}

extension NetworkManager {
    
    public func getApiDataFor(page: Int, limit: Int) -> Promise<[ApiData]> {
        return getTestDataModelsFor(page: page, limit: limit)
    }
}
