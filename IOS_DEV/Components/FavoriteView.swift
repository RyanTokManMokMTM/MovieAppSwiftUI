//
//  FavoriteView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/10/28.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct movieRecord: View {
    
    var columns = Array(repeating: GridItem(.flexible(),spacing:20), count: 2)
    let movies : [LikeMovie]
      
    var body: some View{
        
        LazyVGrid(columns: columns, spacing: 20){
            ForEach(movies, id:\.id){ movie in
                
                NavigationLink(destination: MovieDetailView(movieId: movie.movie, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true))){
                    WebImage(url: movie.posterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }
               
            }
            
           
        }
    }
}


struct articleRecord: View {
    
    let articles : [LikeArticle]
    var columns = Array(repeating: GridItem(.flexible(),spacing:5), count: 2)
    @ObservedObject private var userController = UserController()
      
    var body: some View{
        
        
        LazyVGrid(columns: columns, spacing: 10){
            
            ForEach(articles, id:\.like_id){ data in
                
                let article = Article(id: data.article_id,
                                      Title: data.article_title,
                                      Text: data.article_text,
                                      user: Owner(id: data.user_id, UserName: data.user_name, UserPhoto: data.user_avatar),
                                      movie: data.movie_id,
                                      LikeCount: data.article_like_count,
                                      updatedOn: data.article_last_update)
                
                NavigationLink(destination:GetMessageBoardView(article: article)){
                    
                    VStack(alignment:.leading){
                        HStack(){
                            WebImage(url:data.user_avatarURL)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(30)
                                .padding(.leading,5)
                           
                            
                            Text(data.user_name)
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                        }
                        .padding(.top,15)
                        
                        
                        VStack{
                            Text(data.article_title)
                                .bold()
                                .font(.system(size: 16))
                                .padding(5)
                            
                            Text(data.article_text)
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                                .padding(5)
                        }
                        .padding(7)
                       
                                
                        
                        Spacer()
                        
                        
                    }
                    .frame(width:170,height: 170)
                    .background(BlurView().cornerRadius(25))
                    .shadow(color: .gray, radius: 0.5)
                    .foregroundColor(.white)
                    .padding(10)
                    .cornerRadius(20)
                    
                }
                
                    
                    
            
               

                
            }
        }
    }
}
