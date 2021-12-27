//
//  MovieCoverGesture.swift
//  IOS_DEV
//
//  Created by Jackson on 19/5/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation

//struct MovieCoverGesture: View {
//
//    enum CardGestureState {
//        case inactive //doing nothing
//        case pressing //pressing the image only
//        case dragging(translation:CGSize,predictEndLocation:CGPoint)
//        
//        //getting dragging translation
//        var translation:CGSize{
//            switch self {
//            case .inactive,.pressing:
//                return .zero
//            case .dragging(let translation,_):
//                return translation
//            }
//        }
//        
//        //location to end
//        var predictEndLocation:CGPoint{
//            switch self {
//            case .inactive,.pressing:
//                return .zero
//            case .dragging(_, let predictEndlocation):
//                return predictEndlocation
//            }
//        }
//        
//        var isActive:Bool{
//            switch self {
//            case .inactive:
//                return false
//            default:
//                return true
//            }
//        }
//        
//        var isDragging:Bool{
//            switch self {
//            case .inactive,.pressing:
//                return false
//            default:
//                return true
//            }
//        }
//        
//    }
//    
//    enum EndTranslationPostion{
//        case left,right,cancle
//    }
//    
//    @Binding var DragState:CardGestureState //let parent know what is current state
//    var onTapGesture:()->Void
//    var willEndTranslation : (CGSize)->Void //geting current Translation postion
//    var EndTranslation:(EndTranslationPostion)->Void //getting the state to end
//
//    @GestureState private var gestureState:CardGestureState = .inactive //default is inactive
//    @State private var hasMove = false
//    @State private var predictEndLocation:CGPoint? = nil
//    var movieCoverURL:String
//    var body: some View {
//        //concate 2 Gesture to Create a new Gesture
//        //in this case longPrssingGesture + GragGresture
//        let longPressGesture = LongPressGesture(minimumDuration: 0.0)
//            .sequenced(before: DragGesture())
//            .updating($gestureState){(value,state,transtition) in
//                switch value{
//                case .first(true): //the gesture is end?? ture = end,else false,in this case,is done
//                    self.feedBack.prepare()
//                    state = .pressing
//                case .second(true, let drag):
//                    state = .dragging(translation: drag?.translation ?? .zero, predictEndLocation: drag?.predictedEndLocation ?? .zero)
//                default :
//                    state = .inactive
//                }
//            }
//            .onChanged{ (value) in
//                //TODO:
//                //Check current translation is zero??(jsut pressing not dragging) or other
//                if self.gestureState.translation.width == 0.0{
//                    self.DragState = .pressing
//                    self.hasMove = false
//                }
//                else{
//                    //set binding value to dragging and given the value of translatrion and end location value
//                   // print("translation:\(self.gestureState.translation)")
//                  //  print("endLocation:\(self.gestureState.predictEndLocation)")
//                    self.DragState = .dragging(translation: self.gestureState.translation, predictEndLocation: self.gestureState.predictEndLocation)
//                    self.hasMove = true
//                }
//            }
//            .onEnded{ (value) in
//                //because binding value is now up to date
//                //when user on release-> trigger
//                
//                let endLocation = self.DragState.predictEndLocation
//                
//                if endLocation.x < -150{
//                    self.willEndTranslation(self.gestureState.translation)
//                    self.predictEndLocation = endLocation
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                        self.EndTranslation(.left)
//                    }
//                    print("left")
//                }
//                else if endLocation.x > UIScreen.main.bounds.width - 50{
//                    self.willEndTranslation(self.gestureState.translation)
//                    self.predictEndLocation = endLocation
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                        self.EndTranslation(.right)
//                    }
//                    print("right")
//                }
//                else{
//                   // self.willEndTranslation
//                    self.EndTranslation(.cancle)
//                    print("cancle")
//                }
//                self.DragState = .inactive
//               
//            }
//            
//        
//       return CoverCard(url: movieCoverURL)
//        .frame(width:245)
//        .offset(self.calculateOffset())
//        .scaleEffect(self.gestureState.isActive ? 1.03 : 1)
//        .rotationEffect(self.calculateAngle())
//        .opacity(self.predictEndLocation != nil ? 0 : 1)
//        .shadow(color: .secondary, radius: self.gestureState.isActive ? 16 : 0, x: self.gestureState.isActive ? 4 : 0, y: self.gestureState.isActive ? 4 : 0)
//        .animation(.interpolatingSpring(mass: 1, stiffness: 150, damping: 15, initialVelocity: 5))
//        .gesture(longPressGesture)
//        .simultaneousGesture(TapGesture(count: 1).onEnded({_ in
//            if !self.hasMove{
//                self.onTapGesture()
//            }
//        }))
//        .onTapGesture {
//            //Given a feed back
//            self.feedBack.prepare()
//        }
//        
//            
//    }
//    
//    let feedBack = UISelectionFeedbackGenerator()
//    
//    func calculateOffset() -> CGSize{
//        if let endLocation = self.predictEndLocation{
//            return CGSize(width: endLocation.x, height: 0)
//        }
//        return CGSize(width: self.gestureState.isActive ? self.gestureState.translation.width : 0, height: 0)
//    }
//    
//    func calculateAngle()->Angle{
//        if let endLocation = self.predictEndLocation{
//            return Angle(degrees: Double(endLocation.x) / 15)
//        }
//        return Angle(degrees: Double(self.gestureState.isDragging ? self.gestureState.translation.width / 15 : 0))
//    }
//}

