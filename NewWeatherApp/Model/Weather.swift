

import Foundation
struct Weather : Codable {
	let id : Int
	let main : String
	let description : String
	let icon : String

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case main = "main"
		case description = "description"
		case icon = "icon"
	}
}
