import Foundation
import UIKit

/// @mockable
public protocol ImageStorageProtocol: Actor {
    func store(_ image: UIImage, for key: String) async throws
    func retrieve(for key: String) async -> UIImage?
    func remove(for key: String) async throws
    func removeAll() async throws
}
