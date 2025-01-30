//
//  Created by Xavier De Leon on 1/29/25.
//

import Foundation


final class WeatherVM: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var searchText = ""
    @Published var selectedResult = false
    @Published var displaySearchError = false
    @Published var apiKeyMissing = true
    
    init(weather: WeatherResponse? = nil, searchText: String = "") {
        self.weather = weather
        self.searchText = searchText
        
        checkAPIKey()
    }
    
    private func checkAPIKey() {
        if Endpoint.apiWeather.rawValue == "https://api.weatherapi.com/v1/current.json?key=<ADD_API_KEY>&q=%@&aqi=no" {
            apiKeyMissing = true
        } else {
            apiKeyMissing = false
        }
    }
    
    @MainActor
    func getWeatherData() {
        checkAPIKey()
        guard apiKeyMissing == false else { return }
        
        selectedResult = false
        displaySearchError = false

        Task {
            do {
                self.weather = try await NetworkServices.getData(.apiWeather, param: searchText)
            } catch(let error) {
                print("Error: \(error)")
                displaySearchError = true
            }
        }
    }
}
