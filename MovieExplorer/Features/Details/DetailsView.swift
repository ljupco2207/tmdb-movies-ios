import SwiftUI

struct DetailsView: View {
    @State private var viewModel: DetailsViewModel

    init(route: MediaRoute, api: APIClientProtocol) {
        _viewModel = State(initialValue: DetailsViewModel(id: route.id, type: route.type, api: api))
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .failed:
            ErrorStateView(message: "Couldn't load details.") {
                Task { await viewModel.load() }
            }
        case .loaded(let details):
            DetailsContent(details: details)
                .navigationTitle(details.displayTitle)
        }
    }
}

private struct DetailsContent: View {
    let details: MediaDetails

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TMDBImageView(path: details.backdropPath, kind: .backdrop)
                    .aspectRatio(16 / 9, contentMode: .fit)

                VStack(alignment: .leading, spacing: 20) {
                    header
                    InfoSection(title: "Overview", text: details.overview)
                    InfoSection(title: "Created by", text: details.creators.joined(separator: ", "))
                    InfoSection(title: "Directed by", text: details.directors.joined(separator: ", "))
                    InfoSection(title: "Written by", text: details.writers.joined(separator: ", "))
                    cast
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(details.displayTitle)
                .font(.title.bold())

            if let tagline = details.tagline, !tagline.isEmpty {
                Text(tagline)
                    .italic()
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text(details.voteAverage, format: .number.precision(.fractionLength(1)))
                    .bold()
                Text("(\(details.voteCount.formatted()) \(details.voteCount == 1 ? "vote" : "votes"))")
                    .foregroundStyle(.secondary)
            }

            let facts = [details.year, details.runtimeText, details.seasonsText, details.episodesText, details.status].compactMap { $0 }
            if !facts.isEmpty {
                Text(facts.joined(separator: " · "))
                    .foregroundStyle(.secondary)
            }

            if !details.genres.isEmpty {
                Text(details.genres.map(\.name).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var cast: some View {
        let members = details.credits.cast.prefix(10)
        if !members.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Cast")
                    .font(.headline)
                ForEach(members) { member in
                    HStack(alignment: .firstTextBaseline) {
                        Text(member.name)
                        Spacer()
                        if let character = member.character, !character.isEmpty {
                            Text(character)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .font(.subheadline)
                }
            }
        }
    }
}

private struct InfoSection: View {
    let title: String
    let text: String

    var body: some View {
        if !text.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
