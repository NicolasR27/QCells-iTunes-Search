import ComposableArchitecture
import Domain
import SwiftUI

struct DetailView: View {
    let store: StoreOf<DetailFeature>

    var body: some View {
        Group {
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if store.items.isEmpty {
                ContentUnavailableView(
                    "No results found",
                    systemImage: "magnifyingglass"
                )
            } else {
                List(store.items) { item in
                    SearchItemRow(
                        item: item,
                        isFavorite: store.favoriteIDs.contains(item.id),
                        onToggleFavorite: {
                            store.send(.toggleFavorite(item.id))
                        }
                    )
                }
            }
        }
        .navigationTitle(store.category.displayName)
        .onAppear {
            store.send(.onAppear)
        }
    }
}
