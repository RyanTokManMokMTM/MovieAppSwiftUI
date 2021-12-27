
//  MovieScrollList.swift
//  IOS_DEV
//
//  Created by Jackson on 17/5/2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct MovieScrollList: View {
    var listTitle:String
    var MovieList:[moviesTemp]
    var body: some View {
        VStack(alignment:.leading,spacing:8){
            Text(listTitle)
                .bold()
                .font(.title2)
                .padding(.horizontal,8)
                .foregroundColor(.red)
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack{
                    ForEach(0..<MovieList.count){index in
                        MovieCoverCardItem(Movie: MovieList[index])
                        
                    }
                }
            }
            .frame(height:280)
            
        }
     
    }
}

struct MovieScrollList_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.init("ThemeBackGroundColor").edgesIgnoringSafeArea(.all)
            //  MovieScrollList(MovieList: coverList)
            MovieScrollList(listTitle: "Upcomming",MovieList: coverList)
            
        }
    }
}

struct MovieCoverCardItem:View{
    var Movie:moviesTemp
    var body: some View{
        VStack(alignment:.center,spacing:8){
            CoverCard(url:Movie.movieCoverURL)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.pink, lineWidth: 1)
                )
                .frame(width:145)
                .padding(.horizontal,8)
                .shadow(color: Color.secondary, radius: 2, x: 0, y: 0 )

            
            Text(Movie.movieName)
                .bold()
                .font(.footnote)
                .foregroundColor(.purple)
                .frame(width:150,height:30)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            HStack{
                ForEach(0..<5){_ in
                    Image(systemName: "star.fill")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 12, height: 12, alignment: .center)
                        
                }
            }
            
        }
        .padding(.horizontal,5)
    }
    
}
