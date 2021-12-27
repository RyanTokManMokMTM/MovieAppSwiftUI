//
//  ActorMovieView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/21.
//


import SwiftUI
import SDWebImageSwiftUI

struct ActorMovieView: View{
//    @ObservedObject var genreTypeState = GenreTypeState()
    var actor:[Person]
    @State private var isCardSelectedMovie:Bool = false
   
    
   var body: some View
   {
        VStack{
            Text(actor[0].name)
                .bold()
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding(10)
        }
        
       
    
    
       ScrollView(.horizontal, showsIndicators: false)
       {

           HStack(spacing: 30)
           {
    
                ForEach(actor[0].knownFor, id:\.id){ movie in
                    CarouselView(movie: movie)
                }
       
           } //hstack
           .padding(.vertical,50)
           .padding(.horizontal,28)
           .padding(.top,50)


           }//scrollview
           .frame(height:600)
       
   }
    

    
    
}


struct CarouselView: View{
//    @ObservedObject var genreTypeState = GenreTypeState()
    var movie: knownFor
    @State private var isCardSelectedMovie:Bool = false
    private func getScale(geo : GeometryProxy)->CGFloat{
       var scale:CGFloat = 1.0
       let x = geo.frame(in: .global).minX
       
       let newScale = abs(x)
       if newScale < 100{
           scale = 1 + (100 - newScale) / 500
       }
       
       return scale
   }
   
    
   var body: some View
   {
            VStack{
                GeometryReader { proxy in
                    let scaleValue = getScale(geo: proxy)
                    
                        
                    ActorMovieCard(movie: movie)
                               .rotation3DEffect(Angle(degrees:Double(proxy.frame(in: .global).minX - 30)  / -20), axis: (x: 0, y: 20.0, z: 0))
                               .scaleEffect(CGSize(width: scaleValue, height: scaleValue))
//                           .onTapGesture {
//                                   withAnimation(){
//                                       self.isCardSelectedMovie.toggle()
//                                   }
//                               }
//                           .fullScreenCover(isPresented: $isCardSelectedMovie, content: {
//                               MovieCardGesture(movies: movies,currentMovie: movies.last, backHomePage: $isCardSelectedMovie)
//                           })

               }
                .frame(width: 275)
            }

   }
}

struct ActorMovieCard: View {
    let movie: knownFor
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
      
        VStack(spacing:10){
            
            
            //----------movie poster----------//
            if movie.posterURL.description != "" {
            
                WebImage(url: movie.posterURL)
                    .resizable()
                    .frame(width: 250, height: 340)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }
            else{
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .frame(width: 250, height: 340, alignment: .center)
                
                Text(movie.title!)
                    .multilineTextAlignment(.center)
                    
            }
            
            //----------movie name----------//
            if movie.title != nil {
                
                Text(movie.title!)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .font(.system(size: 20))
                    .padding(20)
    
            }
            else{
                
                Text(movie.name!)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .font(.system(size: 20))
                    .padding(20)
            }
            
            

            
        }
        .frame(width:300)
        .multilineTextAlignment(.center)
                
          
        
        
    }
}

//struct ResultView_Previews: PreviewProvider
//{
//   static var previews: some View
//   {
//        ActorMovieView(movies: stubbedMovie)
//                  .preferredColorScheme(.dark)
//
//   }
//}


