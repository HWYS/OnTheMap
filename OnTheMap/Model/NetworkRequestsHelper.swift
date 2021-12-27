//
//  NetworkRequestsHelper.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 11/28/21.
//

import Foundation

class NetworkRequestsHelper {
    class func taskForGetRequests<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?,  Error?) ->  Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod =  "GET"
        if  apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        else {
            request.addValue(Constant.APPLICATION_ID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constant.API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
                else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
    }
    
    class func taskForPosRetuest<ResponseType: Decodable> (url: URL, apiType: String, responseType:  ResponseType.Type, body: String, httpMethod: String, completion: @escaping(ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
        }
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else{
                completion(nil, error)
                return
            }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
