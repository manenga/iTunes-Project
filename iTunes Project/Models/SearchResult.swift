//
//  SearchResult.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import Foundation

struct SearchResult: Codable {
    var resultCount: Int
    var results: [SearchItem]
}
