//
//  VerifyData.swift
//  LetMeSentSDK
//
//  Created by Shozab Haider macbook on 7/9/20.
//

import Foundation

struct VerifyData : Codable {
    let access_token : String?

    enum CodingKeys: String, CodingKey {

        case access_token = "access_token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
    }

}
