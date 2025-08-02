import Foundation
import ServiceInterface
import StorageInterface
import UIKit

public actor ImageCacheService: ImageCacheServiceProtocol {
    private let storage: any ImageStorageProtocol

    public init(storage: any ImageStorageProtocol) {
        self.storage = storage
    }

    public func image(for url: URL, targetSize: CGSize?) async -> UIImage? {
        let key = cacheKey(for: url, targetSize: targetSize)
        return await storage.retrieve(for: key)
    }

    public func store(
        _ image: UIImage,
        for url: URL,
        targetSize: CGSize?
    ) async {
        let key = cacheKey(for: url, targetSize: targetSize)

        let processedImage: UIImage = if let targetSize {
            await resizeImage(image, to: targetSize)
        } else {
            image
        }

        try? await storage.store(processedImage, for: key)
    }

    public func removeImage(for url: URL, targetSize: CGSize?) async {
        let key = cacheKey(for: url, targetSize: targetSize)
        try? await storage.remove(for: key)
    }

    public func clearCache() async {
        try? await storage.removeAll()
    }
}

// MARK: - Private Function

extension ImageCacheService {
    private func cacheKey(for url: URL, targetSize: CGSize?) -> String {
        var key = url.absoluteString
        if let size = targetSize {
            key += "_\(Int(size.width))x\(Int(size.height))"
        }
        return key
    }

    private func resizeImage(
        _ image: UIImage,
        to size: CGSize
    ) async -> UIImage {
        await Task.detached(priority: .userInitiated) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = await UIScreen.main.scale
            format.opaque = false

            let renderer = UIGraphicsImageRenderer(size: size, format: format)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: size))
            }
        }.value
    }
}
