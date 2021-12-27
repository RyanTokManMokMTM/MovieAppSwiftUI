//
//  SmaillCoverIcon.swift
//  IOS_DEV
//
//  Created by Jackson on 5/5/2021.
//

import SwiftUI
import SDWebImageSwiftUI




struct SmallCoverIcon: View {
    @State var Animating:Bool = false
    var posterPath : String
    var foreverAnimation: Animation {
        Animation.linear(duration: 10)
            .repeatForever(autoreverses: false)
    }
    var body: some View {
        
        ZStack{
//            Circle()
//
//                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                .foregroundColor(Color.init("navBarBlack").opacity(0.5))
//                .blur(radius: 0.5)
            
            CenterIcon(isAnimating: Animating,posterPath: posterPath)
        }
        .animation(self.foreverAnimation)
        .onAppear{
            self.Animating = true
            
        }

    }
    
}

struct CenterIcon:View{
    var isAnimating : Bool
    var posterPath : String
    var body: some View{
        ZStack{
//            CircleText(radius: 65, text: "Movie Information",kerning: 8.0,width: 65,height: 65)
//                .animation(.none)
//                .rotationEffect(Angle(degrees: self.isAnimating ? -360.0 : 0.0))
            Circle()
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 45, height: 45)
                .animation(.none)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                AnimatedImage(url:URL(string: "https://image.tmdb.org/t/p/original\(posterPath)"))
                    //   Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 1)
                            .foregroundColor(.purple)
                    )
                    .frame(width: 30, height: 30)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
        }
        
    }
}




//struct SmaillCoverIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack{
//            Color.black.edgesIgnoringSafeArea(.all)
//
//            SmallCoverIcon()
//        }
//
//
//    }
//}

