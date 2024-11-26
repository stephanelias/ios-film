//
//  ShowDetailView.swift
//  ProjectDevIOS
//
//  Created by tplocal on 25/11/2024.
//

import SwiftUI

struct ShowDetailView: View {
    let showId: Int32
    @StateObject var viewModel = ShowViewModel() // Nouveau ViewModel pour gérer les détails de la série
    @State private var isLoading = true // Indicateur de chargement
    @State private var selectedTab = 0

    
    var favShowsId : [Int?] {
        return viewModel.favoritesIDs
    }

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Chargement...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let show = viewModel.show {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Affichage de l'image
                    if let posterPath = show.poster_path,
                       let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 380)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(20)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    }
                    
                    // Titre
                    if let name = show.name {
                        HStack {
                            Text(name)
                                .font(.largeTitle)
                                .bold()
                                .padding(.top)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .layoutPriority(1)
                            Spacer() // Sépare le texte et l'icône
                            if favShowsId.contains(where: { $0 == show.id })
                            {
                                Image(systemName: "heart.fill")
                                    .font(.title) // Taille équivalente au texte
                                    .foregroundColor(.pink)
                                    .padding(.top, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.deleteFav(showId: show.id!)
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
                                            await viewModel.sendFav(showId: show.id!)
                                        }
                                    }
                            }
                        }
                    }
                    
                    // Date de première diffusion
                    if let firstAirDate = show.first_air_date {
                        Text("First Air Date: \(firstAirDate)")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    
                    // Nombre d'épisodes et de saisons
                    if let numberOfEpisodes = show.number_of_episodes,
                       let numberOfSeasons = show.number_of_seasons {
                        Text("\(numberOfEpisodes) Episodes • \(numberOfSeasons) Seasons")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Picker("", selection: $selectedTab) {
                                   Text("À PROPOS").tag(0)
                                   Text("ÉPISODES").tag(1)
                               }
                               .pickerStyle(SegmentedPickerStyle())
                               .padding()
                    if selectedTab == 0 {
                        AboutView(show: show)
                   } else {
                       Text("episode")
                   }
                    
                }
                .padding()
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
                await viewModel.fetchShowDetail(show_id: showId)
                await viewModel.fetchShowCast(show_id: showId)
                await viewModel.fetchShowReview(show_id: showId)
                await viewModel.fetchShowRecommendation(show_id: showId)
                isLoading = false
            }
        }
        .navigationTitle("Détail de la série")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    let show : Show
    
    @StateObject var viewModel = ShowViewModel()
    @State private var isLoading = true // Indicateur de chargement

    
    var body: some View {
        VStack(alignment:.leading) {
            
            //genre
            if let genres = show.genres, !genres.isEmpty {
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
            Text(show.overview ?? "No overview available.")
                .font(.body)
            
            
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
            
            //crtiques
            if !viewModel.reviews.isEmpty {
                Text("Reviews")
                    .font(.title2)
                    .bold()
                    .padding(.top)

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
            
            //reco
            if !viewModel.showRecommendations.isEmpty {
                Text("Recommendations")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.showRecommendations.prefix(6), id: \.id) { recommendation in
                            NavigationLink(destination: ShowDetailView(showId: Int32(recommendation.id))) {
                                ShowRecommendationView(recommendation: recommendation)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("Recommendations: Not available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoritesIDs()
                isLoading = true
                await viewModel.fetchShowDetail(show_id: Int32(show.id!))
                await viewModel.fetchShowCast(show_id: Int32(show.id!))
                await viewModel.fetchShowReview(show_id: Int32(show.id!))
                await viewModel.fetchShowRecommendation(show_id: Int32(show.id!))
                isLoading = false
            }
        }
    }
       
}

#Preview {
    ShowDetailView(showId: 94605)
}


