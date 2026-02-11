import Foundation
import Domain

extension ITunesSearchClient {
    public static let live = ITunesSearchClient(
        search: { term, category, limit in
            var components = URLComponents(string: "https://itunes.apple.com/search")!
            var queryItems = [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "media", value: category.media),
                URLQueryItem(name: "entity", value: category.entity),
            ]
            if let limit {
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
            }
            components.queryItems = queryItems

            let (data, _) = try await URLSession.shared.data(from: components.url!)
            let response = try JSONDecoder().decode(ITunesSearchResponse.self, from: data)
            return response.results.compactMap { $0.toSearchItem() }
        }
    )
}
