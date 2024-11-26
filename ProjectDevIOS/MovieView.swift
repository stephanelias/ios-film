//
//  FilmView.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 12/11/2024.
//

import SwiftUI

 
struct MovieView: View {
    
    @StateObject private var viewModel = MovieViewModel()
    @State private var searchterm = ""
    
    var filteredMoviesTV: [Movie] {
        guard !searchterm.isEmpty else {return viewModel.movies}
        return viewModel.movies.filter{
            $0.title!.localizedCaseInsensitiveContains(searchterm)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredMoviesTV) { movie in
                NavigationLink(destination: MovieDetailView(movieId: Int32(movie.id!))) {
                    HStack {
                        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w440_and_h660_face/\(movie.poster_path!)") {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 150)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                        }
 
                        VStack(alignment: .leading) {
                            Text(movie.title!)
                                .font(.headline)
                            Text("Release Date: \(movie.release_date!)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Liste des films")
            .task {
                await viewModel.fetchFilms()
            }
            .searchable(text: $searchterm, prompt: "Rechercher un film")
        }
    }
}

#Preview {
    MovieView()
}
