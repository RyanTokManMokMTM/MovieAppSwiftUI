//
//  MoviePosterCarousel.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//

import Foundation
import SwiftUI

struct MoviePosterCarousel: View {
    
    let title: String
    @EnvironmentObject var State : MovieListState
    @State private var isCardSelectedMovie:Bool = false
    @State private var isAction : Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text(title)
                    .font(.system(size: 18,weight:.semibold))
                    .padding(.horizontal,8)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action:{
                    print("View More\(title) movies")
                }){
                    Text("顯示更多")
                        .font(.system(size: 14,weight: .semibold))
                        .foregroundColor(Color(uiColor: UIColor.darkGray))
                }.buttonStyle(PlainButtonStyle())
            }
            
            if self.State.movies == nil {
                Text("暫時沒有任何**\(title)**相關電影資訊.")
            }else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(0..<self.State.movies!.count) { i in
                            NavigationLink(destination:
                                            MovieDetailView(movieId: self.State.movies![i].id, isShowDetail: $isAction)
//                                            .navigationBarTitle("")
//                                            .navigationBarHidden(true)
//                                            .navigationTitle("")
//                                            .navigationBarBackButtonHidden(true)
                                           ,isActive:$isAction
                            ) {
                                MoviePosterCard(movie: self.State.movies![i])
                 
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
          
        }
        
    }
}
//
//struct MoviePosterCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            MoviePosterCarousel(title: "Now Playing", movies: stubbedMovie)
//        }
//    }
//}
