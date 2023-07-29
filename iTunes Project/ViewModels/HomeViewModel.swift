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

    @Published var results: [SearchItem] = []

    private var cancellableToken: AnyCancellable?

    init() { }

    func searchTerm(_ term: String) {
        guard term.isNotEmpty else {
            results = []
            return
        }

        let formattedTerm = term.replacingOccurrences(of: " ", with: "+")
        cancellableToken = getSearchResults(searchTerm: formattedTerm)
            .sink(receiveValue: { [weak self] results in
                self?.results = results.filter { $0.trackName != nil }
            })
    }
}

extension HomeViewModel {

    private func getSearchResults(searchTerm: String) -> AnyPublisher<[SearchItem], Never> {
        APIManager.request(term: searchTerm)
            .map(\.results)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
