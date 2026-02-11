# QCells - iTunes Search App

## Functional Requirements

### Main View
- The Main view must include a search bar for keyword-based content search.
- Pressing the search button on the keyboard should display the first 5 items for three categories (Song, Podcast, TV Show) from the API results, organized in a List UI with Sections.
- If a category has no results, its section header must not be displayed.
- If all categories return no results, display the message "No results found".

### Navigation
- Tapping on a Category Header must push to the All Items full list view (Detail View).
- Tapping the Star Button adds or removes the item from favorites. Favorited items must display a filled star icon.

### Detail View
- This screen is pushed when a header is tapped on the Home screen. The screen Title must be the Category Name.
- The API must be called using the search term from the Home screen, but with the `limit` query parameter removed, displaying all results returned by the API.
- Actions: Star Button behavior must be identical to the main view.

## API Spec

- For detailed information on the iTunes Search API, please refer to: [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/)
- Base URL: `https://itunes.apple.com`
- Endpoint: `GET /search`
- Parameters: `term`, `media`, `entity`, `limit`

| Category | media | entity |
|----------|-------|--------|
| Song | music | song |
| Podcast | podcast | podcast |
| TV Show | tvShow | tvEpisode |

## Notes and Constraints

- The `limit` query parameter must be set to 5 for these categorical searches, as a required constraint. If fewer than 5 results are returned, display the available count.
- **Networking:** Networking logic must be implemented directly. External networking libraries (e.g., Alamofire, Moya) are prohibited.
- **LocalStorage:** In-memory cache.
- **Concurrency:** Must use Swift Concurrency (async/await, TaskGroup). Usage of Completion Handlers or Combine is prohibited.
- **CleanArchitecture:** The project must follow Clean Architecture principles with a clear separation of Presentation, Domain, and Data layers.

## Project Execution Instructions

1. Install Tuist using the mise tool.
2. Execute the command: `mise install tuist@4.54.3`
3. Execute the command: `mise use tuist@4.54.3`
4. Execute the command: `make`

## Architecture

```
App → [Presentation, Data]
Presentation → [Domain, ComposableArchitecture]
Data → [Domain]
Domain → [Util]
Util → [Dependencies]
```

- **App:** SwiftUI entry point, dependency wiring
- **Presentation:** TCA Features + SwiftUI Views + Coordinator
- **Domain:** Entities (SearchItem, MediaCategory) + Client protocol (ITunesSearchClient)
- **Data:** URLSession networking + DTO mapping + Live client implementation
- **Util:** Re-exports swift-dependencies
