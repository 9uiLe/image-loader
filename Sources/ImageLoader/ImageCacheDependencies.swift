import Interface
import Model

public struct ImageCacheDependencies: Sendable {
    let loadingService: any ImageLoadingServiceProtocol
    let prefetchService: any ImagePrefetchServiceProtocol

    public init(configuration: CacheConfiguration) async throws {
        let memoryCache = MemoryCache(configuration: configuration)
        let diskCache = try DiskCache(configuration: configuration)
        let storage = ImageStorage(memoryCache: memoryCache, diskCache: diskCache)
        let cache = ImageCacheService(storage: storage)
        let downloader = ImageDownloader()
        
        self.loadingService = ImageLoadingService(cache: cache, downloader: downloader)
        self.prefetchService = ImagePrefetchService(loadingService: loadingService)
    }

    public init(
        loadingService: any ImageLoadingServiceProtocol,
        prefetchService: any ImagePrefetchServiceProtocol
    ) {
        self.loadingService = loadingService
        self.prefetchService = prefetchService
    }
}
