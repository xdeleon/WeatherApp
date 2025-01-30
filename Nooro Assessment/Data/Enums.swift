//
//  Created by Xavier De Leon on 1/28/25.
//

import SwiftUI

enum NooroFont: String {
    case poppinsRegular = "Poppins-Regular"
    case poppinsBold = "Poppins-Bold"
}

enum NooroColor: String {
    case BackgroundGray = "BackgroundGray"
    case BlackText = "BlackText"
    case DarkGrayText = "DarkGrayText"
    case LightGrayText = "LightGrayText"
    
    func color() -> Color {
        return Color(self.rawValue)
    }
}
