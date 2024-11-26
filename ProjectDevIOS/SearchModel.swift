//
//  SearchModel.swift
//  ProjectDevIOS
//
//  Created by tplocal on 17/11/2024.
//

import SwiftUI

struct Multi: Identifiable, Decodable {
    let id: Int
    let title: String?
    let name: String?
    let release_date: String?
    let first_air_date: String?
    let poster_path: String?
    let media_type: String?
    
    
}

extension Multi {
    func toMovie() -> Movie? {
        // Vérifie si l'objet est bien un film grâce au media_type
        guard media_type == "movie",
              let title = self.title, // Assure que le champ title est non-nil
              let releaseDate = self.release_date, // Assure que le champ release_date est non-nil
              let posterPath = self.poster_path // Assure que le champ poster_path est non-nil
        else {
            return nil
        }

        return Movie(
            id: self.id,
            title: title,
            release_date: releaseDate,
            overview: nil,
            poster_path: posterPath,
            genres: nil
            
        )
    }
}

 
// Structure pour la réponse de l'API, qui contient un tableau de films
struct MultiResponse: Decodable {
    let results: [Multi]  // Tableau des films
}
