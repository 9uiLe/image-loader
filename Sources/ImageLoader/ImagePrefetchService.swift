import Foundation
import Interface

public actor ImagePrefetchService: ImagePrefetchServiceProtocol {
    private let loadingService: any ImageLoadingServiceProtocol
    private var prefetchTasks: [URL: Task<Void, Never>] = [:]
    
    public init(loadingService: any ImageLoadingServiceProtocol) {
        self.loadingService = loadingService
    }
    
    public func prefetch(urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                guard prefetchTasks[url] == nil else { continue }

                let task = Task {
                    _ = try? await loadingService.loadImage(from: url, targetSize: nil)
                    prefetchTasks.removeValue(forKey: url)
                }
                
                prefetchTasks[url] = task
                group.addTask { await task.value }
            }
        }
    }
    
    public func cancelAll() {
        for (_, task) in prefetchTasks {
            task.cancel()
        }
        prefetchTasks.removeAll()
    }
}
