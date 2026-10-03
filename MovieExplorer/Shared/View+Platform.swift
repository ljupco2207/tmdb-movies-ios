import SwiftUI

extension View {
    func inlineNavigationTitle() -> some View {
        #if os(tvOS)
        self
        #else
        navigationBarTitleDisplayMode(.inline)
        #endif
    }

    /// Lets the Siri Remote focus this content, so the surrounding ScrollView scrolls to it.
    func focusableOnTV() -> some View {
        #if os(tvOS)
        focusable()
        #else
        self
        #endif
    }

    func barBackground() -> some View {
        #if os(tvOS)
        self
        #else
        background(.bar)
        #endif
    }
}

extension SearchFieldPlacement {
    static var alwaysVisible: SearchFieldPlacement {
        #if os(tvOS)
        .automatic
        #else
        .navigationBarDrawer(displayMode: .always)
        #endif
    }
}

extension ToolbarItemPlacement {
    static var trailingBar: ToolbarItemPlacement {
        #if os(tvOS)
        .automatic
        #else
        .topBarTrailing
        #endif
    }
}
