import ImageLoader
import SwiftUI

@MainActor
@Observable
final class ContentViewModel {
    var imageData: [DownloadImageData] = []

    init(imageCount: Int = 1000) {
        guard let configuration = try? ImageCacheDependencies(
            configuration: .default
        ) else { return }

        imageData = (0 ..< imageCount).map { _ in
            let url = ImageURLFactory.placeholderURL(text: UUID().uuidString)
            return DownloadImageData(
                url: url,
                imageLoader: CachedImageLoader(loadingService: configuration.loadingService)
            )
        }
    }
}

struct DownloadImageData: Identifiable {
    let id = UUID()
    var url: URL
    var imageLoader: CachedImageLoader
}

extension DownloadImageData: Equatable {
    static func == (lhs: DownloadImageData, rhs: DownloadImageData) -> Bool {
        lhs.id == rhs.id
    }
}

enum ImageURLFactory {
    /// URL にテキストを埋めて、キャッシュが利用出来ないようにしておく
    static func placeholderURL(text: String) -> URL {
        URL(string:"https://placehold.jp/000000/ffffff/50x50.png?text=\(text)")!
    }
}
