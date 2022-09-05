//
//  GestureDetailVeiw.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

//
//struct GestureDetailVeiw: View {
//
//    let movieId: Int
//    @ObservedObject private var movieDetailState = MovieDetailState()
//    @ObservedObject private var listController = ListController()
//    @ObservedObject private var favoriteController = FavoriteController()
//    @Binding var navBarHidden:Bool
//    @Binding var isAction : Bool
//    @Binding var isLoading : Bool
//    @Binding var isPresented : Bool
//    @State var isMyFavorite = false
//    @State private var todo : Bool = false
//    
//    var body: some View {
//        ZStack {
//            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
//                self.movieDetailState.loadMovie(id: self.movieId)
//            }
//
//            if movieDetailState.movie != nil && self.todo == true {
//                
//                GestureDetail(movie: self.movieDetailState.movie!, navBarHidden: $navBarHidden, isAction: $isAction, isLoading: $isLoading, isPresented:$isPresented,myMovieList:listController.mylistData,isMyFavorite:isMyFavorite)
//
//            }
//        }
//        .onAppear {
//            self.movieDetailState.loadMovie(id: self.movieId)
//            self.listController.GetMyList(userID: NowUserID!)
//            self.favoriteController.CheckLikeMovie(movieID: movieId)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                if !self.favoriteController.favorite.isEmpty {
//                    self.isMyFavorite = true
//                }
//                self.todo = true
//            })
//        }
//    }
//}
//
//
//struct GestureDetail: View {
//   
//    let movie: Movie
//    //MOVIE URL
//    @State private var size = 0.0
//    @State private var opacity = 0.0
//    @State private var showMovieName = false
//    @State private var showAnimation = false
//    @Binding var navBarHidden:Bool
//    @Binding var isAction : Bool
//    @Binding var isLoading : Bool
//    @Binding var isPresented : Bool
//    @State private var isAppear:Bool = false
//    @State var myMovieList : [CustomList]
//    @State var isMyFavorite : Bool
//    
//    //     var edge = UIApplication.shared.windows.first?.safeAreaInsets
//    var body: some View {
//        
//        NavigationView{
//            ZStack(alignment:Alignment(horizontal: .center, vertical: .top)){
//                
//                ScrollView(.vertical, showsIndicators: false){
//                    
//
//                    
//                    GeometryReader{ proxy in
//                        if proxy.frame(in:.global).minY > -480{
//                            movieImage(imgURL: movie.posterURL)
//                                .offset(y:-proxy.frame(in:.global).minY)
//                                .frame(width: isAppear ?  0: proxy.frame(in:.global).maxX, height:
//                                       isAppear ? 0 :proxy.frame(in:.global).minY  > 0 ?
//                                        proxy.frame(in:.global).minY + 480 : 480   )
//                                
//                                .opacity((Double(proxy.frame(in:.global).minY * 0.0045 + 1)) < 0.45 ? 0.45 :(Double(proxy.frame(in:.global).minY * 0.0045 + 1)))
//                                .blur(radius: CGFloat((Double(proxy.frame(in:.global).minY * 0.005 + 1)) < 0.45  ? (Double(proxy.frame(in:.global).minY) * -1 * 0.03) : 0))
//                                .onChange(of: proxy.frame(in:.global).minY, perform: { value in
//                                    
//
//                                })
//                            
//                        }
//                        
//                      //--------------返回鍵-------------//
//                        Button(action:{
//                            withAnimation(){
//                                self.isPresented.toggle()
//                            }
//
//                        }){
//                            ZStack{
//                                Circle()
//                                    .frame(width:30,height:30)
//                                    .opacity(0.5)
//                                Image(systemName: "xmark")
//                                    .foregroundColor(.white)
//                            }
//                            .foregroundColor(.black)
//
//                        }
//                        .position(x: proxy.frame(in: .local).maxX - 40
//                                  , y: proxy.frame(in: .local).minY + 60)
//
//
//                         
//
//                        
//                    }
//                    .frame(height: 510)
//                    .animation(.spring(),value:showAnimation)
//                   
//                   
//                    
//                    MovieInfoDetail(myMovieList:myMovieList , movie: movie, isMyFavorite: isMyFavorite)
////                        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//
//                    
//                }
//                .foregroundColor(.white)
//                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
//                .background(Color.init("navBarBlack").edgesIgnoringSafeArea(.all))
//                
// 
//
//
//                
//                
//            }
//            .edgesIgnoringSafeArea(.all)
//            .frame(height:UIScreen.main.bounds.height)
//            .navigationBarHidden(true)
//            .padding(.horizontal,10)
//            .onAppear{
//                isAppear = false
//                loading()
//    //            withAnimation(){
//    //                self.navBarHidden = false
//    //            }
//    //            UIScrollView.appearance().bounces = true
//                
//            }
//            .onDisappear{
//    //            withAnimation(){
//    //                self.navBarHidden = true
//    //            }
//                self.isLoading = true
//                print("XD")
//    //            UIScrollView.appearance().bounces = false
//            }
//        }
//        
//        
//    }
//    
//    func loading(){
//        DispatchQueue.main.asyncAfter(deadline:.now() + 1.25){
//            self.isLoading = false
//        }
//    }
//}
