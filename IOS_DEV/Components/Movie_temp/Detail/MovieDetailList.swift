//
//  MovieDetailView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/7.
//


import SwiftUI
import SafariServices


struct MovieDetailList: View {
    
    let movie: Movie
    @State private var selectedTrailer: MovieVideo?
    let imageLoader = ImageLoader()
    
    var tabs:[Tabs]
    @State private var currentTab:Tabs = .overView
    
    func getStrWidth(_ font:Tabs)->CGFloat{
        //get current string size
        let current = font.rawValue //get enum value
        return current.widthOfStr(Font: .systemFont(ofSize: 16,weight: .bold))
    }
    
    var body: some View {
        VStack(spacing:5) {
            ScrollView(.vertical, showsIndicators: false){
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing:10){
                        ForEach(tabs,id:\.self){tab in
                            VStack{
                                Button(action: {
                                    withAnimation(.easeInOut){
                                        currentTab = tab
                                    }
                                }){
                                    Text(tab.rawValue)
                                        .font(.system(size: 16))
                                        .bold()
                                        .foregroundColor(currentTab == tab ? Color.white : Color.gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width:getStrWidth(tab),height:50)
                                
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .frame(width:getStrWidth(tab),height: 6)
                                    .foregroundColor(currentTab == tab ? Color.red : Color.clear)
                                    .offset(y:-10)
                                    
                            }
                            
                        }
                    }
                }
                
                switch currentTab{
                case .overView:
                    GetMovieOverviews(movie: movie)
                case .trailer:
                    GetMovieTrailer(movieId: movie.id)
                case .more:
                    MoreMovieView() //in progress
                case .resources:
                    MovieOTT(movieTitle: movie.title)
             //   case .info:
                 //   MovieInfoView(data: tempData)

                }

            
           Spacer()
        }
        .foregroundColor(.gray)
//        .frame(height: 50)
        }
    }
    
   
}

enum Tabs : String{
    case overView = "OVERVIEW"
    case trailer = "TRAILER & MORE"
    case more = "MORE MOVIE"
    case resources = "MOVIE RESOURCE"
}


struct MovieDetailList_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            MovieDetailList(movie: stubbedMovie[0], tabs: [.overView,.trailer,.more,.resources])
                .preferredColorScheme(.dark)
        }
    }
}


