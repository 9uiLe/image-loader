import UIKit

public actor ImageLoadingService: ImageLoadingServiceProtocol {
    private let cache: any ImageCacheServiceProtocol
    private let downloader: any ImageDownloaderProtocol

    public init(
        cache: any ImageCacheServiceProtocol,
        downloader: any ImageDownloaderProtocol
    ) {
        self.cache = cache
        self.downloader = downloader
    }

    public func loadImage(
        from url: URL,
        targetSize: CGSize?
    ) async throws -> UIImage {
        // キャッシュから取得
        if let cachedImage = await cache.image(
            for: url,
            targetSize: targetSize
        ) {
            return cachedImage
        }

        // ダウンロード
        let image = try await downloader.download(from: url)

        // キャッシュに保存
        await cache.store(image, for: url, targetSize: targetSize)

        return image
    }
}
