//
//  lesFilmsService.swift
//  ProjectDevIOS
//
//  Created by tplocal on 12/11/2024.
//

import Foundation

class MovieService {
    
    // Ajoutez votre clé d'API ici
    private let apiKey = "afdee77229b2277bd524ead2bd3c3b6c"
    
    func fetchMovies() async throws -> Data {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        
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
            let (data, _) = try await URLSession.shared.data(for: request)
            print(" On annonce les résultats des films")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    func fetchMovieDetail(movie_id: Int32) async throws -> Data {
        
        // URL spécifique pour le détail d'un film
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),  // Utilisez l'API Key ici
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
    
    func fetchMovieCast(movie_id: Int32) async throws -> Data {
            
        // URL spécifique pour les acteurs d'un film
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)/credits")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),  // Utilisez l'API Key ici
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
        
        
    func fetchMovieReviews(movie_id: Int32) async throws -> Data {
        
        // URL spécifique pour les acteurs d'un film
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)/reviews")!
        
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
    
        
        
    func fetchMovieRecommandations(movie_id: Int32) async throws -> Data {
        
        // URL spécifique pour les acteurs d'un film
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)/recommendations")!
        
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
    
    func fetchFavorites() async throws -> Data {
        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/favorite/movies")!
        
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
            print(" On annonce les films favori")
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
        let decodedResponse = try decoder.decode(MoviesResponse.self, from: data)
        
        return decodedResponse.results.randomElement()?.id
    }

   
    
    func fetchMovieWatchlist() async throws -> Data {
        
        let url = URL(string: "https://api.themoviedb.org/3/account/21625706/watchlist/movies")!
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
            print("On annonce les séries dans la watchlist film")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
    
    func sendToWatchlist(movieId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "movie",
            "media_id": movieId,
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
            print("Status envoi to wL film :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête send to wl film: \(error)")
            throw error
        }
    }
    
    func deleteFromWatchlist(movieId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "movie",
            "media_id": movieId,
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
            print("Status del to wL film :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête del to wl film: \(error)")
            throw error
        }
    }
    
    func fetchRecommendations() async throws -> Data {
      
        guard let movieID = try await getRandomFavoriteID() else {
            // Lever l'erreur avec un NSError si aucun film favori n'est trouvé
            throw NSError(domain: "FilmsServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Aucun film favori disponible pour les recommandations."])
        }

        // Construction de l'URL avec l'ID du film
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/recommendations")!
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
            print("Erreur lors de la requête reco tv: \(error)")
            throw error
        }
    }
    
    func sendFavorites(movieId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "movie",
            "media_id": movieId,
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
            print("Status envoi fav film :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête send fav film: \(error)")
            throw error
        }
    }
    
    func deleteFavorites(movieId: Int ) async throws -> Data {
        
        let parameters: [String: Any?] = [
            "media_type": "movie",
            "media_id": movieId,
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
            print("Status del fav :")
            print(String(decoding: data, as: UTF8.self))
            return data
        } catch {
            print("Erreur lors de la requête send fav: \(error)")
            throw error
        }
    }
    
}






