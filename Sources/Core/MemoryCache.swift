import Foundation
import Interface
import Model
import UIKit

public actor MemoryCache: MemoryCacheProtocol {
    private let cache = NSCache<NSString, UIImage>()
    private let configuration: CacheConfiguration

    public init(configuration: CacheConfiguration) {
        self.configuration = configuration

        cache.countLimit = configuration.memoryCountLimit
        cache.totalCostLimit = configuration.memoryCostLimit
    }

    public func store(_ image: UIImage, for key: String, cost: Int) {
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }

    public func retrieve(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    public func remove(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }
}
