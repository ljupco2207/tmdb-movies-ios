import SwiftUI
import UIKit

/// UICollectionView with a custom compositional layout and SwiftUI cells via UIHostingConfiguration.
struct MovieCollectionView<Footer: View>: UIViewRepresentable {
    let movies: [Movie]
    let onReachEnd: () -> Void
    let onSelect: (Movie) -> Void
    @ViewBuilder let footer: () -> Footer

    /// Start loading the next page when this many items are left to display.
    private static var loadMoreThreshold: Int { 5 }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = context.coordinator
        context.coordinator.configureDataSource(for: collectionView)
        return collectionView
    }

    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.apply(movies)
    }

    /// Column count follows from the width: 1 on iPhone portrait, 2-4 in landscape and on iPad.
    private static var minimumCardWidth: CGFloat { 320 }
    private static var spacing: CGFloat { 16 }

    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let availableWidth = environment.container.effectiveContentSize.width - 2 * spacing
            let columns = max(1, Int((availableWidth + spacing) / (minimumCardWidth + spacing)))
            let cardWidth = (availableWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)
            return makeSection(cardWidth: cardWidth)
        }
    }

    private static func makeSection(cardWidth: CGFloat) -> NSCollectionLayoutSection {
        let estimatedHeight = cardWidth * 9 / 16 + 130
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(cardWidth), heightDimension: .estimated(estimatedHeight))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: spacing, bottom: spacing, trailing: spacing)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        ]
        return section
    }

    final class Coordinator: NSObject, UICollectionViewDelegate {
        var parent: MovieCollectionView
        private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?

        init(parent: MovieCollectionView) {
            self.parent = parent
        }

        func configureDataSource(for collectionView: UICollectionView) {
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Movie> { cell, _, movie in
                cell.contentConfiguration = UIHostingConfiguration { MovieCardView(movie: movie) }
                    .margins(.all, 0)
            }
            // The footer reads observable state itself, so it updates without being reconfigured.
            let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
                elementKind: UICollectionView.elementKindSectionFooter
            ) { [weak self] footer, _, _ in
                guard let self else { return }
                footer.contentConfiguration = UIHostingConfiguration {
                    self.parent.footer()
                }
            }

            let dataSource = UICollectionViewDiffableDataSource<Int, Movie>(
                collectionView: collectionView
            ) { collectionView, indexPath, movie in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
            }
            dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
                collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            }
            self.dataSource = dataSource
        }

        func apply(_ movies: [Movie]) {
            guard let dataSource, dataSource.snapshot().itemIdentifiers != movies else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
            snapshot.appendSections([0])
            snapshot.appendItems(movies)
            dataSource.apply(snapshot, animatingDifferences: false)
        }

        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item >= parent.movies.count - MovieCollectionView.loadMoreThreshold {
                parent.onReachEnd()
            }
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            guard let movie = dataSource?.itemIdentifier(for: indexPath) else { return }
            parent.onSelect(movie)
        }
    }
}
