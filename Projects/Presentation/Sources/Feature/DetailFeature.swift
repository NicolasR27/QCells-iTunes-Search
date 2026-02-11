import ComposableArchitecture
import Domain
import Foundation
import Sharing

@Reducer
public struct DetailFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public let category: MediaCategory
        public let searchTerm: String
        public var items: [SearchItem] = []
        @Shared(.inMemory("favorites")) public var favoriteIDs: Set<Int> = []
        public var isLoading: Bool = false

        public init(category: MediaCategory, searchTerm: String) {
            self.category = category
            self.searchTerm = searchTerm
        }
    }

    public enum Action: Sendable {
        case onAppear
        case searchResponse(Result<[SearchItem], Error>)
        case toggleFavorite(Int)
    }

    @Dependency(\.iTunesSearchClient) var searchClient

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading, state.items.isEmpty else { return .none }
                state.isLoading = true
                let term = state.searchTerm
                let category = state.category
                return .run { send in
                    let result = try await searchClient.search(term, category, nil)
                    await send(.searchResponse(.success(result)))
                } catch: { error, send in
                    await send(.searchResponse(.failure(error)))
                }

            case .searchResponse(.success(let items)):
                state.items = items
                state.isLoading = false
                return .none

            case .searchResponse(.failure):
                state.isLoading = false
                return .none

            case .toggleFavorite(let id):
                if state.favoriteIDs.contains(id) {
                    state.$favoriteIDs.withLock { $0.remove(id) }
                } else {
                    state.$favoriteIDs.withLock { $0.insert(id) }
                }
                return .none
            }
        }
    }
}
