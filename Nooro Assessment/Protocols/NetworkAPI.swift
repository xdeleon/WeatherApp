//
//  Created by Xavier De Leon on 1/29/25.
//

import Foundation

protocol NetworkAPI {
    static func getData<T: Decodable>(_ endpoint: Endpoint, param: String) async throws -> T
}

