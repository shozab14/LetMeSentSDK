

import Foundation
struct SDKLoginBase : Codable {
	let response : SDKLoginResponse?

	enum CodingKeys: String, CodingKey {

		case response = "response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		response = try values.decodeIfPresent(SDKLoginResponse.self, forKey: .response)
	}

}
