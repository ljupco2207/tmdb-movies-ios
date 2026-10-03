import Kingfisher
import SwiftUI

struct TMDBImageView: View {
    let path: String?
    let kind: TMDBImage.Kind

    @Environment(\.displayScale) private var displayScale

    var body: some View {
        GeometryReader { proxy in
            KFImage(TMDBImage.url(path: path, kind: kind, pixelWidth: proxy.size.width * displayScale))
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
