//
//  ShowViewModel.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 21/11/2024.
//

import Foundation

@MainActor
class ShowViewModel: ObservableObject {
    
    @Published var favorites: [Show] = []
    @Published var favoritesIDs: [Int?] = []
    @Published var watchlist: [Show] = []
    @Published var watchlistIDs: [Int?] = []
    @Published var recommendations: [Show] = []
    @Published var shows: [Show] = []
    @Published var show: Show?
    @Published var actors: [Actor] = []
    @Published var reviews: [Review] = []
    @Published var showRecommendations: [ShowRecommendation] = []

    private let service = ShowService()
    
    func fetchFavorites() async {
        do {
            // Récupère la liste des séries favorites depuis le service
            let data = try await service.fetchFavorites()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            // Décodage des données en utilisant ShowsResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ShowsResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            self.favorites = decodedResponse.results
            print(" Est-ce qu'on a les séries favoris ? \(self.favorites)")
        } catch {
            print("Erreur de récupération des séries favorites : \(error)")
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
            let decodedResponse = try decoder.decode(ShowsResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            
            // Récupérer uniquement les IDs des films
            self.favoritesIDs = decodedResponse.results.map { $0.id }
            print("Est-ce qu'on a les IDs des seris favoris ? \(self.favoritesIDs)")
        } catch {
            print("Erreur de récupération des IDs des series : \(error)")
        }
    }
    
    func fetchTVWatchlist() async {
        do {
            // Récupère la liste des séries favorites depuis le service
            let data = try await service.fetchTVWatchlist()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            // Décodage des données en utilisant ShowsResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ShowsResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            self.watchlist = decodedResponse.results
            print(" Est-ce qu'on a la TV watchlist ? \(self.watchlist)")
        } catch {
            print("Erreur de récupération de la TV watchlist : \(error)")
        }
    }
    
    func fetchWatchlistIDs() async {
        do {
            // Récupère la liste des films favoris depuis le service
            let data = try await service.fetchTVWatchlist()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage des données en utilisant MoviesResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ShowsResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            
            // Récupérer uniquement les IDs des films
            self.watchlistIDs = decodedResponse.results.map { $0.id }
            print("Est-ce qu'on a les IDs des tv wl ? \(self.watchlistIDs)")
        } catch {
            print("Erreur de récupération des IDs tv : \(error)")
        }
    }
    
    func sendToWL(showId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.sendToWatchlist(showId: showId)
            watchlistIDs.append(showId)
            print("Réponse brute de l'envoi du tv en wl :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de l'envoi du tv en wl: \(error)")
        }
    }
    
    func delFromWL(showId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.deleteFromWatchlist(showId: showId)
            watchlistIDs.removeAll { $0 == showId }
            print("Réponse brute de del tv en wl :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de del tv en wl: \(error)")
        }
    }
    
    func fetchRecommendations() async {
        do {
            // Récupère la liste des séries favorites depuis le service
            let data = try await service.fetchRecommendations()
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            // Décodage des données en utilisant ShowsResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ShowsResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            self.recommendations = decodedResponse.results
            print(" Est-ce qu'on a les reco tv? \(self.recommendations)")
        } catch {
            print("ERREUR de récupération des reco tv: \(error)")
        }
    }
    
    func sendFav(showId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.sendFavorites(showId: showId)
            favoritesIDs.append(showId)
            print("Réponse brute de l'envoi tv en favori :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de l'envoi tv en favori: \(error)")
        }
    }
    
    func deleteFav(showId: Int) async {
        do {
            // Envoi des favoris
            let data = try await service.deleteFavorites(showId: showId)
            favoritesIDs.removeAll { $0 == showId }
            print("Réponse brute de del de la tv en favori :")
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print("Erreur lors de del tv en favori: \(error)")
        }
    }
    
    func fetchShowDetail(show_id: Int32) async {
        do {
            print("Service : Requête envoyée pour : \(show_id)")
            let data = try await service.fetchShowDetail(show_id: show_id)
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage directement en Série
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(Show.self, from: data)
            print("Réponse décodée : \(decodedResponse)")
            
            // Mise à jour de la propriété publiée
            self.show = decodedResponse
        } catch {
            print("Erreur de récupération du détail de la série : \(error)")
        }
    }
    
    func fetchShowCast(show_id: Int32) async {
        do {
            print("Service : Requête envoyée pour : \(show_id)")
            let data = try await service.fetchShowCast(show_id: show_id)
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
    
    func fetchShowReview(show_id: Int32) async {
       do {
           print("Service : Requête envoyée pour : \(show_id)")
           let data = try await service.fetchShowReviews(show_id: show_id)
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
    
    func fetchShowRecommendation(show_id: Int32) async {
        do {
            print("Service recommandation : Requête envoyée pour : \(show_id)")
            let data = try await service.fetchShowRecommendations(show_id: show_id)
            print("Réponse brute des recommandations : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage directement en Actor
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ShowRecommendationResponse.self, from: data)
            print("Réponse décodée pour les recommandations : \(decodedResponse)")
            
            // Assigne les acteurs au tableau actors
            self.showRecommendations = decodedResponse.results
            print(" Est-ce qu'on a les recommandations ? \(self.recommendations)")
        } catch {
            print("Erreur de récupération des recommandations : \(error)")
        }
    }
           
            
        
    
}



