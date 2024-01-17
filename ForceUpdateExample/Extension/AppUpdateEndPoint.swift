//
//  AppUpdateEndPoint.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 16/01/24.
//

import Foundation
import NetworkKit

enum AppUpdateEndPoint {
    case appUpdateMetaData(queryParams: [String: String])
}

//  https://itunes.apple.com/br/lookup
//  https://itunes.apple.com/br/lookup?bundleId=361309726
extension AppUpdateEndPoint: EndPoint {
    var host: String {
        "itunes.apple.com"
    }

    var scheme: String {
        "https"
    }

    var path: String {
        "/br/lookup"
    }

    var method: NetworkKit.RequestMethod {
        return .get
    }

    var header: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var body: [String: String]? {
        return nil
    }

    var queryParams: [String: String]? {
        switch self {
        case .appUpdateMetaData(queryParams: let queryParams):
            return queryParams
        }
    }

    var pathParams: [String: String]? {
        return nil
    }
}

enum Constants {
    static let bundleID = ["bundleId": "com.apple.Pages"]
    static let forceUpdateTitle = "New Version Available"
    static let forceUpdateMessage = "There are new features available, please update your app"
    static let updateBtnText = "Update Now"
    static let cancelBtnText = "Cancel"
    static let learnMore = "Later"
}
