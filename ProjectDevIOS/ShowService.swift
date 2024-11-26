//
//  ShowService.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 21/11/2024.
//

import Foundation

class ShowService {
    
    private let apiKey = "afdee77229b2277bd524ead2bd3c3b6c"

    func fetchFavorites() async throws -> Data {
        
        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/favorite/tv")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sort_by", value: "created_at.asc"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(" On annonce les séries favori")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
        
    }
    
    func fetchTVWatchlist() async throws -> Data {
        
        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/watchlist/tv")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sort_by", value: "created_at.asc"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("On annonce les séries dans la TV watchlist")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    func getRandomFavoriteID() async throws -> Int? {
        let data = try await fetchFavorites()
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(ShowsResponse.self, from: data)
        
        return decodedResponse.results.randomElement()?.id
    }
    
    func fetchRecommendations() async throws -> Data {
      
        guard let showID = try await getRandomFavoriteID() else {
            throw NSError(domain: "ShowServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Aucune séries favori disponible pour les recommandations."])
        }

        // Construction de l'URL avec l'ID du film
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(showID)/recommendations")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "api_key", value: apiKey) // N'oubliez pas d'ajouter votre clé API ici
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]

        // Exécution de la requête
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Recommandations tv reçues :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête tv reco : \(error)")
            throw error
        }
    }
    
    func sendFavorites(showId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "tv",
            "media_id": showId,
            "favorite": true
        ]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Status envoi fav tv :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête send fav tv: \(error)")
            throw error
        }
    }
    
    func deleteFavorites(showId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "tv",
            "media_id": showId,
            "favorite": false
        ]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Status del fav tv :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête del fav tv: \(error)")
            throw error
        }
    }
    
    func fetchShowDetail(show_id: Int32) async throws -> Data {
            
        // URL spécifique pour le détail d'un film
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(show_id)")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
 
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        do {
            // Requête réseau
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Vérification du code de réponse HTTP
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("Erreur serveur : \(errorMessage)")
                throw NSError(domain: "TMDBError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
            print("Réponse brute : \(String(decoding: data, as: UTF8.self))")
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    
    func fetchShowCast(show_id: Int32) async throws -> Data {
            
        // URL spécifique pour les acteurs d'un film
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(show_id)/credits")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
 
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        do {
            // Requête réseau
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Vérification du code de réponse HTTP
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("Erreur serveur : \(errorMessage)")
                throw NSError(domain: "TMDBError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
            print("Réponse brute : \(String(decoding: data, as: UTF8.self))")
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    func fetchShowReviews(show_id: Int32) async throws -> Data {
        
        // URL spécifique pour les acteurs d'un film
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(show_id)/reviews")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),  // Utilisez l'API Key ici
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
 
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        do {
            // Requête réseau
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Vérification du code de réponse HTTP
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("Erreur serveur : \(errorMessage)")
                throw NSError(domain: "TMDBError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
            print("Réponse brute : \(String(decoding: data, as: UTF8.self))")
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    func fetchShowRecommendations(show_id: Int32) async throws -> Data {
        
        // URL spécifique pour les acteurs d'un film
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(show_id)/recommendations")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),  // Utilisez l'API Key ici
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
 
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]
        
        do {
            // Requête réseau
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Vérification du code de réponse HTTP
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("Erreur serveur : \(errorMessage)")
                throw NSError(domain: "TMDBError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
            print("Réponse brute : \(String(decoding: data, as: UTF8.self))")
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    func sendToWatchlist(showId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "tv",
            "media_id": showId,
            "watchlist": true
        ]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/watchlist")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Status envoi to wL tv :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête send to wl tv: \(error)")
            throw error
        }
    }
    
    func deleteFromWatchlist(showId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "tv",
            "media_id": showId,
            "watchlist": false
        ]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/watchlist")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZmRlZTc3MjI5YjIyNzdiZDUyNGVhZDJiZDNjM2I2YyIsIm5iZiI6MTczMjEzMDgyMS4yMzUxNSwic3ViIjoiNjczMzVjOGMyOWFhOGZmMjQ0YzBlZmM4Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.MpGFQH0ZtvwxoV27uZmP0AdukecQkwoHW5WMTTIfanU"
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Status del to wL tv :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête del to wl tv: \(error)")
            throw error
        }
    }
}
