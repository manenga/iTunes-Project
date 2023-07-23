//
//  Response.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import Foundation

// MARK: - Welcome
struct Response: Codable {
    var resultCount: Int
    var results: [SearchResult]
}

// MARK: - SearchResult
struct SearchResult: Codable, Hashable, Identifiable {
    var id = UUID()
    var trackID: Int?
    var artistName, kind: String?
    var collectionName: String?
    var trackName: String?
    var collectionArtistID: Int?
    var previewURL: String?
    var artworkUrl30, artworkUrl60, artworkUrl100: String?
    var trackPrice: Int?
    var releaseDate: String?
    var trackTimeMillis: Int?
    var currency: Currency?
    var primaryGenreName: String?
    var shortDescription: String?

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName, collectionName, trackName, kind
        case collectionArtistID = "collectionArtistId"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, trackPrice
        case releaseDate, trackTimeMillis, currency, primaryGenreName
        case shortDescription
    }
}

enum Currency: String, Codable {
    case dkk = "DKK"
}
