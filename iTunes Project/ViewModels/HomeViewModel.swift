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
        guard !term.isEmpty else {
            results = []
            return
        }

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
        APIManager.request(term: searchTerm)
            .map(\.results)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
