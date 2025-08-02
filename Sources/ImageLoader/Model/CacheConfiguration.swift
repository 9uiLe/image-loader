import Foundation

public struct CacheConfiguration: Sendable {
    public let memoryCountLimit: Int
    public let memoryCostLimit: Int
    public let diskSizeLimit: Int
    public let diskCachePath: String

    public init(
        memoryCountLimit: Int,
        memoryCostLimit: Int,
        diskSizeLimit: Int,
        diskCachePath: String
    ) {
        self.memoryCountLimit = memoryCountLimit
        self.memoryCostLimit = memoryCostLimit
        self.diskSizeLimit = diskSizeLimit
        self.diskCachePath = diskCachePath
    }
}

extension CacheConfiguration {
    public static let `default` = CacheConfiguration(
        memoryCountLimit: 100,
        memoryCostLimit: 100 * 1024 * 1024, // 100MB
        diskSizeLimit: 500 * 1024 * 1024,   // 500MB
        diskCachePath: "ImageCache"
    )
}
