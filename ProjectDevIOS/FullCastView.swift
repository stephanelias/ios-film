//
//  FullCastView.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 25/11/2024.
//

import Foundation
import SwiftUI
 
struct FullCastView: View {
    let actors: [Actor]
 
    // Configuration de la grille : 2 colonnes
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
 
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Full Cast")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
 
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(actors, id: \.id) { actor in
                        ActorCardView(actor: actor)
                            .frame(height: 250) // Ajuste la hauteur de la carte
                            .padding(.all)
                    }
                }
                .padding(.all)
            }
        }
        .navigationTitle("Cast")
    }
}
