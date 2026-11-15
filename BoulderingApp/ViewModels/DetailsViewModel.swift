//
//  DetailsViewModel.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 08/11/2026.
//

import Foundation
import SwiftData

@Observable
final class DetailsViewModel {
    var route: Route
    var errorMessage: String?
    
    private let modelContext: ModelContext
    private let mediaService: MediaStorageServicing
    
    init(
        route: Route,
        modelContext: ModelContext,
        mediaService: MediaStorageServicing = MediaStorageService()
    ){
        self.route = route
        self.modelContext = modelContext
        self.mediaService = mediaService
    }
    
    func updateNotes(betaBreakdown: String?, shoeCondition: String?) {
        route.betaBreakdown = betaBreakdown?.isEmpty == true ? nil : betaBreakdown
        route.shoeCondition = shoeCondition?.isEmpty == true ? nil : shoeCondition
        saveChanges()
    }
    
    func toggleHold(_ hold: HoldType){
        if route.holds.contains(hold){
            route.holds.remove(hold)
        } else {
            route.holds.insert(hold)
        }
        saveChanges()
    }
    
    func toggleStyle(_ style: RouteStyle){
        if route.styles.contains(style){
            route.styles.remove(style)
        } else {
            route.styles.insert(style)
        }
        saveChanges()
    }
    
    func addPhoto(data: Data){
        do {
            let filename = try mediaService.saveImage(data)
            route.photos.append(filename)
            saveChanges()
        } catch {
            errorMessage = "Couldn't save photo."
        }
    }
    
    func setVideo(from pickedURL: URL) async {
        do {
            if let oldVideo = route.video {
                try? mediaService.deleteFile(named: oldVideo)
            }
            route.video = try await mediaService.saveVideo(from: pickedURL)
            saveChanges()
        } catch {
            errorMessage = "Couldn't save beta video."
        }
    }
    
    func setAudio(from pickedURL: URL) {
        do {
            if let oldVoiceNote = route.voiceNote {
                try? mediaService.deleteFile(named: oldVoiceNote)
            }
            route.voiceNote = try mediaService.saveAudio(from: pickedURL)
            saveChanges()
        } catch {
            errorMessage = "Couldn't save voice note."
        }
    }
    
    func deleteRoute() -> Bool {
        for photo in route.photos {
            try? mediaService.deleteFile(named: photo)
        }
        if let video = route.video {
            try? mediaService.deleteFile(named: video)
        }
        if let voiceNote = route.voiceNote{
            try? mediaService.deleteFile(named: voiceNote)
        }
        
        modelContext.delete(route)
        
        do {
            try modelContext.save()
            return true
        } catch {
            errorMessage = "Failed to delete route: \(error.localizedDescription)"
            return false
        }
    }
    
    
    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            errorMessage = "Failed to save route updates: \(error.localizedDescription)"
        }
    }
}
