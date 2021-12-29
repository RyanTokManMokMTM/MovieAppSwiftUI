//
//  WebImage.swift
//  IOS_DEV
//
//  Created by Jackson on 18/4/2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct MovieDetailView: View {

    let movieId: Int
    @State private var todo : Bool = false
    @StateObject private var movieDetailState = MovieDetailState()
    @StateObject private var listController = ListController()
    @StateObject private var favoriteController = FavoriteController()
    @State var isMyFavorite = false
    @Binding var navBarHidden:Bool
    @Binding var isAction : Bool
    @Binding var isLoading : Bool

    var body: some View {
        ZStack {

            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            
            if movieDetailState.movie != nil{
                WebImages(movie: movieDetailState.movie! , navBarHidden: $navBarHidden, isAction: $isAction, isLoading: $isLoading,myMovieList:listController.mylistData, isMyFavorite:isMyFavorite)
                
            }
        }
        .onAppear {
            self.movieDetailState.loadMovie(id: self.movieId)
            self.listController.GetMyList(userID: NowUserID!)
            self.favoriteController.CheckLikeMovie(movieID: movieId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if !self.favoriteController.favorite.isEmpty {
                    self.isMyFavorite = true
                }
                self.todo = true
            })
    
        }
    }
}

//struct GetMyMovieList: View {
//    @ObservedObject private var listController = ListController()
//    @State var NowUser:Me?
//    @Binding var navBarHidden:Bool
//    @Binding var isAction : Bool
//    @Binding var isLoading : Bool
//    @State var movie : Movie
//
//    var body: some View {
//        ZStack {
//
//
//
//
//        }
//        .onAppear {
//            self.listController.GetMyList(userID: (NowUser?.id)!)
//
//        }
//    }
//}



struct movieImage:View{
    let imgURL: URL
    var body : some View{
        WebImage(url:imgURL)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.init("navBarBlack").opacity(0.0),Color.init("navBarBlack").opacity(0.95)]), startPoint:.top, endPoint: .bottom)


            )
            .background(Color.black.edgesIgnoringSafeArea(.all))

    }
}

struct WebImages: View {
   
    @State var movie : Movie
    //MOVIE URL
    @State private var size = 0.0
    @State private var opacity = 0.0
    @State private var showMovieName = false
    @State private var showAnimation = false
    @Binding var navBarHidden:Bool
    @Binding var isAction : Bool
    @Binding var isLoading : Bool
    @State private var isAppear:Bool = false
    @State var myMovieList : [CustomList]
    @State var isMyFavorite:Bool

