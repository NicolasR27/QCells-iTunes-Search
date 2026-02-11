import ComposableArchitecture
import Domain
import Foundation
import Sharing

@Reducer
public struct MainFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var searchText: String = ""
        public var songs: [SearchItem] = []
        public var podcasts: [SearchItem] = []
        public var tvShows: [SearchItem] = []
        @Shared(.inMemory("favorites")) public var favoriteIDs: Set<Int> = []
        public var isLoading: Bool = false
        public var hasSearched: Bool = false
        public var path = StackState<DetailFeature.State>()

        public init() {}
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case searchButtonTapped
        case searchResponse(Result<SearchResults, Error>)
        case toggleFavorite(Int)
        case categoryHeaderTapped(MediaCategory)
        case path(StackActionOf<DetailFeature>)
    }

    public struct SearchResults: Equatable, Sendable {
        public let songs: [SearchItem]
        public let podcasts: [SearchItem]
        public let tvShows: [SearchItem]
    }

    @Dependency(\.iTunesSearchClient) var searchClient

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .searchButtonTapped:
                let term = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !term.isEmpty else { return .none }
                state.isLoading = true
                state.hasSearched = true
                return .run { send in
                    let results = try await withThrowingTaskGroup(
                        of: (MediaCategory, [SearchItem]).self
                    ) { group in
                        for category in MediaCategory.allCases {
                            group.addTask {
                                let items = try await searchClient.search(term, category, 5)
                                return (category, items)
                            }
                        }

                        var songs: [SearchItem] = []
                        var podcasts: [SearchItem] = []
                        var tvShows: [SearchItem] = []

                        for try await (category, items) in group {
                            switch category {
                            case .song: songs = items
                            case .podcast: podcasts = items
                            case .tvShow: tvShows = items
                            }
                        }

                        return SearchResults(songs: songs, podcasts: podcasts, tvShows: tvShows)
                    }
                    await send(.searchResponse(.success(results)))
                } catch: { error, send in
                    await send(.searchResponse(.failure(error)))
                }

            case .searchResponse(.success(let results)):
                state.songs = results.songs
                state.podcasts = results.podcasts
                state.tvShows = results.tvShows
                state.isLoading = false
                return .none

            case .searchResponse(.failure):
                state.songs = []
                state.podcasts = []
                state.tvShows = []
                state.isLoading = false
                return .none

            case .toggleFavorite(let id):
                if state.favoriteIDs.contains(id) {
                    state.$favoriteIDs.withLock { $0.remove(id) }
                } else {
                    state.$favoriteIDs.withLock { $0.insert(id) }
                }
                return .none

            case .categoryHeaderTapped(let category):
                state.path.append(
                    DetailFeature.State(
                        category: category,
                        searchTerm: state.searchText
                    )
                )
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            DetailFeature()
        }
    }
}
