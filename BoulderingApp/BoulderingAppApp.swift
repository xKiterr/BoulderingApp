//
//  BoulderingAppApp.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 08/11/2026.
//

import SwiftUI
import SwiftData

@main
struct BoulderingAppApp: App {
    var body: some Scene {
        WindowGroup {
            RouteListView()
                .preferredColorScheme(.dark)

        }
        .modelContainer(for: Route.self)
    }
}
