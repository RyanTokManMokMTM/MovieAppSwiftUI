//
//  Genre.swift
//  IOS_DEV
//
//  Created by Jackson on 30/4/2021.
//

import SwiftUI


struct Genre: View {
    var Genres:[MovieGenre]
    
    var body: some View {
        
        HStack(spacing:5){
            ForEach(Genres,id:\.name){genre in
                Text(genre.name)
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(Color.white)
                    .padding(.horizontal,8)
                    .padding(.vertical,5)
                    .background(Color.gray.opacity(0.45))
                    .cornerRadius(5)

            }
            Spacer()
        }

    }
}

//struct Genre_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack{
//            Color.black.edgesIgnoringSafeArea(.all)
//            Genre(Genres: [.Action,.Adventure])
//        }
//    }
//}

//
//enum GenresType : String {
//    case Action = "Action"
//    case Adventure = "Adventure"
//    case Animation = "Animation"
//    case Comedy = "Comedy"
//    case Crime = "Crime"
//    case Documentary = "Documentary"
//    case Drama = "Drama"
//    case Family = "Family"
//    case Fantasy = "Fantasy"
//    case History = "History"
//    case Horror = "Horror"
//    case Music = "Music"
//    case Mystery = "Mystery"
//    case Romance = "Romance"
//    case ScienceFiction = "Science Fiction"
//    case TVMovie = "TV Movie"
//    case Thriller = "Thriller"
//    case War = "War"
//    case Western = "Western"
//}
//
