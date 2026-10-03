import SwiftUI

struct ErrorStateView: View {
    let message: String
    var retry: (() -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label(message, systemImage: "wifi.exclamationmark")
        } actions: {
            if let retry {
                Button("Retry", action: retry)
            }
        }
    }
}
