//
//  FilmModelView.swift
//  ProjectDevIOS
//
//  Created by tplocal on 12/11/2024.
//

import Foundation

@MainActor
class MovieViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var movie: Movie?
    @Published var actors: [Actor] = []
    @Published var reviews: [Review] = []
    @Published var movieRecommendations: [MovieRecommendation] = []
    @Published var favorites: [Movie] = []
    @Published var favoritesIDs: [Int?] = []
    @Published var watchlist: [Movie] = []
    @Published var watchlistIDs: [Int?] = []
    @Published var recommendations: [Movie] = []


    
    private let service = MovieService()
    
    func fetchFilms() async {
        do {
            // Récupère la liste des films depuis le service
            let data = try await service.fetchMovies()
            // Décodage des données en utilisant MoviesResponse
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
            
            // Assigne les films au tableau films
            self.movies = decodedResponse.results
            print(" Est-ce qu'on a les films ? \(self.movies)")
        } catch {
            print("Erreur de récupération des films : \(error)")
        }
    }
    
    func fetchFilmDetail(movie_id: Int32) async {
        do {
            print("Service : Requête envoyée pour : \(movie_id)")
            let data = try await service.fetchMovieDetail(movie_id: movie_id)
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage directement en Film
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(Movie.self, from: data)
            print("Réponse décodée : \(decodedResponse)")
            
            // Mise à jour de la propriété publiée
            self.movie = decodedResponse
        } catch {
            print("Erreur de récupération du détail du film : \(error)")
        }
    }
    
    func fetchFilmCast(movie_id: Int32) async {
        do {
            print("Service : Requête envoyée pour : \(movie_id)")
            let data = try await service.fetchMovieCast(movie_id: movie_id)
            print("Réponse brute des acteurs : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage directement en Actor
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(CastResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse)")
            
            // Assigne les acteurs au tableau actors
            self.actors = decodedResponse.cast
            print(" Est-ce qu'on a les acteurs ? \(self.actors)")
        } catch {
            print("Erreur de récupération des acteurs : \(error)")
        }
    }

    func fetchFilmReview(movie_id: Int32) async {
        do {
            print("Service : Requête envoyée pour : \(movie_id)")
            let data = try await service.fetchMovieReviews(movie_id: movie_id)
            print("Réponse brute des critiques : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage directement en Actor
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ReviewResponse.self, from: data)
            print("Réponse décodée pour les critiques : \(decodedResponse)")
            
            // Assigne les acteurs au tableau actors
            self.reviews = decodedResponse.results
            print(" Est-ce qu'on a les critiques ? \(self.reviews)")
        } catch {
            print("Erreur de récupération des critiques : \(error)")
        }
    }
    
    func fetchFilmRevcommandation(movie_id: Int32) async {
        do {
            print("Service recommandation : Requête envoyée pour : \(movie_id)")
            let data = try await service.fetchMovieRecommandations(movie_id: movie_id)
            print("Réponse brute des recommandations : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage directement en Actor
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(RecommandationResponse.self, from: data)
            print("Réponse décodée pour les recommandations : \(decodedResponse)")
            
            // Assigne les acteurs au tableau actors
            self.movieRecommendations = decodedResponse.results
            print(" Est-ce qu'on a les film ? \(self.movieRecommendations)")
        } catch {
            print("Erreur de récupération des film reco : \(error)")
        }
    }

    func fetchFavorites() async {
        do {
            // Récupère la liste des films depuis le service
            let data = try await service.fetchFavorites()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            // Décodage des données en utilisant MoviesResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            // Assigne les films au tableau films
            self.favorites = decodedResponse.results
            print(" Est-ce qu'on a les films favoris ? \(self.favorites)")
        } catch {
            print("Erreur de récupération des films : \(error)")
        }
    }
    
    func fetchFavoritesIDs() async {
        do {
            // Récupère la liste des films favoris depuis le service
            let data = try await service.fetchFavorites()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage des données en utilisant MoviesResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            
            // Récupérer uniquement les IDs des films
            self.favoritesIDs = decodedResponse.results.map { $0.id }
            print("Est-ce qu'on a les IDs des films favoris ? \(self.favoritesIDs)")
        } catch {
            print("Erreur de récupération des IDs des films : \(error)")
        }
    }
    
    func fetchWatchlistIDs() async {
        do {
            // Récupère la liste des films favoris depuis le service
            let data = try await service.fetchMovieWatchlist()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage des données en utilisant MoviesResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            
            // Récupérer uniquement les IDs des films
            self.watchlistIDs = decodedResponse.results.map { $0.id }
            print("Est-ce qu'on a les IDs des films wl ? \(self.watchlistIDs)")
        } catch {
            print("Erreur de récupération des IDs wl : \(error)")
        }
    }
    
    func fetchMovieWatchlist() async {
        do {
            // Récupère la liste des séries favorites depuis le service
            let data = try await service.fetchMovieWatchlist()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            // Décodage des données en utilisant MoviesResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            self.watchlist = decodedResponse.results
            print(" Est-ce qu'on a la watchlist film? \(self.watchlist)")
        } catch {
            print("Erreur de récupération de la watchlist film: \(error)")
        }
    }
    
    func sendToWL(movieId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.sendToWatchlist(movieId: movieId)
            watchlistIDs.append(movieId)
            print("Réponse brute de l'envoi du film en wl :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de l'envoi du film en wl: \(error)")
        }
    }
    
    func delFromWL(movieId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.deleteFromWatchlist(movieId: movieId)
            watchlistIDs.removeAll { $0 == movieId }
            print("Réponse brute de del film en wl :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de del film en wl: \(error)")
        }
    }
    
    func fetchRecommendations() async {
        do {
            // Récupère la liste des séries favorites depuis le service
            let data = try await service.fetchRecommendations()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            // Décodage des données en utilisant MoviesResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            self.recommendations = decodedResponse.results
            print(" Est-ce qu'on a les reco? \(self.recommendations)")
        } catch {
            print("Erreur de récupération des reco: \(error)")
        }
    }
    
    func sendFav(movieId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.sendFavorites(movieId: movieId)
            favoritesIDs.append(movieId)
            print("Réponse brute de l'envoi du film en favori :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de l'envoi du film en favori: \(error)")
        }
    }
    
    func deleteFav(movieId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.deleteFavorites(movieId: movieId)
            favoritesIDs.removeAll { $0 == movieId }
            print("Réponse brute de del film en favori :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de del du film en favori: \(error)")
        }
    }
    
    
}

