//
//  SearchService.swift
//  ProjectDevIOS
//
//  Created by tplocal on 16/11/2024.
//

import Foundation

class SearchService {
    
    // Ajoutez votre clé d'API ici
    private let apiKey = "afdee77229b2277bd524ead2bd3c3b6c"
    
    func fetchMulti(searchQuery: String) async throws -> Data {
        
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "Requête vide", code: 400, userInfo: nil)
        }
        
        let url = URL(string: "https://api.themoviedb.org/3/search/multi")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),  // Utilisez l'API Key ici
            URLQueryItem(name: "query", value: searchQuery),  // Ajout du paramètre de recherche
            URLQueryItem(name: "include_adult", value: "false"),
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
            print(" On annonce les résultats")
            print(String(decoding: data, as: UTF8.self)) // Debug pour vérifier la réponse JSON
            return data
        } catch {
            print("Erreur lors de la requête : \(error)")
            throw error
        }
    }
}

