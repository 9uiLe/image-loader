import UIKit

/// @mockable
public protocol ImageDownloaderProtocol: Actor {
    func download(from url: URL) async throws -> UIImage
    func cancelDownload(for url: URL)
}
