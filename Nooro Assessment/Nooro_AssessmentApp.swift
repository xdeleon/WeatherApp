//
//  Created by Xavier De Leon on 1/28/25.
//

import SwiftUI

@main
struct Nooro_AssessmentApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(weatherVM: WeatherVM())
                .statusBarHidden()
        }
    }
}
