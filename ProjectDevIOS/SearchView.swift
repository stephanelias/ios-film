//
//  SearchView.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 12/11/2024.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var movieViewModel = MovieViewModel()
    @StateObject private var showViewModel = ShowViewModel()

    
    @State private var searchterm = ""
    

    
    
    
    // On filtre les films et/ou série en fonction du mot clé de la recherche
    var filteredMoviesTV: [Multi] {
        guard !searchterm.isEmpty else {return viewModel.multis}
        return viewModel.multis.filter { multi in
                let searchField = multi.title ?? multi.name
            return searchField!.localizedCaseInsensitiveContains(searchterm)
        }
    }
    
    var movieRecommendations : [Movie] {
        print("****TEST-FILM-RECO*****")
        print(movieViewModel.recommendations)
        return movieViewModel.recommendations
    }
    
    var showRecommendations : [Show] {
        print("****TEST-SHOW-RECO*****")
        print(showViewModel.recommendations)
        return showViewModel.recommendations
    }
    
    

    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchterm.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text("Films qui pourrait vous intéresser")
                    ScrollView(Axis.Set.horizontal) {
                        HStack {
                            ForEach(movieRecommendations, id: \.id) { movie in
                                VStack {
                                    Text(movie.title!)
                                        .font(.headline)
                                    
                                }
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                        .task {
                            await movieViewModel.fetchRecommendations()
                        }
                        .padding()
                    }
                    Text("Séries qui pourrait vous intéresser")
                    ScrollView(Axis.Set.horizontal) {
                        HStack {
                            ForEach(showRecommendations, id: \.id) { show in
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
                            await showViewModel.fetchRecommendations()
                        }
                        .padding()
                    }
                } else {
                    List(filteredMoviesTV) { multi in
                        if multi.media_type == "movie" {
                            NavigationLink(destination: MovieDetailView(movieId: Int32(multi.id))) {
                                SearchResultRow(multi:multi)
                            }
                        }
                        else if multi.media_type == "tv"{
                            NavigationLink(destination: ShowDetailView(showId: Int32(multi.id))) {
                                SearchResultRow(multi:multi)
                            }
                        }
                        
                    }
                }
            }
            .task {
                if !searchterm.trimmingCharacters(in: .whitespaces).isEmpty {
                    await viewModel.fetchMulti(searchQuery: searchterm)
                }
            }
            .searchable(text: $searchterm, prompt: "Rechercher un film ou une série")
            .onChange(of: searchterm) {
                Task {
                    if !searchterm.trimmingCharacters(in: .whitespaces).isEmpty {
                        await viewModel.fetchMulti(searchQuery: searchterm)
                    }
                }
            }
        }
        
    }
}

struct SearchResultRow : View {
    
    
    let multi: Multi
    
    var wlMoviesId : [Int?] {
        return movieViewModel.watchlistIDs
    }
    
    var wlShowsId : [Int?] {
        return showViewModel.watchlistIDs
    }
    
    
    
    
    @StateObject private var movieViewModel = MovieViewModel()
    @StateObject private var showViewModel = ShowViewModel()
    
    var body: some View {
        HStack {
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w440_and_h660_face/\(multi.poster_path ?? "")") {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                } placeholder: {
                    ProgressView() // Indicateur de chargement
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 150)
            }

            VStack(alignment: .leading) {
                Text(multi.media_type == "movie" ? (multi.title ?? "Unknown Title") : (multi.name ?? "Unknown Name"))
                    .font(.headline)

                Text("Date de sortie: \(multi.release_date ?? multi.first_air_date ?? "Unknown Date")")
                    .font(.subheadline)
                switch multi.media_type {
                case "movie":
                    if wlMoviesId.contains(where: { $0 == multi.id }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                Task {
                                    await movieViewModel.delFromWL(movieId: multi.id)
                                }
                            }
                    }
                    else {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                Task {
                                    await movieViewModel.sendToWL(movieId: multi.id)
                                }
                            }
                    }
                default:
                    if wlShowsId.contains(where: { $0 == multi.id }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .onTapGesture {
                                Task {
                                    await showViewModel.delFromWL(showId: multi.id)
                                }
                            }
                    }
                    else {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                Task {
                                    await showViewModel.sendToWL(showId: multi.id)
                                }
                            }
                    }
                }
                
            }
        }
        .task {
            await movieViewModel.fetchWatchlistIDs()
            await showViewModel.fetchWatchlistIDs()
        }
    }
}

#Preview {
    SearchView()
}
