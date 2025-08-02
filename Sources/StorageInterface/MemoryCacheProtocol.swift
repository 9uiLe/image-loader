import UIKit

/// @mockable
public protocol MemoryCacheProtocol: Actor {
    func store(_ image: UIImage, for key: String, cost: Int)
    func retrieve(for key: String) -> UIImage?
    func remove(for key: String)
    func removeAll()
}
