//
//  MediaStorageService.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 15/11/2026.
//

import Foundation
import UIKit

protocol MediaStorageServicing: Sendable {
    func saveImage(_ data: Data) throws -> String
    func saveVideo(from sourceURL: URL) async throws -> String
    func saveAudio(from sourceURL: URL) throws -> String
    func makeNewAudioDestination() -> (filename: String, url: URL)
    func loadImage(named filename: String) -> UIImage?
    func fileURL(for filename: String) -> URL
    func deleteFile(named filename: String) throws
}

final class MediaStorageService: MediaStorageServicing {
    func saveImage(_ data: Data) throws -> String {
        let filename = "\(UUID().uuidString).jpg"
        let destinationURL = fileURL(for: filename)
        try data.write(to: destinationURL)
        return filename
    }
    
    func saveVideo(from sourceURL: URL) async throws -> String {
        let ext = sourceURL.pathExtension.isEmpty ? "mov" : sourceURL.pathExtension
        let filename = "\(UUID().uuidString).\(ext)"
        let destinationURL = fileURL(for: filename)
        
        try await Task.detached(priority: .userInitiated) {
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
        }.value
                                
        return filename
    }
    
    func saveAudio(from sourceURL: URL) throws -> String {
        let ext = sourceURL.pathExtension.isEmpty ? "m4a" : sourceURL.pathExtension
        let filename = "\(UUID().uuidString).\(ext)"
        let destinationURL = fileURL(for: filename)
        
        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
        
        return filename
    }
    
    func makeNewAudioDestination() -> (filename: String, url: URL) {
        let filename = "\(UUID().uuidString).m4a"
        return (filename, fileURL(for: filename))
    }
    
    func loadImage(named filename: String) -> UIImage? {
        let url = fileURL(for: filename)
        guard let data = try? Data(contentsOf: url) else {return nil}
        return UIImage(data: data)
    }
    
    func fileURL(for filename: String) -> URL {
        URL.documentsDirectory.appending(path: filename)
    }
    
    func deleteFile(named filename: String) throws {
        let url = fileURL(for: filename)
        guard FileManager.default.fileExists(atPath: url.path()) else {return}
        
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            throw error
        }
    }
}
