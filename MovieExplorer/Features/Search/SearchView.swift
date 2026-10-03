import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    private let favorites: FavoritesStore

    init(api: APIClientProtocol, favorites: FavoritesStore) {
        _viewModel = State(initialValue: SearchViewModel(api: api))
        self.favorites = favorites
    }

    var body: some View {
        List(viewModel.results) { result in
            NavigationLink(value: MediaRoute(id: result.id, type: viewModel.resultsType)) {
                MediaRow(
                    title: result.displayTitle,
                    year: result.year,
                    overview: result.overview,
                    posterPath: result.posterPath,
                    isFavorite: favorites.isFavorite(id: result.id, type: viewModel.resultsType)
                )
            }
        }
        .listStyle(.plain)
        .searchable(
            text: $viewModel.query,
            placement: .alwaysVisible, prompt: "Search"
        )
        .safeAreaInset(edge: .top) {
            Picker("Type", selection: $viewModel.mediaType) {
                Text("Movies").tag(MediaType.movie)
                Text("Series").tag(MediaType.tv)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom, 8)
            .barBackground()
        }
        .overlay { emptyState }
        .navigationTitle("Search")
        .inlineNavigationTitle()
    }

    @ViewBuilder
    private var emptyState: some View {
        if viewModel.results.isEmpty {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorStateView(message: errorMessage)
            } else if viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty {
                ContentUnavailableView("Search movies or series", systemImage: "magnifyingglass")
            } else {
                ContentUnavailableView.search(text: viewModel.query)
            }
        }
    }
}
