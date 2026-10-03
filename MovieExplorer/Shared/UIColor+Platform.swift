import UIKit

extension UIColor {
    static var screenBackground: UIColor {
        #if os(tvOS)
        .clear
        #else
        .systemGroupedBackground
        #endif
    }

    static var placeholderFill: UIColor {
        #if os(tvOS)
        .white.withAlphaComponent(0.05)
        #else
        .tertiarySystemFill
        #endif
    }

    static var cardBackground: UIColor {
        #if os(tvOS)
        .white.withAlphaComponent(0.1)
        #else
        .secondarySystemGroupedBackground
        #endif
    }
}
