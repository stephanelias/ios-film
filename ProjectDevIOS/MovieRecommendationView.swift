//
//  RecommendationView.swift
//  ProjectDevIOS
//
//  Created by tplocal on 25/11/2024.
//

import SwiftUI

struct MovieRecommendationView: View {
    let recommendation: MovieRecommendation

    var body: some View {
        VStack {
            if let posterPath = recommendation.poster_path,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 180)
                        .cornerRadius(8)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(width: 80, height: 120)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
