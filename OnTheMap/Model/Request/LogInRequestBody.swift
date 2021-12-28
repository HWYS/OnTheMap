//
//  LogInRequestBody.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/28/21.
//

import Foundation

struct LogInRequestBody: Codable {
    let udacity: Udacity
}
struct Udacity: Codable  {
    let username: String
    let password: String
}
