import UIKit

/// @mockable
public protocol ImageCacheServiceProtocol: Actor {
    func image(for url: URL, targetSize: CGSize?) async -> UIImage?
    func store(_ image: UIImage, for url: URL, targetSize: CGSize?) async
    func removeImage(for url: URL, targetSize: CGSize?) async
    func clearCache() async
}
