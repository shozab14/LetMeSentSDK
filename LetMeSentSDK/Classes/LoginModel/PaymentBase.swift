

import Foundation
struct PaymentBase : Codable {
	let success : Success?

	enum CodingKeys: String, CodingKey {

		case success = "success"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Success.self, forKey: .success)
	}

}
