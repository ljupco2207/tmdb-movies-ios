import Kingfisher
import SwiftUI

struct TMDBImageView: View {
    let path: String?
    let kind: TMDBImage.Kind

    @Environment(\.displayScale) private var displayScale

    var body: some View {
        GeometryReader { proxy in
            let url = TMDBImage.url(path: path, kind: kind, pixelWidth: proxy.size.width * displayScale)
            let previewURL = TMDBImage.previewURL(path: path, kind: kind)

            KFImage(url)
                .placeholder { preview(previewURL == url ? nil : previewURL) }
                .fade(duration: 0.25)
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
        }
    }

    @ViewBuilder
    private func preview(_ url: URL?) -> some View {
        if let url {
            KFImage(url)
                .placeholder { placeholder }
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFill()
                .blur(radius: 8, opaque: true)
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color(.placeholderFill))
            .overlay {
                Image(systemName: "film")
                    .font(.title)
                    .foregroundStyle(.tertiary)
            }
    }
}
