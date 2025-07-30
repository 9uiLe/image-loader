import Foundation

public enum ImageCacheError: Error {
    case invalidURL
    case downloadFailed(Error)
    case decodingFailed
    case cacheFailed(Error)
    case cancelled
    case cacheDirectoryNotFound
}

extension ImageCacheError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case .downloadFailed(let error):
            return "Download failed: \(error.localizedDescription)"

        case .decodingFailed:
            return "Failed to decode image"

        case .cacheFailed(let error):
            return "Cache operation failed: \(error.localizedDescription)"

        case .cancelled:
            return "Operation was cancelled"

        case .cacheDirectoryNotFound:
            return "Cache directory not found"
        }
    }
}
