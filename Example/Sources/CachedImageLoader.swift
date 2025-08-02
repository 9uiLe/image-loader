import ImageLoader
import SwiftUI

enum CachedAsyncImagePhase: Sendable {
    case idle
    case loading
    case success(UIImage)
    case failure(Error)
}

enum ImageCachedLoaderError: Error {
    case deallocatedSelf
}

@MainActor
@Observable
final class CachedImageLoader {
    private(set) var phase: CachedAsyncImagePhase = .idle

    @ObservationIgnored private var currentURL: URL?
    @ObservationIgnored private var loadTask: Task<Void, Never>?
    @ObservationIgnored private let loadingService: any ImageLoadingServiceProtocol
    @ObservationIgnored private let targetSize: CGSize?

    init(
        loadingService: any ImageLoadingServiceProtocol,
        targetSize: CGSize? = nil
    ) {
        self.loadingService = loadingService
        self.targetSize = targetSize
    }

    func load(from url: URL) {
        guard currentURL != url else { return }

        cancel()
        currentURL = url

        loadTask = Task { @MainActor [weak self] in
            do {
                guard let self else {
                    throw ImageCachedLoaderError.deallocatedSelf
                }

                phase = .loading
                let image = try await loadingService.loadImage(
                    from: url,
                    targetSize: targetSize
                )

                guard !Task.isCancelled else { return }
                phase = .success(image)

            } catch {
                guard !Task.isCancelled else { return }
                self?.phase = .failure(error)
            }
        }
    }

    func cancel() {
        loadTask?.cancel()
        loadTask = nil
        phase = .idle
    }
}
