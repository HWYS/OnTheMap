//
//  PostLocationResponse.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/10/21.
//

import Foundation

struct PostLocationResponse: Codable {
    let  createdAt: String
    let  objectId: String
    
    enum CodingKeys:  String,  CodingKey{
        case  createdAt
        case objectId
    }
}
