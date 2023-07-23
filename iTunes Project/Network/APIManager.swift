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
    static let baseUrl = URL(string: "https://itunes.apple.com/search")!
}

extension APIManager {
    static func request(term: String) -> AnyPublisher<Response, Error> {
        return makeRequest(searchTerm: term)
    }

    private static func makeRequest<T: Decodable>(searchTerm: String) -> AnyPublisher<T, Error> {
        guard let components = URLComponents(
            url: baseUrl.appendingPathComponent("?term=\(searchTerm)").appendingPathComponent("&country=DK"),
            resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't create URLComponents") }

        let request = URLRequest(url: components.url!)
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
