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
    let endpoint : MovieListEndpoint
    @EnvironmentObject var State : MovieListState
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel

    @State private var isCardSelectedMovie:Bool = false
    @State private var isAction : Bool = false
    @State private var selectedMovieID : Int = -1
    
    @State private var isShowAll : Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text(title)
                    .font(.system(size: 18,weight:.semibold))
                    .padding(.horizontal,8)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action:{
                    withAnimation{
                        isShowAll.toggle()
                    }
                }){
                    Text("顯示全部")
                        .font(.system(size: 14,weight: .semibold))
                        .foregroundColor(Color(uiColor: UIColor.darkGray))
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal,5)
            
            if self.State.movies == nil {
                Text("暫時沒有任何**\(title)**相關電影資訊.")
            }else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(0..<(self.State.movies!.count < 10 ? self.State.movies!.count : 10),id:\.self) { i in
                            Button(action:{
                                self.selectedMovieID = self.State.movies![i].id
                                self.isAction.toggle()
                            }){
                                MoviePosterCard(movie: self.State.movies![i])
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .background(
           
                    NavigationLink(destination:
                                    MovieDetailView(movieId: self.selectedMovieID, isShowDetail: $isAction)
                                    .environmentObject(postVM)
                                    .environmentObject(userVM)
                                   ,isActive:$isAction
                                  ){EmptyView()}
                )
                .background(
                
                    NavigationLink(destination:
                                    ShowMoreStateMovieView(endPoint: endpoint, stateTitle: title, isShowAll: self.$isShowAll)
                                    .environmentObject(postVM)
                                    .environmentObject(userVM)
                                    .environmentObject(State)
                                    ,isActive: self.$isShowAll
                                  ){EmptyView()}
                
                )
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
