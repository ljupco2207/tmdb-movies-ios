import Network
import Observation

@Observable
final class NetworkMonitor {
    private(set) var isConnected = true

    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            Task { @MainActor in self?.isConnected = isConnected }
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
}
