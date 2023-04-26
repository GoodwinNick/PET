
import Foundation
import UIKit

public final class CacheManager {
    
    public static let shared = CacheManager()
    
    private let fileManager = FileManager.default
    
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
}


// MARK: Main functions
public extension CacheManager {
    
    /// Check is filename is available
    func isFileNameIsAvailable(_ name: String, fileType type: SectionPath) async throws -> Bool {
        async let isContains = getFileNamesForSection(type).contains(where: { $0 == name })
        if try await isContains {
            return false
        } else {
            return true
        }
    }
    
    /// Get files list in specified folder
    func getFilesList(for type: SectionPath) async throws -> [URL] {
        return try await getURLs(self.mainDirectoryUrl.appendingPathComponent(type.pathValue))
    }
    
    /// Rename file
    func renameFile(_ type: SectionPath, origin originName: String, new newName: String) async throws {
        await printURLs(isBeforeValues: true, url: self.mainDirectoryUrl.appendingPathComponent(type.pathValue), getURLs)
        
        let originFileURL = try await directoryFor(originName, type)
        let newFileURL = try await directoryFor(newName, type)
        try fileManager.moveItem(at: originFileURL, to: newFileURL)
        
        await printURLs(isBeforeValues: false, url: self.mainDirectoryUrl.appendingPathComponent(type.pathValue), getURLs)
        
    }
    
    
    /// Get URL with specified filename and folder
    func getFileURLWith(_ type: SectionPath, url: String) async throws -> URL  {
        do {
            let file = try await directoryFor(url, type)
            printValues(file)
            return file
        } catch {
            printValues(error.localizedDescription)
            throw error
        }
        
    }
    
    /// Get date of creating file
    func getCreationDate(for url: URL) -> Date {
        guard let attributes = try? fileManager.attributesOfItem(atPath: url.path),
              let creationDate = attributes[.creationDate] as? Date else {
            return Date()
        }
        return creationDate
    }
    
    /// Remove file by specified URL
    func removeFile(with url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    /// Save data to file with specified filename and folder
    func saveFile(data: Data?, fileName: String, type: SectionPath) async throws  {
        guard let data else {
            throw CacheError.dataIsNil
        }
        let file = try await directoryFor(fileName + type.fileExtension, type)
        
        try data.write(to: file, options: .atomic)
    }
    
}




// MARK: Functions for clearing caches
public extension CacheManager {
    
    /// Clear all cache
    func clearCache() async throws {
        let urls = try await getURLs(mainDirectoryUrl)
        for url in urls {
            try fileManager.removeItem(at: url)
        }
        let newUrls = try await getURLs(mainDirectoryUrl)
        if urls == newUrls {
            throw CacheError.clearCache
        }
    }
    
    /// Clear content of specified folder
    func clearFolder(of section: SectionPath) async throws {
        let urls = try await getURLs(mainDirectoryUrl.appendingPathComponent(section.pathValue))
        for url in urls {
            try fileManager.removeItem(at: url)
        }
        let newUrls = try await getURLs(mainDirectoryUrl.appendingPathComponent(section.pathValue))
        if urls == newUrls {
            throw CacheError.clearContents
        }
    }
    
}




// MARK: Manager helpers
private extension CacheManager {
    
    /// Encode string with precent signs instead of non-urlAllowed symbols
    func encodeString(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? string
    }
    
    /// For get contents of folder
    func getURLs(_ url: URL) async throws -> [URL] {
        let contents = try fileManager.contentsOfDirectory(atPath: url.path)
        let urls = contents.map { URL(string:"\(url.appendingPathComponent("\($0)"))")! }
        return urls
    }
    
    
    /// For get content of folder by SectionPath
    func getFileNamesForSection(_ section: SectionPath) async throws -> [String] {
        if !directoryExistsAtPath(self.mainDirectoryUrl.appendingPathComponent(section.pathValue).path) {
            try fileManager.createDirectory(at: self.mainDirectoryUrl.appendingPathComponent(section.pathValue), withIntermediateDirectories: true)
        }
        let url = self.mainDirectoryUrl.appendingPathComponent(section.pathValue)
        let fileNames = try await getURLs(url).map { $0.lastPathComponent.replacingOccurrences(of: section.fileExtension, with: "") }
        
        return fileNames
    }
    
    
    /// Get url of directory for specified file and SectionPath. Will create dirrectory is it not exist.
    func directoryFor(_ stringUrl: String, _ type: SectionPath) async throws -> URL {
        do {
            let stringUrl = encodeString(stringUrl)
            if !directoryExistsAtPath(self.mainDirectoryUrl.appendingPathComponent(type.pathValue).absoluteString) {
                try fileManager.createDirectory(at: self.mainDirectoryUrl.appendingPathComponent(type.pathValue), withIntermediateDirectories: true)
            }
            guard let fileURL = URL(string: stringUrl)?.lastPathComponent else {
                throw CacheError.badUrl
            }
            let file = self.mainDirectoryUrl.appendingPathComponent(type.pathValue + fileURL + type.fileExtension)
            return file
        } catch {
            printValues(error.localizedDescription)
            throw error
        }
    }
    
    /// Check if directory exist
    func directoryExistsAtPath(_ path: String) -> Bool {
        let path = encodeString(path)
        let exists = fileManager.fileExists(atPath: path)
        return exists
    }
}



// MARK: Debug helpers
private extension CacheManager {
    
    /// Debug print
    func printValues(_ values: Any...) {
#if DEBUG
        print(values)
#endif
    }
    
    /// Debug print
    func printURLs(isBeforeValues: Bool, url: URL, _ function: (URL) async throws -> [URL]) async {
#if DEBUG
        do {
            if isBeforeValues {
                printValues("before")
            } else {
                printValues("after")
            }
            _ = try await function(url).map { printValues($0.lastPathComponent) }
        } catch {
            printValues(error.localizedDescription)
        }
#endif
    }
    
}
