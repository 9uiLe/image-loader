import Foundation
import Interface
import Model

public actor DiskCache: DiskCacheProtocol {
    private let cacheURL: URL
    private let fileManager: FileManager
    private let configuration: CacheConfiguration
    
    public init(
        configuration: CacheConfiguration,
        fileManager: FileManager = .default
    ) throws {
        self.configuration = configuration
        self.fileManager = fileManager
        
        guard let cacheDirectory = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else { throw ImageCacheError.cacheDirectoryNotFound }

        self.cacheURL = cacheDirectory.appendingPathComponent(configuration.diskCachePath)
        try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }
    
    private func fileURL(for key: String) -> URL {
        let fileName = key.addingPercentEncoding(
            withAllowedCharacters: .alphanumerics
        ) ?? key
        return cacheURL.appendingPathComponent(fileName)
    }
    
    public func store(_ data: Data, for key: String) async throws {
        let url = fileURL(for: key)
        try data.write(to: url)
    }
    
    public func retrieve(for key: String) async throws -> Data? {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }
    
    public func remove(for key: String) async throws {
        let url = fileURL(for: key)
        try fileManager.removeItem(at: url)
    }
    
    public func removeAll() async throws {
        try fileManager.removeItem(at: cacheURL)
        try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }
}
