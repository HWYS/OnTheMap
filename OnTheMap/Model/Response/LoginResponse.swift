//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 11/22/21.
//

import Foundation

struct  LoginResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey{case account, session}
}

struct Account: Codable {
    let  registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {case registered, key}
}

struct Session: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys:  String, CodingKey {case id, expiration}
}
