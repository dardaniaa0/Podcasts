//
//  DisplayPodcastResultView.swift
//  Podcasts
//
//  Created by Yu Tawata on 2020/08/20.
//

import SwiftUI
import FetchImage

struct DisplayPodcastResultView: View {
    let result: FetchPodcastResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    result.imageUrl.flatMap { ImageView.init(image: .init(url: $0)) }
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)

                    VStack(alignment: .leading) {
                        result.title.flatMap(Text.init)
                            .lineLimit(2)
                            .font(.title2)
                            .foregroundColor(Color(.label))

                        result.author.flatMap(Text.init)
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))

                        Text("\(result.episodes.count) episodes")
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                    }

                    Spacer()
                }

                result.summary.flatMap(Text.init)
                    .lineLimit(.none)
                    .font(.footnote)
            }
            .padding([.leading, .trailing])

            Divider()
                .padding([.leading, .trailing])

            VStack(alignment: .leading) {
                HStack {
                    Text("Episodes")
                        .font(.title)

                    Spacer()
                }

                Spacer().frame(height: 12)

                ForEach(Array(result.episodes.enumerated()), id: \.offset) { offset, episode in
                    VStack(alignment: .leading) {
                        episode.title.flatMap(Text.init)
                            .lineLimit(.none)
                            .font(.headline)
                            .foregroundColor(Color(.label))

                        episode.desc.flatMap(Text.init)
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    .padding([.top, .bottom], 4)
                }
            }
            .padding([.leading, .trailing])
        }
        .background(Color(.systemBackground))
    }
}

struct DisplayPodcastResultView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            Group {
                DisplayPodcastResultView(
                    result: .init(
                        title: "Swift by Sundell",
                        desc: "In-depth conversations about Swift and software development in general, hosted by John Sundell.",
                        link: URL(string: "https://www.swiftbysundell.com/podcast/feed.rss")!,
                        author: "John Sundell",
                        imageUrl: URL(string: "https://www.swiftbysundell.com/images/podcastArtwork.png")!,
                        summary: "In-depth conversations about Swift and software development in general, hosted by John Sundell.",
                        episodes: [
                            .init(
                                title: "79: “All about UICollectionView”, with special guest Ben Scheirman",
                                desc: "Ben Scheirman, creator of NSScreencast, joins John on an episode all about UICollectionView. How have UICollectionView’s features evolved over time, and how are modern APIs like compositional layouts and diffable data sources changing the way collection views are built and used?",
                                pubDate: Date(),
                                link: URL(string: "https://www.swiftbysundell.com/podcast/79")!,
                                subtitle: "Ben Scheirman, creator of NSScreencast, joins John on an episode all about UICollectionView. How have UICollectionView’s features evolved over time, and how are modern APIs like compositional layouts and diffable data sources changing the way collection views are built and used?",
                                duration: 4107,
                                enclosure: URL(string: "https://traffic.libsyn.com/swiftbysundell/SwiftBySundell79.mp3")!
                            ),
                        ]
                    )
                )
                .environment(\.colorScheme, colorScheme)
            }
        }
    }
}