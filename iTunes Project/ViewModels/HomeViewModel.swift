//
//  HomeViewModel.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import Combine
import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {

    @Published var results: [SearchResult] = []
    
    private var cancellableToken: AnyCancellable?

    init() { }

    func searchTerm(_ term: String) {
        let formattedTerm = term.replacingOccurrences(of: " ", with: "+")
        cancellableToken = getSearchResults(searchTerm: formattedTerm)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] results in
                self?.results = results
            })
    }
}

extension HomeViewModel {

    private func getSearchResults(searchTerm: String) -> AnyPublisher<[SearchResult], Never> {
      guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&limit=50&country=DK") else {
        return Just([]).eraseToAnyPublisher()
      }

      return URLSession.shared.dataTaskPublisher(for: url)
        .map { data, response in
          do {
            let decoder = JSONDecoder()
            let fullResponse = try decoder.decode(Response.self, from: data)
              return fullResponse.results
          }
          catch {
            return []
          }
        }
        .replaceError(with: [])
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