    var body: some View {
        
        
        ZStack(alignment:Alignment(horizontal: .center, vertical: .top)){
            
            ScrollView(.vertical, showsIndicators: false){
                GeometryReader{ proxy in
                    if proxy.frame(in:.global).minY > -480{
                        movieImage(imgURL: movie.posterURL)
                            .offset(y:-proxy.frame(in:.global).minY)
                            .frame(width: isAppear ?  0: proxy.frame(in:.global).maxX, height:
                                   isAppear ? 0 :proxy.frame(in:.global).minY  > 0 ?
                                    proxy.frame(in:.global).minY + 480 : 480   )
                            
                            .opacity((Double(proxy.frame(in:.global).minY * 0.0045 + 1)) < 0.45 ? 0.45 :(Double(proxy.frame(in:.global).minY * 0.0045 + 1)))
                            .blur(radius: CGFloat((Double(proxy.frame(in:.global).minY * 0.005 + 1)) < 0.45  ? (Double(proxy.frame(in:.global).minY) * -1 * 0.03) : 0))
//                            .onChange(of: proxy.frame(in:.global).minY, perform: { value in
//
//                            //-----下滑顯示bar上的討論區按鈕和電影名稱-----//
//
////                                let offset = value + UIScreen.main.bounds.height / 2.2
////                                print(offset)
//
////
////                                if offset < 80{
////
////                                if offset > 0{
////
////                                    let op_value = (80 - offset) / 80 * 5 * 1.2
////                                    self.opacity = Double(op_value)
////                                    self.showMovieName = true
////
////                                    return
////                                }
////                                self.opacity = 1
////                                }
////                                else{
////                                    self.opacity = 0
////                                    self.showMovieName = false
////                                }
//                            })
                        
                    }
                }
                .frame(height: 510)
                //.frame(height:480 - 150)
                .animation(.spring(),value:showAnimation)
                //                        Detail Items
                
               
               
                MovieInfoDetail(myMovieList:myMovieList , movie: movie, isMyFavorite:isMyFavorite)
                    .padding([.bottom],UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    
                //     .offset(y:10)
                //   .background(Color.black.edgesIgnoringSafeArea(.all))
                
                
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
            .background(Color.init("navBarBlack").edgesIgnoringSafeArea(.all))
        }
        .edgesIgnoringSafeArea(.all)
        .frame(height:UIScreen.main.bounds.height)
        .navigationTitle(self.isAction ?  movie.title : "")
        .navigationBarTitle(self.isAction ?  movie.title  : "")
        .navigationBarItems(trailing:showBarItem(imgURL: movie.posterURL, name:movie.title).opacity(showMovieName ? 1 : 0).animation(.linear).transition(.flipFromBottom))
        .padding(.horizontal,10)
        .onAppear{
            isAppear = false
            loading()
            print(self.movie)
//            withAnimation(){
//                self.navBarHidden = false
//            }
//            UIScrollView.appearance().bounces = true
            
        }
        .onDisappear{
//            withAnimation(){
//                self.navBarHidden = true
//            }
            self.isLoading = true
//            UIScrollView.appearance().bounces = false
        }
        
        
    }
    
    func loading(){
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.25){
            self.isLoading = false
        }
    }
}

struct MovieInfoDetail: View {
    @State private var isMyList = false
    @State private var gotoChat : Bool = false
    @State var myMovieList : [CustomList]
    @State var movie : Movie
    @ObservedObject private var controller = ListDetailController()
    @ObservedObject private var favoriteController = FavoriteController()
    @ObservedObject var dramaData = dramaInfoData()
    @State var isMyFavorite: Bool 
    
    
    var body: some View {
        VStack(spacing:5){
            HStack(alignment:.center){
                
                
                Text(movie.title)
                    .bold()
                    .font(.system(size:35))
                    .foregroundColor(.red)
              //      .unredacted()
                

            
                Spacer()
                
                
                
//                Button(action:{
//                    print("MovieDetailView 220 chat")
//                   forumController.GetAllArticle()
//                }){
//                    HStack(spacing:0){
//                        Text("CHAT")
//                            .bold()
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: 60, height: 30  )
//                    .background(Color.blue)
//                    .cornerRadius(20)
//                    .font(.system(size: 15))
//                }
//                .simultaneousGesture(TapGesture().onEnded{
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                        self.gotoChat = true
//
//                    })
//
//                })
//                .fullScreenCover(isPresented: self.$gotoChat, content: {
//                    TopicView(articles: forumController.articleData, isPresented: self.$gotoChat)
//
//                })
                
                NavigationLink(destination: GetTopicView(movie:movie))
                {
                    Text("討論區")
                        .bold()
                        .frame(width: 60, height: 30  )
                        .background(Color.blue)
                        .cornerRadius(20)
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal,10)
            
            Spacer()
            
            HScrollList(info: movie)
                .font(.system(size: 14))
             //   .unredacted()
            
            
            
            Spacer()
            Genre(Genres: movie.genres!)
                .padding(.horizontal,10)
              //  .unredacted()
            
            Spacer()


            
            //ScrollView for more info
            VStack(alignment:.leading,spacing:5){

                HStack(spacing:10){
//                    SmallRectButton(title: "Play", icon: "arrowtriangle.right.fill"){
//                        //To Move to Video source page
//                        print("test")
//                    }

                    //------------------------  + MY List ----------------------- -//
                    Menu {
                        ForEach(myMovieList, id:\.id){list in
                            Button(action: {
                                controller.postListMovie(listTitle: list.Title, UserName: list.user!.UserName , movieID: movie.id, movietitle: movie.title, posterPath: movie.posterPath!, feeling: " ", ratetext: 0)
                            }, label: {
                                Text(list.Title)
                            })
                        }
                    

                   } label: {
                        SmallBorderOnlyButton(title: "My List", icon: "plus", onChangeIcon: "checkmark",isMylist: $isMyList){
                            //To Add this movie to my List
                            isMyList.toggle()
                        }
                   }
                    
                    //------------------------  Like ? -------------------------//
                    
                    
//
                    SmallVerticalButton(IsOnImage: "heart.fill", IsOffImage: "heart", text: "Like", IsOn: $isMyFavorite){
                        isMyFavorite.toggle()

                        if isMyFavorite == true {
                            favoriteController.PostLikeMovie(movie: movie.id, title: movie.title, posterPath: movie.posterPath!)
                        } else{
                            self.favoriteController.deleteLikeMovie(movieID: movie.id)
                        }
                    }
                    .padding(.trailing)
                    
                    Spacer()

                }
                .padding(.horizontal,10)
          //      .unredacted()

                MovieDetailList(movie: movie, tabs: [.overView,.trailer,.more,.resources])
                    
//
//                VerticalButton()



            }
            .padding(.top,5)
            .font(.system(size: 14))
            .foregroundColor(Color(UIColor.systemGray3))
        }
        .font(.system(.title3))
        .foregroundColor(.white)
        .padding(.top)
       
       
    }
}

struct VerticalButton: View {
    var body: some View {
        HStack(spacing:30){
            SmallVerticalButton(IsOnImage: "paperplane.fill", IsOffImage: "paperplane.fill", text: "Share", IsOn: .constant(true)){
                //TODO
            }
            
            SmallVerticalButton(IsOnImage: "message.fill", IsOffImage: "message", text: "comment", IsOn: .constant(true)){
                //TODO
            }
            Spacer()
        }
      //  .padding(.horizontal)
    }
}

struct NavBarImage:View{
    @State var show = false
    let imgURL: URL
    var body:some View{
        
        VStack{
            WebImage(url:imgURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(5)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct showBarItem:View{
    let imgURL: URL
    let name:String
    var body:some View{
        HStack(alignment:.bottom,spacing:10){
            Spacer()
            NavBarImage(imgURL:imgURL )
                .frame(width:22,height: 22)
                .padding(.horizontal)
            
            HStack(alignment:.center,spacing:8){
                Text(name)
                    .bold()
                    .font(.system(size:12))
                    .foregroundColor(.gray)
                
                smallNavButton(buttonColor: .blue, buttonTextColor: .white, text: "CHAT"){
                    print("chat test")
                }
            }
            

        }
//
    }
    
}
//
