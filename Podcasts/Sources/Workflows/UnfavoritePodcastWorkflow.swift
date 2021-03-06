//
//  UnfavoritePodcastWorkflow.swift
//  Podcasts
//
//  Created by Yu Tawata on 2020/08/21.
//

import Foundation
import Combine
import Core

struct UnfavoritePodcastWorkflow {
    let dataStore: FavoritedPodcastDataStore

    init(dataStore: FavoritedPodcastDataStore) {
        self.dataStore = dataStore
    }

    func execute(_ podcast: Podcast) -> AnyPublisher<Void, Never> {
        Just(())
        .handleEvents(receiveOutput: { _ in
            dataStore.remove(podcast)
        })
        .eraseToAnyPublisher()
    }
}
