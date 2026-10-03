import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(api: APIClientProtocol) {
        _viewModel = State(initialValue: SearchViewModel(api: api))
    }

    var body: some View {
        List(viewModel.results) { result in
            if viewModel.resultsType == .movie {
                NavigationLink(value: MovieRoute(id: result.id)) {
                    SearchResultRow(result: result)
                }
            } else {
                SearchResultRow(result: result)
            }
        }
        .listStyle(.plain)
        .searchable(
            text: $viewModel.query,
            placement: .navigationBarDrawer(displayMode: .always), prompt: "Search"
        )
        .safeAreaInset(edge: .top) {
            Picker("Type", selection: $viewModel.mediaType) {
                Text("Movies").tag(MediaType.movie)
                Text("Series").tag(MediaType.tv)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(.bar)
        }
        .overlay { emptyState }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
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

private struct SearchResultRow: View {
    let result: SearchResult

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TMDBImageView(path: result.posterPath, kind: .poster)
                .frame(width: 60, height: 90)
                .clipShape(.rect(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(result.displayTitle)
                    .font(.headline)
                    .lineLimit(2)
                if let year = result.year {
                    Text(year)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !result.overview.isEmpty {
                    Text(result.overview)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
