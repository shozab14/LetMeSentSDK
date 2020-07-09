

import Foundation
struct Success : Codable {
	let status : Int?
	let message : String?
	let successPath : String?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case successPath = "successPath"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		successPath = try values.decodeIfPresent(String.self, forKey: .successPath)
	}

}
