

import Foundation
struct SDKLoginResponse : Codable {
	let user_id : Int?
	let first_name : String?
	let last_name : String?
	let email : String?
	let formattedPhone : String?
	let picture : String?
	let token : String?
	let status : Int?
	let message : String?
	let user_status : String?

	enum CodingKeys: String, CodingKey {

		case user_id = "user_id"
		case first_name = "first_name"
		case last_name = "last_name"
		case email = "email"
		case formattedPhone = "formattedPhone"
		case picture = "picture"
		case token = "token"
		case status = "status"
		case message = "message"
		case user_status = "user-status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		formattedPhone = try values.decodeIfPresent(String.self, forKey: .formattedPhone)
		picture = try values.decodeIfPresent(String.self, forKey: .picture)
		token = try values.decodeIfPresent(String.self, forKey: .token)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		user_status = try values.decodeIfPresent(String.self, forKey: .user_status)
	}

}
