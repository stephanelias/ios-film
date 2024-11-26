//
//  FilmModel.swift
//  ProjectDevIOS
//
//  Created by tplocal on 12/11/2024.
//

import SwiftUI

struct Movie: Identifiable, Decodable {
    let id: Int?
    let title: String?
    let release_date: String?
    let overview: String?
    let poster_path: String?
    let genres: [Genre]?
    
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
    
    // Exemple fictif pour le preview
        static let example = Movie(
            id: 912649,
            title: "Venom: The Last Dance",
            release_date: "2024-10-22",
            overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision...",
            poster_path: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg",
            genres: [
                Genre(id: 878, name: "Science Fiction"),
                Genre(id: 28, name: "Action"),
                Genre(id: 12, name: "Adventure")
            ]
        )
}
 
// Structure pour la réponse de l'API, qui contient un tableau de films
struct MoviesResponse: Decodable {
    let results: [Movie]  // Tableau des films
}
 
 
struct Actor: Identifiable, Decodable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
    let known_for_department: String
}
 
struct CastResponse: Decodable {
    let cast: [Actor]  // Tableau des acteurs
}
 
struct Review: Identifiable, Decodable {
    let id: Int
    let content: String
    let author: String
    let author_details: AuthorDetails
}
 
struct ReviewResponse: Decodable {
    let results: [Review]
}
 
struct AuthorDetails: Decodable {
    let name: String
    let username: String
    let avatar_path: String?
    let rating: Int?
}
 
    
struct MovieRecommendation: Identifiable, Decodable {
    let id: Int
    let title: String
    let release_date: String
    let overview: String
    let poster_path: String?
    let media_type: String
}
 
struct RecommandationResponse: Decodable {
    let results: [MovieRecommendation]
}
