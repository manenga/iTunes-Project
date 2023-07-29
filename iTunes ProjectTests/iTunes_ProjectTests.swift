//
//  iTunes_ProjectTests.swift
//  iTunes ProjectTests
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import XCTest
import Combine
@testable import iTunes_Project

final class iTunes_ProjectTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeViewModel()

    override func setUp() {
        // This is the setUp() class method.
        // XCTest calls it before calling the first test method.
        // Set up any overall initial state here.
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialResultsArrayIsEmpty() {
        XCTAssertTrue(viewModel.results.isEmpty,
                      "Expected initial value to be empty, but got \(viewModel.results.count) results.")
    }

    func testArrayResultsIsLimitedTo50() {
        let expectation = XCTestExpectation(description: "Returns 50 results")

        viewModel.$results
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0.count, 50,
                               "Expected results to be 50, but got \($0.count) results.")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.searchTerm("Abba")
        wait(for: [expectation], timeout: 2)
    }

    func testSearchForSpecificSong() {
        let expectation = XCTestExpectation(description: "We search for a specific song and get the correct results")

        viewModel.$results
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertGreaterThan($0.count, 0)
                XCTAssertEqual($0.first?.artistName ?? "", "Ed Sheeran",
                               "Expected artist name be Ed Sheeran, but got \($0.first?.artistName ?? "").")
                XCTAssertEqual($0.first?.artistName ?? "", "Ed Sheeran",
                               "Expected track name be Shape Of You, but got \($0.first?.trackName ?? "").")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.searchTerm("Shape+Of+You+Ed+Sheeran")
        wait(for: [expectation], timeout: 2)
    }

    func testBaseUrlIsCorrect() {
        XCTAssertEqual(APIManager.baseUrl, "https://itunes.apple.com/search?term=",
                       "Expected base url to be https://itunes.apple.com/search?term=, but got \(APIManager.baseUrl).")
    }

    func testCountryFilterIsCorrect() {
        XCTAssertEqual(APIManager.countryFilter, "&country=DK",
                       "Expected country filter to be &country=DK, but got \(APIManager.countryFilter).")
    }

    func testLimitFilterIsCorrect() {
        XCTAssertEqual(APIManager.limitFilter, "&limit=50",
                       "Expected limit filter to be &limit=50, but got \(APIManager.limitFilter).")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
