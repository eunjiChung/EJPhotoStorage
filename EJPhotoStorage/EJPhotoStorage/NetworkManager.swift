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
        
        guard let url = UrlForRequest(path: path, query: query, header: header) else { return }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            {
                let result = self.JSONencode(data: data)
                DispatchQueue.main.async {
                    success(result, "\(response.statusCode)")
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
                                   header: HTTPHeaders) -> URLRequest? {
        let fullPath = baseURL + path
        var urlComponents = URLComponents(string: fullPath)!
        urlComponents.queryItems = [ URLQueryItem(name: "query", value: query) ]
        
        var request = URLRequest(url: urlComponents.url!)
    
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    fileprivate func JSONencode(data: Data) -> JSONDictionary {
        guard let json = try! JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else { return ["":""] }
        return json
    }
    
}
