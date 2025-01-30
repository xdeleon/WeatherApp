//
//  Created by Xavier De Leon on 1/28/25.
//

import Foundation

// We are assuming no optionals for the data types below to simplify code and logic of app.
struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentWeather
    
    var icon: URL {
        let iconString = current.condition.icon.replacingOccurrences(of: "//", with: "https://")
        let iconURL = URL(string: iconString)!
        return iconURL
    }
}

struct Location: Codable {
    let name: String
}

struct CurrentWeather: Decodable {
    let tempC: Double
    let condition: WeatherCondition
    let humidity: Int
    let feelslikeC: Double
    let uv: Double
}

struct WeatherCondition: Decodable {
    let icon: String
}


//MARK: Error Response
struct ErrorResponse: Decodable {
    let error: APIError
}

struct APIError: Decodable {
    let code: Int
    let message: String
}
