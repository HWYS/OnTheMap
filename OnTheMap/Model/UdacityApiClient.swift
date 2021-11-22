//
//  ApiClient.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 11/22/21.
//

import Foundation

class UdacityApiClient{
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    
    }
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        case createSessionId
        case getStudentLocaction(Int)
        case getStudentLocationByStudentId(String)
        case postStudentLocation
        case updateStudentLocation(String)
        case getUsers
        case logout
        
        var urlValue: String{
            switch self{
            case .createSessionId:
                return EndPoints.base + "session"
            case .getStudentLocaction(let index):
                return  EndPoints.base + "StudentLocation?limit=100&skip=\(index)&order=-updateAt"
            case .getStudentLocationByStudentId(let id):
                return EndPoints.base + "StudentLocation?uniqueKey=\(id)"
            case .postStudentLocation:
                return EndPoints.base + "StudentLocation"
            case .updateStudentLocation(let id):
                return EndPoints.base + "StudentLocation/\(id)"
            case .getUsers:
                return EndPoints.base + "users/" + Auth.accountKey
            case .logout:
                return EndPoints.base + "session"
            }
        }
        
        var urlRoute: URL {
            return URL(string: urlValue)!
        }
    }
    
    
    class func login(with  email: String, password: String,  completion: @escaping (Bool, Error?) ->()){
        
        var request = URLRequest(url: EndPoints.createSessionId.urlRoute)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(false,  error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            
            do  {
                let responseObject = try  decoder.decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.accountKey = responseObject.account.key
                    completion(true, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
        
    }
}
