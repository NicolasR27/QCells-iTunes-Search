import Foundation
import Domain

struct ITunesSearchResponse: Decodable, Sendable {
    let resultCount: Int
    let results: [ITunesResultDTO]
}

struct ITunesResultDTO: Decodable, Sendable {
    let trackId: Int?
    let collectionId: Int?
    let trackName: String?
    let collectionName: String?
    let artistName: String?
    let artworkUrl100: String?

    func toSearchItem() -> SearchItem? {
        guard let id = trackId ?? collectionId else { return nil }
        let name = trackName ?? collectionName ?? "Unknown"
        return SearchItem(
            id: id,
            name: name,
            artistName: artistName ?? "Unknown",
            artworkUrl: artworkUrl100.flatMap(URL.init(string:))
        )
    }
}
