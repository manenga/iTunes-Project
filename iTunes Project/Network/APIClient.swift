//
//  APIClient.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import Combine
import Foundation

struct APIClient {

    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                do {
                    let payload = try JSONDecoder().decode(T.self, from: result.data)
                    return Response(value: payload, response: result.response)
                } catch {
                    debugPrint(error)
                    throw URLError(.badServerResponse)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
