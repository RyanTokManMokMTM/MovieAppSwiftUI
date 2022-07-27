//
//  MovieCardGesture.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/10.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

struct MovieCardGesture :View{
    let imageLoader = ImageLoader()
    @StateObject var favourController = FavoriteService()
    
    @EnvironmentObject var movieListMV : GenreTypeState
    @State var movies : [MovieCardInfo]  //allow as to remove
    @State var currentMovie:MovieCardInfo?
    @State var gestureState = CardGesture.CardGestureState.inactive
    @Binding var backHomePage:Bool
    

    
    @State private var isMovieDetail : Bool = false
    @State private var previewMovieId : Int?
    
    let genreData = DataLoader().genreData
    let name : String
    
    var body: some View {
        NavigationView{
            ZStack{
        
                ZStack(){
                    if movies.isEmpty {
                        VStack{
                            Text("**目前沒有任何相關電影資訊...**")
                                .foregroundColor(.white)
                                .font(.system(size:16,weight:.semibold))
                        }
                    }else {
                        ForEach(movies){movie in
                            
                            if self.movies.reversed().firstIndex(where: {$0.id == movie.id}) == 0{
                                //render the current item as CoverGesture view
                                //arrow to drag
                                CardGesture(
                                    DragState: self.$gestureState,
                                    //                        onTapGesture: {},
                                    willEndTranslation: {(translation) in},
                                    EndTranslation: {(direction) in
                                        self.getEndPostion(direction: direction)
                                    }, movie: movie)
                                
                            }else{
                                //just show
                                TheCard(movie: movie)
                                    .frame(width:245)
                                    .scaleEffect( 1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movie.id})!) * 0.03 + self.calculateScale())
                                    .padding(.top,1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movie.id})!) * 16)
                                    .animation(.spring())
                                
                            }
                            
                        }
                        
                    }
          
                    
                    GeometryReader{proxy in
                        Button(action:{
                            withAnimation(){
                                self.backHomePage.toggle()
                            }
                        }){
                            ZStack{
                                Circle()
                                    .frame(width:30,height:30)
                                    .opacity(0.5)
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.black)
                            
                        }
                        .position(x: proxy.frame(in: .local).maxX - 40
                                  , y: proxy.frame(in: .local).minY + 10)
                        
                        
                        VStack{
                            Text("Movie Discovery")
                                .bold()
                                .font(.title3)
                            
                            HStack{
                                //                                ForEach(genreData, id:\.id){ genre in
                                //                                    if genre.id == self.genreID {
                                //                                        Text(genre.name)
                                //                                            .bold()
                                //                                            .font(.subheadline)
                                //                                    }
                                //                                }
                                Text(name)
                                    .bold()
                                    .font(.subheadline)
                            }
                            
                        }
                        .position(x: proxy.frame(in: .local).midX
                                  , y: proxy.frame(in: .local).minY + 50)
                        
                        
                        self.renderCurrentInfo()
                            .position(x: proxy.frame(in: .local).midX
                                      , y: proxy.frame(in: .local).maxY - 50)
                        
                        
                    }
                }
                .background(FullMovieCoverBackground(urlPath: self.currentMovie?.poster ?? "/ocUrMYbdjknu2TwzMHKT9PBBQRw.jpg").blur(radius: 50))
                
                

                if previewMovieId != nil{
                    NavigationLink(destination: MovieDetailView(movieId:self.previewMovieId!, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true)), isActive: self.$isMovieDetail){
                        EmptyView()
                    }
                }
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
//            .navigationTitle(self.isActive ? "Back" : "")
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
    }
    
    func movingLeft() -> Double{
        //get current possition to determine the opcacity factor
        Double(-gestureState.translation.width / 1000)
    }
    
    func movingRight() -> Double{
        //get current possition to determine the opcacity factor
        Double(gestureState.translation.width / 1000)
    }

    func renderCurrentInfo() -> some View {
        ZStack{

            if currentMovie != nil{
                Group(){
                    
                    VStack(spacing:10){
                        Text(currentMovie!.title)
                            .bold()
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .font(.system(size: 25))
                            .multilineTextAlignment(.center)

                        HStack(spacing:3){
                            if (currentMovie!.vote_average)/2 == 0{
                                Text("N/A")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }else{
                                ForEach(1...5,id:\.self){index in
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundColor(index <= Int(currentMovie!.vote_average)/2 ? .yellow: .gray)
                                }
                                
                                Text("(\(Int(currentMovie!.vote_average)/2).0)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }

                        }
                    }
                    .opacity(self.gestureState.isDragging ? 0 : 1)
                    .animation(.easeInOut)
                    .offset(y:-80)
    
//
                    
                    Circle()
                        .strokeBorder(Color.red,lineWidth: 1)
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "xmark").foregroundColor(.red))
                        .opacity(self.gestureState.isDragging ? 0 : 1)
                        .animation(.easeInOut)
                        .onTapGesture {
                            _ = self.movies.popLast()

                                if self.movies.count == 0{
                                    withAnimation(){
                                        self.backHomePage.toggle()
                                    }
                                }
                                
                                currentMovie = self.movies.last
                            
                        }
                    
                    //only appear at dragging
                    Group{
                        Circle()
                            .strokeBorder(Color.pink,lineWidth: 1)
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "heart.fill").foregroundColor(.pink))
                            .offset(x: -60, y: -35)
                            .opacity(self.gestureState.isDragging ? 0.4 + movingLeft() : 0)
                            .animation(.easeInOut)
                        
                        Circle()
                            .strokeBorder(Color.blue,lineWidth: 1)
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "eye.fill").foregroundColor(.blue))
                            .offset(x: 60, y: -35)
                            .opacity(self.gestureState.isDragging ? 0.4 + movingRight() : 0)
                            .animation(.easeInOut)
                    }

                    
                    
                    //return back
                    Button(action:{
                        withAnimation(){
                            self.movies = self.movieListMV.genreMovies
                            self.currentMovie = self.movies.last
                        }
                    }){
                        Image(systemName: "arrow.uturn.down")
                    }
                    .frame(width: 40, height: 40)
                    .offset(x:-60)
                    .foregroundColor(Color.purple)
                    .opacity(self.gestureState.isDragging ? 0 : 1)
                    .animation(.easeInOut)
                    
                    //refresh
                    Button(action:{
                        self.movies = self.movies.shuffled()
                        self.currentMovie = self.movies.last
                    }){
                        Image(systemName: "arrow.triangle.swap")
                    }
                    .frame(width: 40, height: 40)
                    .offset(x:60)
                    .foregroundColor(Color.purple)
                    .opacity(self.gestureState.isDragging ? 0 : 1)
                    .animation(.easeInOut)
                    
                    
                }
