import Foundation

/// @mockable
public protocol ImagePrefetchServiceProtocol: Actor {
    func prefetch(urls: [URL]) async
    func cancelAll()
}
