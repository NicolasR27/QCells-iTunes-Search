import ComposableArchitecture
import Domain
import SwiftUI

public struct MainView: View {
    @Bindable var store: StoreOf<MainFeature>

    public init(store: StoreOf<MainFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            content
                .navigationTitle("Main")
                .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
                .onSubmit(of: .search) {
                    store.send(.searchButtonTapped)
                }
        } destination: { store in
            DetailView(store: store)
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if store.hasSearched && store.songs.isEmpty && store.podcasts.isEmpty && store.tvShows.isEmpty {
            ContentUnavailableView(
                "No results found",
                systemImage: "magnifyingglass"
            )
        } else if store.hasSearched {
            List {
                categorySection(category: .song, items: store.songs)
                categorySection(category: .podcast, items: store.podcasts)
                categorySection(category: .tvShow, items: store.tvShows)
            }
        } else {
            ContentUnavailableView(
                "Search iTunes",
                systemImage: "magnifyingglass",
                description: Text("Search for songs, podcasts, and TV shows")
            )
        }
    }

    @ViewBuilder
    private func categorySection(category: MediaCategory, items: [SearchItem]) -> some View {
        if !items.isEmpty {
            Section {
                ForEach(items) { item in
                    SearchItemRow(
                        item: item,
                        isFavorite: store.favoriteIDs.contains(item.id),
                        onToggleFavorite: {
                            store.send(.toggleFavorite(item.id))
                        }
                    )
                }
            } header: {
                Button {
                    store.send(.categoryHeaderTapped(category))
                } label: {
                    HStack {
                        Text(category.displayName)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}
