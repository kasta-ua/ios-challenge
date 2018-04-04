//
//  API.Campaign.swift
//  ikasta
//
//  Created by Zoreslav Khimich on 1/12/18.
//  Copyright © 2018 modnakasta. All rights reserved.
//

import Foundation

extension KastaAPI {
    struct Campaign: Codable, TimeFramed, Tagged {
        let id: Int
        let name: String
        let description: String
        let startsAt: Date
        let finishesAt: Date
        let nowImage: String
        let tags: String
        let codename: String
        
        static let decoder = KastaAPI.standardDecoder
        
        enum CodingKeys: CodingKey, String {
            case id = "id"
            case name = "name"
            case description = "description"
            case startsAt = "starts_at"
            case finishesAt = "finishes_at"
            case nowImage = "now_image"
            case tags = "tags"
            case codename = "code_name"
        }
    }
}
