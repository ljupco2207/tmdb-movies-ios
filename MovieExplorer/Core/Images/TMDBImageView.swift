import Kingfisher
import SwiftUI

struct TMDBImageView: View {
    let path: String?

    @Environment(\.displayScale) private var displayScale

    var body: some View {
        GeometryReader { proxy in
            KFImage(TMDBImage.backdropURL(path: path, pixelWidth: proxy.size.width * displayScale))
                .placeholder { placeholder }
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color(.tertiarySystemFill))
            .overlay {
                Image(systemName: "film")
                    .font(.title)
                    .foregroundStyle(.tertiary)
            }
    }
}
