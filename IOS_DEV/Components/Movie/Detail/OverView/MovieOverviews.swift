//
//  MovieOverview.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct GetMovieOverviews: View{
    let movie: Movie
    @StateObject private var movieImagesState = MovieImagesState()
 
    var body: some View {
        ZStack {

            LoadingView(isLoading: self.movieImagesState.isLoading, error: self.movieImagesState.error) {
                self.movieImagesState.loadMovieImage(id: movie.id)
            }
            if movieImagesState.movieImage != nil {
                MovieOverviews(movie: movie, movieImages: self.movieImagesState.movieImage!)
            }
            
        }
        .onAppear {
            self.movieImagesState.loadMovieImage(id: movie.id)
            
        }
    }
}

struct MovieOverviews:View {
    let movie: Movie
    @State private var selectedTrailer: MovieVideo?
    let imageLoader = ImageLoader()
    let movieImages: MovieImages
    
    var body:some View{
        
        VStack{
            //-----summary-----//
            VStack{
                HStack(alignment:.bottom){
                    Text("Plot Summary:")
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                //ExpandableText(movie.overview, lineLimit: 5)
                Text(movie.overview)
                    
                
                
            }
            .padding(10)
            
            VStack{
                //-----star-----//
                HStack {
                    if !movie.ratingText.isEmpty {
                        Text(movie.ratingText).foregroundColor(.yellow)
                    }
                    Text(movie.scoreText)
                }

                Spacer()

                Divider()
                    .background(Color.gray)

                //-----movie pic-----//
                VStack(spacing:10){
                    HStack(alignment:.bottom){
                        Text("Movie Capture:")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal,10)


                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack(){
                            ForEach(self.movieImages.backdrops,id: \.filePath){ backdrop in
                                WebImage(url: backdrop.MovieImageURL)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                                    
//                                MovieDetailImage(imageLoader: imageLoader, imageURL: backdrop.MovieImageURL)
//                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            .padding(.all, 5.0)
                            
                        }

                    }.frame(height: 250)

                }

                Spacer()

                Divider()
                    .background(Color.gray)
                
                //-----cast-----//

                VStack(spacing:10){
                    HStack(alignment:.bottom){
                        Text("Movie Cast:")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal,10)
                    
                  
                    ActorAvatarList(cast: movie.cast!)

                }

                Spacer(minLength: 80)
             
                
            }
           
            
        }
    }
}



//MARK: FROM https://prafullkumar77.medium.com/swiftui-how-to-make-see-more-see-less-style-button-at-the-end-of-text-675f859c2c4f
struct ExpandableText: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    var expandedStr : String
    var lessStr : String
    var fontColor : Color
    var text: String
    let lineLimit: Int

    init(expandedStr : String = "more",lessStr:String = "less",fontColor : Color = .white,_ text: String, lineLimit: Int) {
        self.expandedStr = expandedStr
        self.lessStr = lessStr
        self.fontColor = fontColor
        self.text = text
        self.lineLimit = lineLimit
    }

    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? lessStr : expandedStr
        }
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing:5) {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
                .background(
                    Text(text).lineLimit(lineLimit)
                        .background(GeometryReader { visibleTextGeometry in
                            ZStack { //large size zstack to contain any size of text
                                Text(text)
                                    .background(GeometryReader { fullTextGeometry in
                                        Color.clear.onAppear {
                                            self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                        }
                                    })
                                    
                            }
                            .frame(height: .greatestFiniteMagnitude)
                           
                        })
                        .hidden() //keep hidden
            )
            if truncated {
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }){
                    Text(moreLessText)
                        .font(.body)
                        .foregroundColor(.white)
                        
                }
            }
        }
            .foregroundColor(fontColor)
    }
}



//
//struct ActorList: View {
//    let name: String
//    let person: [Person]
//    @ObservedObject private var personSearchState = PersonSearchState()
// 
//    var body: some View {
//        ZStack {
//            LoadingView(isLoading: self.personSearchState.isLoading, error: self.personSearchState.error) {
//                self.personSearchState.searchPerson(query: name)
//            }
//
//            if personSearchState.person != nil {
//                ActorAvatarList(actorList: personSearchState.person!)
//            }
//
//        }
//        .onAppear {
//            self.personSearchState.searchPerson(query: name)
//        }
//
//    }
//}

