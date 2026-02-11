import Foundation

public enum MediaCategory: String, CaseIterable, Sendable, Equatable {
    case song
    case podcast
    case tvShow

    public var displayName: String {
        switch self {
        case .song: "Songs"
        case .podcast: "Podcasts"
        case .tvShow: "TV Shows"
        }
    }

    public var media: String {
        switch self {
        case .song: "music"
        case .podcast: "podcast"
        case .tvShow: "tvShow"
        }
    }

    public var entity: String {
        switch self {
        case .song: "song"
        case .podcast: "podcast"
        case .tvShow: "tvEpisode"
        }
    }
}