//                .frame(width:300)
//                .multilineTextAlignment(.center)
//                .opacity(self.gestureState.isDragging ? 0 : 1)
//                .animation(.easeInOut)
               

                //More here
            }

        }

    }
    
    func getEndPostion(direction:CardGesture.EndTranslationPostion){
        if direction == .left || direction == .right{
            //TODO
            //remove the last movie in array and set current movie
            
            _ = self.movies.popLast()

                if direction == .right{
//                    withAnimation(){
//                        self.previewMovieId = currentMovie!.id
//                    }
//                    self.isMovieDetail.toggle()
                }
                
                if direction == .left{
                    postLikeData(movie: currentMovie!)
                }
            
                currentMovie = self.movies.last
                

                
                if self.movies.count == 0{
                    withAnimation(){
                        self.backHomePage.toggle()
                    }
                }
                self.feedBack.impactOccurred(intensity: 0.8)
            
        }
    }
    
    private let feedBack = UIImpactFeedbackGenerator()

    func calculateScale()->CGFloat{
        //when dragging it will affect other card behind
        return CGFloat(abs(self.gestureState.translation.width / 6000))
    }
    
    func postLikeData( movie:MovieCardInfo){
//        let data = NewLikeMovie(userID: NowUserID!, movie: movie.id, title: movie.title, posterPath: movie.poster!)
        let req = NewUserLikeMoviedReq(movie_id: movie.id)
        
        APIService.shared.PostLikedMovie(req:req){ (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let err):
                print("Movie:\(movie.title) added failed : \(err.localizedDescription)")
            }
            
        } 
    }
}

//--------------------PREVIEW--------------------//
//struct MovieCardGesture_Previews: PreviewProvider {
//    static var previews: some View {
//
//        MovieCardGesture(movies: stubbedMovie,currentMovie: stubbedMovie.last, backHomePage: .constant(false))
//    }
//}


//--------------------GESTURE--------------------//
struct CardGesture: View {

    enum CardGestureState {
        case inactive //doing nothing
        case pressing //pressing the image only
        case dragging(translation:CGSize,predictEndLocation:CGPoint)

        //getting dragging translation
        var translation:CGSize{
            switch self {
            case .inactive,.pressing:
                return .zero
            case .dragging(let translation,_):
                return translation
            }
        }

        //location to end
        var predictEndLocation:CGPoint{
            switch self {
            case .inactive,.pressing:
                return .zero
            case .dragging(_, let predictEndlocation):
                return predictEndlocation
            }
        }

        var isActive:Bool{
            switch self {
            case .inactive:
                return false
            default:
                return true
            }
        }

        var isDragging:Bool{
            switch self {
            case .inactive,.pressing:
                return false
            default:
                return true
            }
        }

    }

    enum EndTranslationPostion{
        case left,right,cancle
    }

