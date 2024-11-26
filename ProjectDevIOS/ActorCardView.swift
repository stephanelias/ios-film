//
//  ActorCard.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 25/11/2024.
//

import Foundation

import SwiftUI
 
struct ActorCardView: View {
    let actor: Actor
 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let profilePath = actor.profile_path,
               let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)") {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2) // Placeholder
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 180)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Color.red.opacity(0.3) // Error placeholder
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.gray.opacity(0.2) // Default placeholder if no image
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
            }
 
            Text(actor.name)
                .font(.headline)
                .bold()
 
            Text(actor.character)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(actor.known_for_department)
                .font(.subheadline)
                .foregroundColor(.brown)
        }
        .frame(width: 150)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
