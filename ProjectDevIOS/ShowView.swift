//
//  ShowView.swift
//  ProjectDevIOS
//
//  Created by Stéphane Elias on 12/11/2024.
//

import SwiftUI

struct ShowView: View {
    
    @StateObject private var showViewModel = ShowViewModel()
    
    var tvWatchlist : [Show] {
        print("****test*****")
        print(showViewModel.watchlist)
        return showViewModel.watchlist
    }
    
    var body: some View {
        VStack {
            Text("Séries à regarder")
            ScrollView(Axis.Set.horizontal) {
                HStack {
                    ForEach(tvWatchlist, id: \.id) { show in
                        VStack {
                            Text(show.name!)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .task {
                    await showViewModel.fetchTVWatchlist()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ShowView()
}
