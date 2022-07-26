//
//  CardScrollingView.swift
//  IOS_DEV
//
//  Created by Jackson on 3/7/2022.
//

import SwiftUI

struct CardScrollingView: View {
    @StateObject var actionVM = GenreTypeState(genreType: .Action)
    @StateObject var animationVM = GenreTypeState(genreType: .Animation)
    @StateObject var adventureVM = GenreTypeState(genreType: .Adventure)
    @StateObject var comedyVM = GenreTypeState(genreType: .Comedy)
    @StateObject var crimeVM = GenreTypeState(genreType: .Crime)
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {

                //one
                Group {
                    if actionVM.isLoading && actionVM.genreMovies.count <= 0{
                        LoadingView(isLoading: self.actionVM.isLoading, error: self.actionVM.error) {
                            self.actionVM.getGenreCard()
                        }
                    }else if !actionVM.isLoading {
                        MovieCardCarousel(genreID:GenreType.Action.rawValue)
                            .environmentObject(actionVM)
                    }
                    
                }
                
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                
                //two
                Group {
                    if animationVM.isLoading && animationVM.genreMovies.count <= 0{
                        LoadingView(isLoading: self.animationVM.isLoading, error: self.animationVM.error) {
                            self.animationVM.getGenreCard()
                        }
                    }else if !actionVM.isLoading {
                        MovieCardCarousel(genreID:GenreType.Animation.rawValue)
                            .environmentObject(animationVM)
                        
                    }
                    
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                
                //three
                Group {
                    
                    if adventureVM.isLoading && adventureVM.genreMovies.count <= 0{
                        LoadingView(isLoading: self.adventureVM.isLoading, error: self.adventureVM.error) {
                            self.adventureVM.getGenreCard()
                        }
                    }else if !adventureVM.isLoading {
                        MovieCardCarousel(genreID:GenreType.Adventure.rawValue)
                            .environmentObject(adventureVM)
                        
                    }
                    
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                
                //four
                Group {
                    if comedyVM.isLoading && comedyVM.genreMovies.count <= 0{
                        LoadingView(isLoading: self.comedyVM.isLoading, error: self.comedyVM.error) {
                            self.comedyVM.getGenreCard()
                        }
                    }else if !comedyVM.isLoading {
                        MovieCardCarousel(genreID:GenreType.Comedy.rawValue)
                            .environmentObject(comedyVM)
                        
                    }
                    
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                
                //five
                Group {
                    
                    if crimeVM.isLoading && crimeVM.genreMovies.count <= 0{
                        LoadingView(isLoading: self.crimeVM.isLoading, error: self.crimeVM.error) {
                            self.crimeVM.getGenreCard()
                        }
                    }else if !crimeVM.isLoading {
                        MovieCardCarousel(genreID:GenreType.Crime.rawValue)
                            .environmentObject(crimeVM)
                        
                    }
                    
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                
    
            
        }//scrollview

    }
}

struct CardScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        CardScrollingView()
    }
}
