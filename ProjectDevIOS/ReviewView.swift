import SwiftUI

struct ReviewView: View {
    let review: Review
    @State private var showFullText = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Avatar et Informations de l'auteur
            HStack {
                if let avatarPath = review.author_details.avatar_path,
                   let url = URL(string: "https://image.tmdb.org/t/p/w200\(avatarPath)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.author_details.name.isEmpty ? review.author : review.author_details.name)
                        .font(.headline)
                    if let rating = review.author_details.rating {
                        Text("Rating: \(rating)/10")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Contenu avec limitation de mots
            Text(htmlToString(html: review.content, limit: showFullText ? nil : 20))
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(showFullText ? nil : 4) // 4 lignes visibles par défaut
                .padding(.top, 8)
            
            // Bouton "Voir plus"
            if review.content.split(separator: " ").count > 20 {
                Button(showFullText ? "Voir moins" : "Voir plus") {
                    withAnimation {
                        showFullText.toggle()
                    }
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
    
    // Fonction pour parser le HTML
    func htmlToString(html: String, limit: Int?) -> String {
        guard let data = html.data(using: .utf8) else { return html }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        let plainString = attributedString?.string ?? html
        
        if let limit = limit, plainString.split(separator: " ").count > limit {
            let truncated = plainString.split(separator: " ").prefix(limit).joined(separator: " ")
            return "\(truncated)..."
        }
        
        return plainString
    }
}
