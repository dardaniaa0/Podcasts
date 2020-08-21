//
//  FavoritePodcastWorkflowTests.swift
//  PodcastsTests
//
//  Created by Yu Tawata on 2020/08/21.
//

import Combine
import XCTest
@testable import Podcasts

class FavoritePodcastWorkflowTests: XCTestCase {
    private var workflow: FavoritePodcastWorkflow!
    private let userDefaults = UserDefaults(suiteName: "\(#file)")!

    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userDefaults.removeObject(forKey: "favorites")
    }

    func test_Favoriting() throws {
        // Given
        workflow = FavoritePodcastWorkflow(userDefaults: userDefaults)

        let expects: [PodcastExt] = [
            .init(
                title: "Title",
                desc: "Description",
                link: URL(string: "https://www.google.com/")!,
                author: "yuta24",
                imageUrl: .none,
                summary: "Summary",
                episodes: [],
                isFavorited: true
            )
        ]

        let exp = expectation(description: "\(#function):\(#line)")

        let podcast: PodcastExt = .init(
            title: "Title",
            desc: "Description",
            link: URL(string: "https://www.google.com/")!,
            author: "yuta24",
            imageUrl: .none,
            summary: "Summary",
            episodes: [],
            isFavorited: false
        )

        // When
        workflow.execute(podcast)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    // Then
                    let array = self.userDefaults.data(forKey: "favorites").flatMap {
                        try? JSONDecoder().decode([PodcastExt].self, from: $0)
                    } ?? []
                    XCTAssertEqual(expects, array)
                }
            )
            .store(in: &cancellables)

        wait(for: [exp], timeout: 0.1)
    }
}