    @Binding var DragState:CardGestureState //let parent know what is current state
//    var onTapGesture:()->Void
    var willEndTranslation : (CGSize)->Void //geting current Translation postion
    var EndTranslation:(EndTranslationPostion)->Void //getting the state to end

    @GestureState private var gestureState:CardGestureState = .inactive //default is inactive
    @State private var todo : Bool = false
    @State private var hasMove = false
    @State private var predictEndLocation:CGPoint? = nil
    var movie: MovieCardInfo
    var body: some View {
        //concate 2 Gesture to Create a new Gesture
        //in this case longPrssingGesture + GragGresture
        let longPressGesture = LongPressGesture(minimumDuration: 0.0)
            .sequenced(before: DragGesture())
            .updating($gestureState){(value,state,transtition) in
                switch value{
                case .first(true): //the gesture is end?? ture = end,else false,in this case,is done
                    self.feedBack.prepare()
                    state = .pressing
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero, predictEndLocation: drag?.predictedEndLocation ?? .zero)
                default :
                    state = .inactive
                }
            }
            .onChanged{ (value) in
                //TODO:
                //Check current translation is zero??(jsut pressing not dragging) or other
                if self.gestureState.translation.width == 0 {
                    self.DragState = .pressing
                    self.hasMove = false
                }
                else{
                    //set binding value to dragging and given the value of translatrion and end location value
                   // print("translation:\(self.gestureState.translation)")
                  //  print("endLocation:\(self.gestureState.predictEndLocation)")
                    self.DragState = .dragging(translation: self.gestureState.translation, predictEndLocation: self.gestureState.predictEndLocation)
                    self.hasMove = true
                }
            }
            .onEnded{ (value) in
                //because binding value is now up to date
                //when user on release-> trigger

                let endLocation = self.DragState.predictEndLocation

                if endLocation.x < -150{
                    self.willEndTranslation(self.gestureState.translation)
                    self.predictEndLocation = endLocation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        self.EndTranslation(.left)
                    }
                    print("left")
                }
                else if endLocation.x > UIScreen.main.bounds.width - 50{
                    self.willEndTranslation(self.gestureState.translation)
                    self.predictEndLocation = endLocation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        self.EndTranslation(.right)
                    }
                    print("right")
                }
                else{
                   // self.willEndTranslation
                    self.EndTranslation(.cancle)
                    print("cancle")
                }
                self.DragState = .inactive

            }


       return TheCard(movie: movie)
        .frame(width:245)
        .offset(self.calculateOffset())
        .scaleEffect(self.gestureState.isActive ? 1.03 : 1)
        .rotationEffect(self.calculateAngle())
        .opacity(self.predictEndLocation != nil ? 0 : 1)
        .shadow(color: .secondary, radius: self.gestureState.isActive ? 16 : 0, x: self.gestureState.isActive ? 4 : 0, y: self.gestureState.isActive ? 4 : 0)
        .animation(.interpolatingSpring(mass: 1, stiffness: 150, damping: 15, initialVelocity: 5))
        .gesture(longPressGesture)
        .simultaneousGesture(TapGesture(count: 1).onEnded({_ in
            if !self.hasMove{
//                self.onTapGesture()
                self.todo = true
                print("press")
            }
        }))
//        .fullScreenCover(isPresented: self.$todo, content: {
//            GestureDetailVeiw(movieId: movie.id,navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true),isPresented: self.$todo)
//                .preferredColorScheme(.dark)
//        })
        .onTapGesture {
            //Given a feed back
            self.feedBack.prepare()
        }


    }

    let feedBack = UISelectionFeedbackGenerator()

    func calculateOffset() -> CGSize{
        if let endLocation = self.predictEndLocation{
            return CGSize(width: endLocation.x, height: 0)
        }
        return CGSize(width: self.gestureState.isActive ? self.gestureState.translation.width : 0, height: 0)
    }

    func calculateAngle()->Angle{
        if let endLocation = self.predictEndLocation{
            return Angle(degrees: Double(endLocation.x) / 15)
        }
        return Angle(degrees: Double(self.gestureState.isDragging ? self.gestureState.translation.width / 15 : 0))
    }
}

//--------------------BACKGROUND--------------------//
struct FullMovieCoverBackground:View{
    var urlPath: String
    var body: some View{
        
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(urlPath)"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)
            
    }
}


//--------------------CARD-------------------//

struct TheCard:View{
    var movie: MovieCardInfo
    @State private var todo : Bool = false
    var body: some View{
       
        WebImage(url:movie.posterURL)
            .resizable()
//            .placeholder{
//                Text(movie.title)
//            }
//            .indicator(.activity) // Activity Indicator
//            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .aspectRatio(0.66,contentMode: .fit)
            .cornerRadius(10)
        
            

   
    }
}


