import SwiftUI
import UIKit

/// UICollectionView with a custom compositional layout and SwiftUI cells via UIHostingConfiguration.
struct MovieCollectionView<Footer: View>: UIViewRepresentable {
    let movies: [Movie]
    let onReachEnd: () -> Void
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

    private static func makeLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(320))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        ]
        return UICollectionViewCompositionalLayout(section: section)
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
    }
}
