import Foundation
import StorageInterface
import UIKit

public actor ImageStorage: ImageStorageProtocol {
    private let memoryCache: any MemoryCacheProtocol
    private let diskCache: any DiskCacheProtocol

    public init(
        memoryCache: any MemoryCacheProtocol,
        diskCache: any DiskCacheProtocol
    ) {
        self.memoryCache = memoryCache
        self.diskCache = diskCache
    }

    public func store(_ image: UIImage, for key: String) async throws {
        // メモリキャッシュに保存
        let storeMemoryCache: () async -> Void = { [memoryCache] in
            let cost = image.jpegData(compressionQuality: 1.0)?.count ?? 0
            await memoryCache.store(image, for: key, cost: cost)
        }

        // ディスクキャッシュに保存
        let storeDiskCache: () async throws -> Void = { [diskCache] in
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            try await diskCache.store(data, for: key)
        }

        let (_, _) = try await (
            storeMemoryCache(),
            storeDiskCache()
        )
    }

    public func retrieve(for key: String) async -> UIImage? {
        // メモリキャッシュから取得
        if let image = await memoryCache.retrieve(for: key) {
            return image
        }

        // ディスクキャッシュから取得
        guard
            let data = try? await diskCache.retrieve(for: key),
            let image = UIImage(data: data)
        else { return nil }

        // メモリキャッシュに保存
        let cost = data.count
        await memoryCache.store(image, for: key, cost: cost)
        return image
    }

    public func remove(for key: String) async throws {
        async let removeMemoryCache: Void = memoryCache.remove(for: key)
        async let removeDiskCache: Void = diskCache.remove(for: key)

        let (_, _) = try await (removeMemoryCache, removeDiskCache)
    }

    public func removeAll() async throws {
        async let removeAllMemoryCache: Void = memoryCache.removeAll()
        async let removeAllDiskCache: Void = diskCache.removeAll()

        let (_, _) = try await (removeAllMemoryCache, removeAllDiskCache)
    }
}
