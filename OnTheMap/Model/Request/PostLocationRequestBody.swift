//
//  PostLocationRequestBody.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/17/21.
//

import Foundation

struct  PostLocationRequestBody: Codable{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
