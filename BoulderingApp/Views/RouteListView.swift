//
//  RouteListView.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 09/11/2026.
//

import SwiftUI

struct RouteListView: View {
    let routes = [
        Route.mock,
    ]

    var body: some View {
        NavigationStack {
            List(routes) { route in
                NavigationLink(value: route) {
                    HStack {
                        Text(route.name)
                            .font(.headline)
                        Spacer()
                        Text(route.location)
                            .foregroundColor(.gray)
                    }
                }
            }
            .scrollContentBackground(.hidden) 
            .background(Color.appBackground)
            .navigationTitle("My Routes")
            .navigationDestination(for: Route.self) { route in
                DetailsView(route: route)
            }
        }
        .preferredColorScheme(.dark)
    }
}
