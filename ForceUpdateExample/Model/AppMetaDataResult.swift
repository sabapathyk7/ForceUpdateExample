//
//  AppMetaDataResult.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 16/01/24.
//

import Foundation

// MARK: - AppMetaDataResult
struct AppMetaDataResult: Codable {
    let resultCount: Int
    let results: [AppMetaData]
}

// MARK: - Result
struct AppMetaData: Codable {
    let releaseDate: String
    let releaseNotes: String
    let averageUserRatingForCurrentVersion: Double
    let trackViewUrl: URL
    let version: String
}

typealias AppMetaDataInfo = [AppMetaData]
