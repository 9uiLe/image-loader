import Foundation
import UIKit

/// @mockable
public protocol ImageLoadingServiceProtocol: Actor {
    func loadImage(from url: URL, targetSize: CGSize?) async throws -> UIImage
}
