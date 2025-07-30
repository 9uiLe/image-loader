import Foundation
import UIKit

/// @mockable
public protocol URLSessionProtocol: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

/// @mockable
public protocol ImageDownloaderProtocol: Actor {
    func download(from url: URL) async throws -> UIImage
    func cancelDownload(for url: URL)
}
