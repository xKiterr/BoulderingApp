//
//  RouteListViewModel.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 15/11/2026.
//

import Foundation
import SwiftData

@Observable
final class RouteListViewModel {
    var routes: [Route] = []
    var searchText = ""
    var selectedTerrain: Terrain?
    var errorMessage: String?
    
    private let modelContext: ModelContext
    private let mediaService: MediaStorageServicing
    
    init(
        modelContext: ModelContext,
        mediaService: MediaStorageServicing = MediaStorageService()
    ){
        self.modelContext = modelContext
        self.mediaService = mediaService
        fetchRoutes()
    }
    
    func fetchRoutes() {
        let descriptor = FetchDescriptor<Route>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        do {
            routes = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load routes: \(error.localizedDescription)"
        }
    }
    
    var filteredRoutes: [Route] {
        routes.filter { route in
            let matchesTerrain = selectedTerrain == nil || route.terrain == selectedTerrain
            let matchesSearch = searchText.isEmpty || route.name.localizedCaseInsensitiveContains(searchText) || route.location.localizedCaseInsensitiveContains(searchText)
            return matchesSearch && matchesTerrain
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
