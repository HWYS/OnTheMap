//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/10/21.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectID: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longitude = "longitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case objectID = "objectId"
        case uniqueKey = "uniqueKey"
        case updatedAt = "updatedAt"
        
    }
}