//struct MovieCoverGesture_Previews: PreviewProvider {
//    static var previews: some View {
////        MovieCoverGesture(
////            DragState: .constant(.inactive),
////            onTapGesture:{},
////            willEndTranslation: {_ in},
////            EndTranslation: {_ in},
////            movieCoverURL: "https://image.tmdb.org/t/p/original/rEm96ib0sPiZBADNKBHKBv5bve9.jpg")
//
//
//        MovieCoverStackRemovablePreview(movies: coverList, backHomePage: .constant(false))
//      //  MovieImageLoader(urlPath: "https://image.tmdb.org/t/p/original/tmghT8HaddVIS9hEXIOI9GuDchi.jpg")
//    }
//}
//
//struct MovieCoverStackRemovablePreview :View{
//    @State var movies : [moviesTemp] = coverList//allow as to remove
//    @State private var currentMovie:moviesTemp? = coverList.last
//    @State var gestureState = MovieCoverGesture.CardGestureState.inactive
//    @Binding var backHomePage:Bool
//    var body: some View {
//        ZStack(){
//            ForEach(movies){movie in
//                if self.movies.reversed().firstIndex(where: {$0.id == movie.id}) == 0{
//                    //render the current item as CoverGesture view
//                    MovieCoverGesture(
//                        DragState: self.$gestureState,
//                        onTapGesture: {},
//                        willEndTranslation: {(translation) in},
//                        EndTranslation: {(direction) in
//                            self.getEndPostion(direction: direction)
//                        }, movieCoverURL: movie.movieCoverURL)
//
//
//                }else{
//                    CoverCard(url: movie.movieCoverURL)
//                        .frame(width:245)
//                        .scaleEffect( 1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movie.id})!) * 0.03 + self.calculateScale())
//                        .padding(.top,1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movie.id})!) * 16)
//                        .animation(.spring())
//
//
//
//                }
//
//            }
//
//            GeometryReader{proxy in
//                    Button(action:{
//                        withAnimation(){
//                            self.backHomePage.toggle()
//                        }
//                    }){
//                        ZStack{
//                            Circle()
//                                .frame(width:30,height:30)
//                                .opacity(0.5)
//                            Image(systemName: "xmark")
//                                .foregroundColor(.white)
//                        }
//                        .foregroundColor(.black)
//
//                    }
//                    .position(x: proxy.frame(in: .local).maxX - 40
//                              , y: proxy.frame(in: .local).minY + 10)
//
//
//
//                Text("Movie: Action,Science fiction")
//                    .foregroundColor(.white)
//                    .font(.system(size: 16))
//                    .position(x: proxy.frame(in: .local).midX
//                              , y: proxy.frame(in: .local).minY + 50)
//
//                self.renderCurrentInfo()
//                .position(x: proxy.frame(in: .local).midX
//                          , y: proxy.frame(in: .local).maxY - 50)
//
//            }
//        }
//        .background(FullMovieCoverBackground(urlPath: self.currentMovie?.movieCoverURL ?? "" ).blur(radius: 50))
//    }
//
//
//    func renderCurrentInfo() -> some View{
//        ZStack{
//            if currentMovie != nil{
//                Text(currentMovie!.movieName)
//                    .bold()
//                    .frame(width:300)
//                    .foregroundColor(.white)
//                    .lineLimit(2)
//                    .multilineTextAlignment(.center)
//                    .font(.system(size: 25))
//                    .opacity(self.gestureState.isDragging ? 0 : 1)
//                    .animation(.easeInOut)
//
//
//                //More here
//            }
//        }
//
//    }
//
//    func getEndPostion(direction:MovieCoverGesture.EndTranslationPostion){
//        if direction == .left || direction == .right{
//            //TODO
//            //remove the last movie in array and set current movie
//
//                _ = self.movies.popLast()
//                currentMovie = self.movies.last
//
//
//        }
//    }
//
//    func calculateScale()->CGFloat{
//        //when dragging it will affect other card behind
//        return CGFloat(abs(self.gestureState.translation.width / 6000))
//    }
//}

//struct FullMovieCoverBackground:View{
//    var urlPath:String
//    var body: some View{
//        WebImage(url: URL(string: urlPath))
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            .edgesIgnoringSafeArea(.all)
//    }
//}
