//
//  DownloadEpisodeWorkflowTests.swift
//  PodcastsTests
//
//  Created by Yu Tawata on 2020/09/12.
//

import Combine
import XCTest
import ComposableArchitecture
import Mocker
import Core
@testable import Podcasts

class DownloadEpisodeWorkflowTests: XCTestCase {
    private var workflow: DownloadEpisodeWorkflow!

    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Downloading() throws {
        // Given
        workflow = DownloadEpisodeWorkflow(
            networking: Networking(
                searchPodcasts: { _ in
                    Fail<SearchPodcastResult, Networking.Failure>(error: Networking.Failure())
                        .eraseToEffect()
                },
                fetchPodcast: { _ in
                    Fail<FetchPodcastResult, Networking.Failure>(error: Networking.Failure())
                        .eraseToEffect()
                },
                downloadEpisode: { url in
                    Just(URL(string: "https://github.com/yuta24/Podcasts")!)
                        .setFailureType(to: Networking.Failure.self)
                        .eraseToEffect()
                }
            )
        )

        let expects = URL(string: "https://github.com/yuta24/Podcasts")!

        let exp = expectation(description: "\(#function):\(#line)")

        // When
        workflow.execute(PlayingEpisode(
                            title: "Title",
                            position: 0,
                            duration: 120,
                            imageUrl: URL(string: "https://google.com")!,
                            enclosure: URL(string: "https://github.com/yuta24/Podcasts")!,
                            fileUrl: URL(string: "https://github.com/yuta24")!))
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { url in
                    // Then
                    XCTAssertEqual(expects, url)
                }
            )
            .store(in: &cancellables)

        wait(for: [exp], timeout: 0.1)
    }
}
