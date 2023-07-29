//
//  APIManager.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import Combine
import Foundation

enum APIManager {
    // shared instance of the API client used to make network calls. Used below
    static let apiClient = APIClient()
    // base url of the API
    static let baseUrl: String = "https://itunes.apple.com/search?term="
    // country filter so results are limited to Dennmark
    static let countryFilter: String = "&country=DK"
    // limit filter to limit results per page to 50 so loads are fast
    static let limitFilter: String = "&limit=50"
}

extension APIManager {
    static func request(term: String) -> AnyPublisher<Response, Error> {
        return makeRequest(searchTerm: term)
    }

    private static func makeRequest<T: Decodable>(searchTerm: String) -> AnyPublisher<T, Error> {
        let url = URL(string: baseUrl + searchTerm)

        guard
            let url = url, let components = URLComponents(
            url: url
                .appendingPathComponent(limitFilter)
                .appendingPathComponent(countryFilter),
            resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't create URLComponents") }

        let request = URLRequest(url: components.url!)
        return apiClient.run(request)
            .map(\.value)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
