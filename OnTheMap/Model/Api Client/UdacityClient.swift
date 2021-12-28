//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/14/21.
//

import Foundation
import MapKit

class  UdacityClient {
    
    struct Auth  {
        static var accountKey = ""
        static var sessionId = ""
        static var objectId = ""
        static var studentPostedCoordinate = CLLocationCoordinate2D()
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case logout
        case getStudentLocations
        case postStudentLocation
        case updateStudentLocation(String)
        
        var urlString: String {
            switch self {
            case .login:
                return Endpoints.base + "session"
                
            case .logout: return Endpoints.base + "session"
            case .getStudentLocations: return Endpoints.base + "StudentLocation?order=-updatedAt&limit=100"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "StudentLocation/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    enum RequestMethod: String{
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    class func login(email: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        
        /*(var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            do {
                let responseObject = try  JSONDecoder().decode(LoginResponse.self, from: newData)
                Auth.accountKey = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
            }catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                
            }
        }
        task.resume()*/
        
        let body = LogInRequestBody(udacity: Udacity(username: email, password: password))
        taskForPosRetuest(url: Endpoints.login.url, requestMethod: .post, isUdacityApi: true, responseType: LoginResponse.self, requestBody: body) { response, error in
            if let response = response {
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                print(Auth.accountKey)
                completion(true, nil)
            }else{
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping(Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                
                return
            }
            DispatchQueue.main.async {
                Auth.sessionId = ""
                Auth.accountKey = ""
                completion(true, nil)
            }
            
        }
        task.resume()
    }
    
    class func postLocation(locationData: PostLocationRequestBody, completion: @escaping(Bool, Error?) -> Void) {
        /*var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try! JSONEncoder().encode(locationData)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do{
                let responseObject = try JSONDecoder().decode(PostLocationResponse.self, from: data)
                print(responseObject.objectId)
                completion(true, nil)
            }catch{
                completion(false, error)
            }
        }
        task.resume()*/
        
        taskForPosRetuest(url: Endpoints.postStudentLocation.url, requestMethod: .post, isUdacityApi: false, responseType: PostLocationResponse.self, requestBody: locationData) { response, error in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true,  nil)
            }else{
                completion(false, error)
            }
        }
    }
    
    class func updateLocation(objectId: String, locationData: PostLocationRequestBody, completion: @escaping (Bool, Error?) -> Void){
        
        /*var request = URLRequest(url: Endpoints.updateStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(locationData)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do{
                let responseObject = try JSONDecoder().decode(PostLocationResponse.self, from: data)
                print(responseObject.objectId)
                completion(true, nil)
            }catch{
                completion(false, error)
            }
        }
        task.resume()*/
        
        taskForPosRetuest(url: Endpoints.updateStudentLocation(objectId).url, requestMethod: .put, isUdacityApi: false, responseType: PostLocationResponse.self, requestBody: locationData) { response, error in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true,  nil)
            }else{
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        /*let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocations.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            
            do{
                let responseObject = try JSONDecoder().decode(StudentLocationResponse.self, from: data)
                completion(responseObject.results, nil)
            }catch{
                completion([], error)
            }
        }
        task.resume()*/
        taskForGetRequests(url: Endpoints.getStudentLocations.url, isUdacityApi: false, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            }else{
                completion([], error)
            }
        }
    }
    
    
    class func taskForGetRequests<ResponseType: Decodable>(url: URL, isUdacityApi: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?,  Error?) ->  Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod =  "GET"
        if  isUdacityApi {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if isUdacityApi {
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
    
    class func taskForPosRetuest<RequestType:  Encodable,  ResponseType: Decodable> (url: URL, requestMethod: RequestMethod, isUdacityApi: Bool, responseType:  ResponseType.Type, requestBody: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if isUdacityApi {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
        }
        request.httpBody = try! JSONEncoder().encode(requestBody)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else{
                completion(nil, error)
                return
            }
            do {
                if isUdacityApi {
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
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
            }
        }
        task.resume()
    }
    
}
