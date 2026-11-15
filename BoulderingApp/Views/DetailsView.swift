//
//  ContentView.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 08/11/2026.
//

import SwiftUI

struct DetailsView: View {
    let route: Route
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(route.name)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("6a+")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                
                
                VStack {
                    HStack {
                        Text("Characteristics")
                        Spacer()
                        Button {
                            //action here
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.appCard)
                                )
                        }
                    }
                    .padding(.horizontal)
                    FlowLayout(spacing: 8) {
                        ForEach(route.allCharacteristics, id: \.self) { characteristic in
                            Text(characteristic)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.appCard)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                
                if let beta = route.betaBreakdown {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Beta Breakdown")
                        
                        Text(beta)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.appCard)
                            )
                    }
                    .padding(.horizontal)
                }
                
                if let shoeCondition = route.shoeCondition {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Shoe Condition")
                        
                        Text(shoeCondition)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.appCard)
                            )
                    }
                    .padding(.horizontal)
                }
                
                if let voiceNote = route.voiceNote {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Voice Note")
                        
                        Text(voiceNote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.appCard)
                            )
                    }
                    .padding(.horizontal)
                }
                
                if !route.photos.isEmpty {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Photos Gallery")
                        
                        HStack {
                            let maxVisible = 3
                            let displayedPhotos = Array(route.photos.prefix(maxVisible))
                            let remainingCount = route.photos.count - maxVisible
                            ForEach(Array(displayedPhotos.enumerated()), id: \.offset) { index, imageName in
                                    ZStack {
                                        Image(imageName)
                                            .resizable()
                                            .scaledToFill()
                                            
                                        if index == maxVisible - 1 && remainingCount > 0 {
                                            Color.black.opacity(0.6)
                                            
                                            Text("+\(remainingCount + 1)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(width: 101, height: 101)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal)
                }
                if let video = route.video {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Beta Video")
                        
                        ZStack {
                            Image(video)
                                .resizable()
                                .scaledToFill()
                                
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.black.opacity(0.4))
                            
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Route Details")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .tint(Color.appGreen)
        .background(Color.appBackground)
    }
}

#Preview {
    NavigationStack {
        RouteListView()
    }
    .preferredColorScheme(.dark)
}
