import Foundation
import UIKit

/// @mockable
public protocol MemoryCacheProtocol: Actor {
    func store(_ image: UIImage, for key: String, cost: Int)
    func retrieve(for key: String) -> UIImage?
    func remove(for key: String)
    func removeAll()
}

/// @mockable
public protocol DiskCacheProtocol: Actor {
    func store(_ data: Data, for key: String) async throws
    func retrieve(for key: String) async throws -> Data?
    func remove(for key: String) async throws
    func removeAll() async throws
}

/// @mockable
public protocol ImageStorageProtocol: Actor {
    func store(_ image: UIImage, for key: String) async throws
    func retrieve(for key: String) async -> UIImage?
    func remove(for key: String) async throws
    func removeAll() async throws
}
