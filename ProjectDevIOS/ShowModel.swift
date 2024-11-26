//
//  ShowModel.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 21/11/2024.
//

import Foundation

struct Show: Identifiable, Decodable {
    let id: Int?
    let name: String?
    let first_air_date: String?
    let number_of_episodes: Int?
    let number_of_seasons: Int?
    let overview: String?
    let poster_path: String?
    let genres: [Genre]?
    
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}
 
// Structure pour la réponse de l'API, qui contient un tableau de films
struct ShowsResponse: Decodable {
    let results: [Show]  // Tableau des films
}
 
struct ShowRecommendation: Identifiable, Decodable {
    let id: Int
    let name: String
    let first_air_date: String
    let overview: String
    let poster_path: String?
    let media_type: String
}
 
struct ShowRecommendationResponse: Decodable {
    let results: [ShowRecommendation]
}
