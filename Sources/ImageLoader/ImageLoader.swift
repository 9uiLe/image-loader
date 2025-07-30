import SwiftUI
import Interface

@MainActor
@Observable
public final class ImageLoader {
    public private(set) var image: UIImage?
    public private(set) var isLoading = false
    public private(set) var error: Error?

    @ObservationIgnored private var currentURL: URL?
    @ObservationIgnored private var loadTask: Task<Void, Never>?
    @ObservationIgnored private let loadingService: any ImageLoadingServiceProtocol
    @ObservationIgnored private let targetSize: CGSize?

    public init(
        loadingService: any ImageLoadingServiceProtocol,
        targetSize: CGSize? = nil
    ) {
        self.loadingService = loadingService
        self.targetSize = targetSize
    }
    
    public func load(from url: URL) {
        guard currentURL != url else { return }
        
        cancel()
        currentURL = url
        error = nil
        
        loadTask = Task { @MainActor [weak self] in
            self?.isLoading = true
            defer { self?.isLoading = false }

            do {
                let image = try await self?.loadingService.loadImage(
                    from: url,
                    targetSize: self?.targetSize
                )

                guard !Task.isCancelled else { return }
                self?.image = image

            } catch {
                guard !Task.isCancelled else { return }
                self?.error = error
            }
        }
    }
    
    public func cancel() {
        loadTask?.cancel()
        loadTask = nil
        isLoading = false
    }
}
