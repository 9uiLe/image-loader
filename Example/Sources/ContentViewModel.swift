import ImageLoader
import SwiftUI

@MainActor
@Observable
final class ContentViewModel {
    fileprivate(set) var imageData: [DownloadImageData] = []

    func setup() async {
        guard
            let configuration = try? await ImageCacheDependencies(
                configuration: .default
            )
        else { return }

        imageData = (0..<15).map { _ in
            let url = ImageURLFactory.placeholderURL(text: UUID().uuidString)
            return DownloadImageData(
                url: url,
                loadingService: configuration.loadingService
            )
        }
    }
}

struct DownloadImageData: Sendable {
    let id = UUID()
    let url: URL
    let loadingService: any ImageLoadingServiceProtocol
}

enum ImageURLFactory {
    static func placeholderURL(text: String) -> URL {
        URL(string:"https://placehold.jp/000000/ffffff/500x100.png?text=\(text)")!
    }
}
