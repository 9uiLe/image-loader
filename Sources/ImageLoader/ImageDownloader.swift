import Foundation
import Model
import NetworkInterface
import UIKit

public actor ImageDownloader: ImageDownloaderProtocol {
    private let session: any URLSessionProtocol
    private var activeTasks: [URL: Task<UIImage, Error>] = [:]

    init(session: any URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func download(from url: URL) async throws -> UIImage {
        // 既存のタスクを確認
        if let existingTask = activeTasks[url] {
            return try await existingTask.value
        }

        // 新しいタスクを作成
        let task = Task<UIImage, Error> {
            defer { activeTasks.removeValue(forKey: url) }

            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else {
                throw ImageCacheError.decodingFailed
            }
            return image
        }

        activeTasks[url] = task
        return try await task.value
    }

    public func cancelDownload(for url: URL) {
        activeTasks[url]?.cancel()
        activeTasks.removeValue(forKey: url)
    }
}
