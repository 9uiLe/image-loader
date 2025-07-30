import Foundation
import UIKit

/// @mockable
public protocol ImageCacheServiceProtocol: Actor {
    func image(for url: URL, targetSize: CGSize?) async -> UIImage?
    func store(_ image: UIImage, for url: URL, targetSize: CGSize?) async
    func removeImage(for url: URL, targetSize: CGSize?) async
    func clearCache() async
}

/// @mockable
public protocol ImageLoadingServiceProtocol: Actor {
    func loadImage(from url: URL, targetSize: CGSize?) async throws -> UIImage
}

/// @mockable
public protocol ImagePrefetchServiceProtocol: Actor {
    func prefetch(urls: [URL]) async
    func cancelAll()
}
