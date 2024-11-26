//
//  ProfileView.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 12/11/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var movieViewModel = MovieViewModel()
    
    @StateObject private var showViewModel = ShowViewModel()

    var favoritesFilms : [Movie] {
        print("****test*****")
        print(movieViewModel.favorites)
        return movieViewModel.favorites
    }
    
    var movieWatchlist : [Movie] {
        print("****test*****")
        print(movieViewModel.watchlist)
        return movieViewModel.watchlist
    }
    
    var favoritesShows : [Show] {
        print("****test*****")
        print(showViewModel.favorites)
        return showViewModel.favorites
    }
    
    var tvWatchlist : [Show] {
        print("****test*****")
        print(showViewModel.watchlist)
        return showViewModel.watchlist
    }
    
    var body: some View {
        VStack {
            Text("Utilisateur app")
                .font(.largeTitle)
                .fontWeight(.bold)
            Divider()
            Text("Séries suivies")
                .font(.headline)
            ScrollView(Axis.Set.horizontal) {
                HStack {
                    ForEach(tvWatchlist, id: \.id) { show in
                        VStack {
                            Text(show.name!)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .task {
                    await showViewModel.fetchTVWatchlist()
                }
                .padding()
            }
            Text("Mes séries favorites")
                .font(.headline)
            ScrollView(Axis.Set.horizontal) {
                HStack {
                    ForEach(favoritesShows, id: \.id) { show in
                        VStack {
                            Text(show.name!)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .task {
                    await showViewModel.fetchFavorites()
                }
                .padding()
            }
            Text("Films suivis")
                .font(.headline)
            ScrollView(Axis.Set.horizontal) {
                HStack {
                    ForEach(movieWatchlist, id: \.id) { film in
                        VStack {
                            Text(film.title!)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .task {
                    await movieViewModel.fetchMovieWatchlist()
                }
                .padding()
            }
            Text("Mes films favoris")
                .font(.headline)
            ScrollView(Axis.Set.horizontal) {
                HStack {
                    ForEach(favoritesFilms, id: \.id) { film in
                        VStack {
                            Text(film.title!)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .task {
                    await movieViewModel.fetchFavorites()
                }
                .padding()
            }
            
            
        }
    }
}

#Preview {
    ProfileView()
}
