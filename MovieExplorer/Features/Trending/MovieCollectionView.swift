import SwiftUI
import UIKit

/// UICollectionView with a custom compositional layout and SwiftUI cells via UIHostingConfiguration.
struct MovieCollectionView: UIViewRepresentable {
    let movies: [Movie]

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        collectionView.backgroundColor = .systemGroupedBackground
        context.coordinator.configureDataSource(for: collectionView)
        return collectionView
    }

    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        context.coordinator.apply(movies)
    }

    private static func makeLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(320))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }

    final class Coordinator {
        private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?

        func configureDataSource(for collectionView: UICollectionView) {
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Movie> { cell, _, movie in
                cell.contentConfiguration = UIHostingConfiguration { MovieCardView(movie: movie) }
                    .margins(.all, 0)
            }
            dataSource = UICollectionViewDiffableDataSource<Int, Movie>(
                collectionView: collectionView
            ) { collectionView, indexPath, movie in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
            }
        }

        func apply(_ movies: [Movie]) {
            guard let dataSource, dataSource.snapshot().itemIdentifiers != movies else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
            snapshot.appendSections([0])
            snapshot.appendItems(movies)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}
