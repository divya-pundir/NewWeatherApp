
import Foundation
struct Main : Codable {
	let temp : Double?
	let pressure : Int?
	let humidity : Int?
	let temp_min : Double?
	let temp_max : Double?

	enum CodingKeys: String, CodingKey {

		case temp = "temp"
		case pressure = "pressure"
		case humidity = "humidity"
		case temp_min = "temp_min"
		case temp_max = "temp_max"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		temp = try values.decodeIfPresent(Double.self, forKey: .temp)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min)
		temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max)
	}

}
