//
//  Created by Xavier De Leon on 1/28/25.
//

import Foundation

enum NooroError: Error {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case invalidData
    case unableToDecodeData
    case error400(String)
}

enum Endpoint: String {
    case apiWeather = "https://api.weatherapi.com/v1/current.json?key=<ADD_API_KEY>&q=%@&aqi=no"
}

struct NetworkServices {
    /*
     Intentionally empty. Assessment required using POP so the decision to use POP here is somewhat
     forced or a small app simply to show I know how code with POP.
     */
}

// Intentionally uses of generics so this function can be re-used for other calls.
extension NetworkServices: NetworkAPI {
    static func getData<T: Decodable>(_ endpoint: Endpoint, param: String) async throws -> T {
        var urlString = endpoint.rawValue
        
        if !param.isEmpty {
            urlString = urlString.replacingOccurrences(of: "@", with: param)
        }
        
        guard let url = URL(string: urlString ) else {
            throw NooroError.invalidURL
        }
        
        let headers = [
            "Accept" : "application/geo+json",
            "User-Agent" : "nooro-assessment-v1, xdeleon@gmail.com",
            "Connection" : "keep-alive",
            "Content-Type" : "application/json",
        ]
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as! HTTPURLResponse).statusCode
        
        // We aren't exhaustive in checking due to time constraints of assessment.
        if statusCode != 200 && statusCode != 400 {
            throw NooroError.invalidRequest
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Print debug code intentionally left in.
        do {
            if statusCode == 400 {
                let errorData = try decoder.decode(ErrorResponse.self, from: data)
                print("❌ Error Data: \(data)")
                let error = NooroError.error400(errorData.error.message)
                throw error
            } else {
                let data = try decoder.decode(T.self, from: data)
                print(data as Any)
                return data
            }
        } catch DecodingError.dataCorrupted(let context) {
            print("❌ corrupted:", context)
            throw NooroError.unableToDecodeData
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ Key '\(key)' not found:", context.debugDescription)
            print("❌ codingPath:", context.codingPath)
            throw NooroError.unableToDecodeData
        } catch DecodingError.valueNotFound(let value, let context) {
            print("❌ Value '\(value)' not found:", context.debugDescription)
            print("❌ codingPath:", context.codingPath)
            throw NooroError.unableToDecodeData
        } catch DecodingError.typeMismatch(let type, let context) {
            print("❌ *** Type '\(type)' mismatch:", context.debugDescription)
            print("❌ *** codingPath:", context.codingPath)
            throw NooroError.unableToDecodeData
        }
    }
}
