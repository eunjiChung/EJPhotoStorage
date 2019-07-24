//
//  EJNetworkManager.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 20/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // MARK: - Constants
    let defaultSession = URLSession(configuration: .default)
    
    // MARK: - Variables and Properties
    var dataTask : URLSessionDataTask?
    
    // MARK: - Request
    func GETRequest(path: String,
                    query: [URLQueryItem],
                    header: HTTPHeaders,
                    success: @escaping (Data) -> (),
                    failure: @escaping FailureHandler)
    {
        guard let url = UrlForRequest(path: path, query: query, header: header) else { return }
        
        dataTask = defaultSession.dataTask(with: url,
                                           completionHandler: { (data, response, error) in
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                success(data)
            } else if let error = error {
                failure(error)
            }
        })
        
        dataTask?.resume()
    }
    
    // MARK: - Private Method
    fileprivate func UrlForRequest(path: String,
                                   query: [URLQueryItem],
                                   header: HTTPHeaders) -> URLRequest? {
        var urlComponents = URLComponents(string: path)!
        urlComponents.queryItems = query
        
        var request = URLRequest(url: urlComponents.url!)
    
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }

}
