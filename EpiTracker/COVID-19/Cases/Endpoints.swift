//
//  Endpoints.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://corona.lmao.ninja"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    
    enum Corona: Endpoint {
        case fetch
        
        public var path: String {
            switch self {
            case .fetch: return "/v2/countries"
            }
        }
        
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseUrl)\(path)"
            }
        }
    }
}
