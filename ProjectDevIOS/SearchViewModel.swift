//
//  SearchViewModel.swift
//  ProjectDevIOS
//
//  Created by tplocal on 16/11/2024.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var multis: [Multi] = []
    
    private let service = SearchService()
    
    func fetchMulti(searchQuery : String) async {
        do {
            print(" Service : Requête envoyée pour : \(searchQuery)")
            let data = try await service.fetchMulti(searchQuery: searchQuery)
            print("Réponse brute : \(String(data: data, encoding: .utf8) ?? "Pas de données")")
            
            // Décodage des données en utilisant MultiResponse
            print(" ********** On passe au décodage du JSON ***********")
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(MultiResponse.self, from: data)
            print("Réponse décodée : \(decodedResponse.results)")
            
            // Assigne les films au tableau films
            self.multis = decodedResponse.results
            print(" Est-ce qu'on a les multis ? \(self.multis)")
        } catch {
            print("Erreur de récupération des films et séries : \(error)")
        }
    }
}
