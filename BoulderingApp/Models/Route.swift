//
//  Route.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 08/11/2026.
//

import Foundation
import SwiftData

enum Terrain: String, Codable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
}

enum WallAngle: String, Codable {
    case slab = "Slab"
    case vertical = "Vertical"
    case overhang = "Overhang"
}

enum HoldType: String, Identifiable, Codable {
    case jugs = "Jugs"
    case ledges = "Ledges"
    case crimps = "Crimps"
    case pinches = "Pinches"
    case slopers = "Slopers"
    case pockets = "Pockets"
    case volumes = "Volumes"
    case dualTexture = "Dual Texture"
    
    var id: String { rawValue }
}

enum RouteStyle: String, Identifiable, Codable {
    case reachy = "Reachy"
    case powerful = "Powerful"
    case technical = "Technical"
    case flexibility = "Flexibility"
    case pumpy = "Pumpy"
    case dyno = "Dyno"
    case footwork = "Footwork"
    case Scary = "Scary"
    case mantle = "Mantle"
    case edge = "Edge"
    case compression = "Compression"
    case expansion = "Expansion"
    case traverse = "Traverse"
    
    var id: String { rawValue }
}

@Model
final class Route: Identifiable, Hashable {
    var name: String
    var grade: Grade
    var date: Date
    var location: String
    var terrain: Terrain?
    var wallAngle: WallAngle?
    var holds: Set<HoldType>
    var styles: Set<RouteStyle>
    var betaBreakdown: String?
    var shoeCondition: String?
    var voiceNote: String?
    var photos: [String]
    var video: String?
    
    var allCharacteristics: [String] {
        var combined: [String] = []
            
        if let terrain = terrain { combined.append(terrain.rawValue) }
        if let angle = wallAngle { combined.append(angle.rawValue) }
            
        combined.append(contentsOf: holds.map { $0.rawValue }.sorted())
        combined.append(contentsOf: styles.map { $0.rawValue }.sorted())
            
        return combined
    }
    
    init(
        name: String,
        grade: Grade,
        date: Date = .now,
        location: String,
        terrain: Terrain? = nil,
        wallAngle: WallAngle? = nil,
        holds: Set<HoldType> = [],
        styles: Set<RouteStyle> = [],
        betaBreakdown: String? = nil,
        shoeCondition: String? = nil,
        voiceNote: String? = nil,
        photos: [String] = [],
        video: String? = nil
    ) {
        self.name = name
        self.grade = grade
        self.date = date
        self.location = location
        self.terrain = terrain
        self.wallAngle = wallAngle
        self.holds = holds
        self.styles = styles
        self.betaBreakdown = betaBreakdown
        self.shoeCondition = shoeCondition
        self.voiceNote = voiceNote
        self.photos = photos
        self.video = video
    }
}

extension Route {
    static let mock = Route(
        name: "Cool Outdoor",
        grade: Grade(baseScore: 25),
        date: Date(),
        location: "Sintra",
        terrain: .outdoor,
        wallAngle: .overhang,
        holds: [.crimps],
        styles: [.powerful],
        betaBreakdown: "Crux is at the top",
        shoeCondition: "Good",
        voiceNote: nil,
        photos: ["sintra_boulder_1", "sintra_boulder_2", "sintra_boulder_3", "sintra_boulder_4"], 
        video: "sintra_boulder_1"
    )
}
