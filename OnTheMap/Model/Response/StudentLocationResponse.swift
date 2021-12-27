//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/10/21.
//

import Foundation

struct StudentLocationResponse: Codable{
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
