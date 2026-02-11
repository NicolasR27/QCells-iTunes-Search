import Foundation
import Util

public struct ITunesSearchClient: Sendable {
    public var search: @Sendable (_ term: String, _ category: MediaCategory, _ limit: Int?) async throws -> [SearchItem]

    public init(
        search: @escaping @Sendable (_ term: String, _ category: MediaCategory, _ limit: Int?) async throws -> [SearchItem]
    ) {
        self.search = search
    }
}

extension ITunesSearchClient: DependencyKey {
    public static let liveValue = ITunesSearchClient(
        search: { _, _, _ in [] }
    )

    public static let testValue = ITunesSearchClient(
        search: { _, _, _ in [] }
    )
}

public extension DependencyValues {
    var iTunesSearchClient: ITunesSearchClient {
        get { self[ITunesSearchClient.self] }
        set { self[ITunesSearchClient.self] = newValue }
    }
}
