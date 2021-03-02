

import Foundation
struct Sys : Codable {
	let type : Int?
	let id : Int?
	let message : Double?
	let country : String?
	let sunrise : Int?
	let sunset : Int?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case id = "id"
		case message = "message"
		case country = "country"
		case sunrise = "sunrise"
		case sunset = "sunset"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(Int.self, forKey: .type)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		message = try values.decodeIfPresent(Double.self, forKey: .message)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
	}

}
