//
//  AddRouteViewModel.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 15/11/2026.
//

import Foundation
import SwiftData

@Observable
final class AddRouteViewModel {
    var name: String = ""
    var location: String = ""
    var date: Date = .now
    var selectedGrade: Grade?
    var terrain: Terrain?
    var wallAngle: WallAngle?
    var holds: Set<HoldType> = []
    var styles: Set<RouteStyle> = []
    var betaBreakdown: String = ""
    var shoeCondition: String = ""
    
    var pendingPhotoData: [Data] = []
    var pendingVideoURL: URL?
    var pendingVoiceNoteURL: URL?
    
    var isFetchingLocation = false
    
    var isSaving = false
    var errorMessage: String?
    
    private let modelContext: ModelContext
    private let mediaService: MediaStorageServicing
    private let locationService: LocationServicing
    
    init(
        modelContext: ModelContext,
        mediaService: MediaStorageServicing = MediaStorageService(),
        locationService: LocationServicing = LocationService()
    ){
        self.modelContext = modelContext
        self.mediaService = mediaService
        self.locationService = locationService
    }
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedGrade != nil
    }
    
    func saveRoute() async -> Bool {
        guard canSave, let grade = selectedGrade else {return false}
        
        isSaving = true
        errorMessage = nil
        var savedPhotoFilenames: [String] = []
        var savedVideoFilename: String?
        var savedVoiceNoteFilename: String?
        
        do {
            for data in pendingPhotoData {
                let filename = try mediaService.saveImage(data)
                savedPhotoFilenames.append(filename)
            }
            
            if let videoURL = pendingVideoURL {
                savedVideoFilename = try await mediaService.saveVideo(from: videoURL)
            }
            
            if let voiceNoteURL = pendingVoiceNoteURL {
                savedVoiceNoteFilename = try mediaService.saveAudio(from: voiceNoteURL)
            }
            
            let trimmedBetaBreakdown = betaBreakdown.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedShoeCondition = shoeCondition.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let newRoute = Route(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                grade: grade,
                location: location.trimmingCharacters(in: .whitespacesAndNewlines),
                terrain: terrain,
                wallAngle: wallAngle,
                holds: holds,
                styles: styles,
                betaBreakdown: trimmedBetaBreakdown.isEmpty ? nil : trimmedBetaBreakdown,
                shoeCondition: trimmedShoeCondition.isEmpty ? nil : trimmedShoeCondition,
                voiceNote: savedVoiceNoteFilename,
                photos: savedPhotoFilenames,
                video: savedVideoFilename,
            )
            modelContext.insert(newRoute)
            try modelContext.save()
            
            resetForm()
            isSaving = false
            return true
        } catch {
            for file in savedPhotoFilenames {
                try? mediaService.deleteFile(named: file)
            }
            if let video = savedVideoFilename {
                try? mediaService.deleteFile(named: video)
            }
            
            if let voiceNote = savedVoiceNoteFilename {
                try? mediaService.deleteFile(named: voiceNote)
            }
            errorMessage = "Couldn't save route: \(error.localizedDescription)"
            isSaving = false
            return false
        }
    }
    
    func loadDefaultLocation() async {
        guard location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {return}
        
        isFetchingLocation = true
        defer {isFetchingLocation = false}
        
        if let detectedPlace = await locationService.fetchCurrentPlaceName(),
           location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            location = detectedPlace
        }
    }
    
    func resetForm(){
        name = ""
        location = ""
        date = .now
        selectedGrade = nil
        terrain = nil
        wallAngle = nil
        holds = []
        styles = []
        betaBreakdown = ""
        shoeCondition = ""
        pendingPhotoData = []
        pendingVideoURL = nil
        pendingVoiceNoteURL = nil
        errorMessage = nil
    }
}
