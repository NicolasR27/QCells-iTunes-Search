import Foundation

public struct SearchItem: Equatable, Identifiable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let artistName: String
    public let artworkUrl: URL?

    public init(id: Int, name: String, artistName: String, artworkUrl: URL?) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.artworkUrl = artworkUrl
    }
}
