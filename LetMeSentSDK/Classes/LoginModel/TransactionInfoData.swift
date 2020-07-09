

import Foundation
struct TransactionInfoData : Codable {
	let approvedUrl : String?

	enum CodingKeys: String, CodingKey {

		case approvedUrl = "approvedUrl"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		approvedUrl = try values.decodeIfPresent(String.self, forKey: .approvedUrl)
	}

}
