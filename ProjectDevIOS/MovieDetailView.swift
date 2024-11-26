//
//  FilmDetailView.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 25/11/2024.
//

import Foundation

import SwiftUI
 
struct MovieDetailView: View {
    let movieId: Int32
    @StateObject var viewModel = MovieViewModel() // Nouveau ViewModel pour gérer le détail
    @State private var isLoading = true // Indicateur de chargement
    
    var favMoviesId : [Int?] {
        return viewModel.favoritesIDs
    }
 
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Chargement...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let movie = viewModel.movie {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Affichage de l'image
                    if let posterPath = movie.poster_path,
                       let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    }
                    
                    // Titre
                    if let title = movie.title {
                        HStack {
                            Text(title)
                                .font(.largeTitle)
                                .bold()
                                .padding(.top)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .layoutPriority(1)
                            
                            Spacer() // Sépare le texte et l'icône
                            if favMoviesId.contains(where: { $0 == movie.id })
                            {
                                Image(systemName: "heart.fill")
                                    .font(.title) // Taille équivalente au texte
                                    .foregroundColor(.pink)
                                    .padding(.top, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.deleteFav(movieId: movie.id!)
                                        }
                                    }
                            }
                            else {
                                Image(systemName: "heart")
                                    .font(.title) // Taille équivalente au texte
                                    .foregroundColor(.pink)
                                    .padding(.top, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.sendFav(movieId: movie.id!)
                                        }
                                    }
                            }
                        }
                    }
                    
                    // Date de sortie
                    if let releaseDate = movie.release_date {
                        Text("Release Date: \(releaseDate)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Genres
                    if let genres = movie.genres, !genres.isEmpty {
                        Text("Genres")
                            .font(.title2)
                            .bold()
                            .padding(.top)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(genres, id: \.id) { genre in
                                    Text(genre.name)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        Text("Genres: Not available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Synopsis
                    Text("Overview")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    Text(movie.overview ?? "No overview available.")
                        .font(.body)
                    
                    // Sections supplémentaires (Acteurs, Critiques, Recommandations)
                    
                    
                    // Section des acteurs
                    if !viewModel.actors.isEmpty {
                        Text("Cast")
                            .font(.title2)
                            .bold()
                            .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                // Affichage des trois premiers acteurs
                                ForEach(viewModel.actors.prefix(3), id: \.id) { actor in
                                    ActorCardView(actor: actor)
                                }
                                
                                // Bouton "Afficher davantage"
                                NavigationLink(destination: FullCastView(actors: viewModel.actors)) {
                                    VStack {
                                        Text("Afficher")
                                            .font(.headline)
                                            .bold()
                                        Text("davantage")
                                            .font(.headline)
                                            .bold()
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.body)
                                    }
                                    .padding()
                                    .frame(width: 120, height: 180)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                }
                            }
                            .padding(.all)
                        }
                    } else {
                        Text("Cast: Not available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    if !viewModel.reviews.isEmpty {
                                            Text("Reviews")
                                                .font(.title2)
                                                .bold()
                                                .padding(.top)
                     
                                            // Limiter à 3 commentaires
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 16) {
                                                    ForEach(viewModel.reviews.prefix(3), id: \.id) { review in
                                                        ReviewView(review: review)
                                                            .frame(width: 300) // Taille fixe pour alignement horizontal
                                                    }
                                                }
                                                .padding(.all)
                                            }
                                        } else {
                                            Text("Reviews: Not available")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                     
                                         
                                        
                                        // Section des recommandations
                                        
                                        if !viewModel.recommendations.isEmpty {
                                            VStack(alignment: .leading) {
                                                Text("Recommendations")
                                                    .font(.title2)
                                                    .bold()
                                                    .padding(.leading)
                     
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 16) {
                                                        ForEach(viewModel.movieRecommendations.prefix(6), id: \.id) { recommendation in
                                                            NavigationLink(destination: MovieDetailView(movieId: Int32(recommendation.id))) {
                                                                MovieRecommendationView(recommendation: recommendation)
                                                            }
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                }
                                            }
                                        } else {
                                            Text("Recommendations: Not available")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                }.padding()
            } else {
                Text("Aucune information disponible")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoritesIDs()
                isLoading = true
                await viewModel.fetchFilmDetail(movie_id: movieId)
                await viewModel.fetchFilmCast(movie_id: movieId)
                await viewModel.fetchFilmReview(movie_id: movieId)
                await viewModel.fetchFilmRevcommandation(movie_id: movieId)
                isLoading = false
            }
        }
        .navigationTitle("Détail du film")
        .navigationBarTitleDisplayMode(.inline)
    }
}
 
 
 
#Preview {
    MovieDetailView(movieId: 912649)
}
