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
        
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        NetworkRequestsHelper.taskForPosRetuest(url: EndPoints.createSessionId.urlRoute, apiType: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "POST") {
            (response, error) in
            
            if let response = response {
                DispatchQueue.main.async {
                    Auth.sessionId = response.session.id
                    Auth.accountKey = response.account.key
                    completion(true, nil)
                }
                
            } else {
                completion(false, error)
            }
        }
        
    }
    
    class func getStudentLocation(singleStudent: Bool, completion: @escaping([StudentLocation]?, Error?)  -> Void) {
        NetworkRequestsHelper.taskForGetRequests(url: EndPoints.getStudentLocaction(0).urlRoute, apiType: "Parse", responseType: StudentLocation.self){(response,  error) in
            
            guard let response = response else{
                completion([],  error)
                return
            }
            //completion(response.results, nil)
        }
    }
}
