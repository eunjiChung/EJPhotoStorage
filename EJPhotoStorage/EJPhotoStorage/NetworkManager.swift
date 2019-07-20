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
    var errorMessage = ""
    
    fileprivate let baseURL: String
    
    // MARK: - Init
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // MARK: - Request
    func GETRequest(path: String,
                    query: String,
                    header: HTTPHeaders,
                    success: @escaping SuccessHandler,
                    failure: @escaping FailureHandler)
    {
        dataTask?.cancel()
        
        let url = UrlForRequest(path: path, query: query, header: header)
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                DispatchQueue.main.async {
                    success(data, "\(response.statusCode)")
                }
            } else if let error = error {
                failure(error, error.localizedDescription)
            }
        })
        
        dataTask?.resume()
    }
    
    // MARK: - Private Method
    fileprivate func UrlForRequest(path: String,
                                   query: String,
                                   header: HTTPHeaders) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL + path)!
        urlComponents.query = query
        var request = URLRequest(url: (urlComponents.url)!)
        
        for (key, value) in header {
//            request.value(forHTTPHeaderField: key)
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
}
