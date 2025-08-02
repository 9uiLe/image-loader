import UIKit

/// @mockable
public protocol DiskCacheProtocol: Actor {
    func store(_ data: Data, for key: String) async throws
    func retrieve(for key: String) async throws -> Data?
    func remove(for key: String) async throws
    func removeAll() async throws
}
