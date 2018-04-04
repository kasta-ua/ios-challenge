//
//  KastaAPI.swift
//  ikasta
//
//  Created by Zoreslav Khimich on 10/18/17.
//  Copyright © 2017 modnakasta. All rights reserved.
//

import Moya

enum KastaAPI {
    /// Active and scheduled campaigns
    case campaigns
}

extension KastaAPI: TargetType {
    
    static let baseAddress = "https://modnakasta.ua"
    
    var baseURL: URL {
        return URL(string: KastaAPI.baseAddress + "/api/v2/")!
    }
    
    var path: String {
        switch self {
        case .campaigns:
            return "campaigns"
        }
    }
        
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .campaigns:
            return Stubs.campaigns.data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .campaigns:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

extension KastaAPI {
    static let standardDecoder: JSONDecoder = {
        let iso8601Full: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        
        let d = JSONDecoder()
        d.dateDecodingStrategy = .formatted(iso8601Full)
        return d
    }()
}

