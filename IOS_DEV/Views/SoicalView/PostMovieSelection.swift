//
//  PostMovieSelection.swift
//  IOS_DEV
//
//  Created by Jackson on 13/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

//For Searching View
class PostMovieSelectionVM : ObservableObject {
    @Published var searchMovieList : [Movie] = []
    @Published var searchingLoading : Bool = false
    @Published var seachingError : Error? = nil
    @Published var selectedMovie : Movie? = nil
    @Published var isSearching :  Bool = false
    @Published var query : String = "" {
        didSet{
//            print(query)
            getSearchResult()
        }
    }
    init(){}
    
    func getSearchResult(){
        //reset the selected movied
        resetSelectedMovie()
        
        searchMovieList.removeAll()
        self.searchingLoading = true
        MovieStore.shared.searchMovieInfo(query: query){ result in
            self.searchingLoading = false
            switch result {
            case .success(let data):
                self.searchMovieList = data.results
            case .failure(let err):
                self.seachingError = err
                print(err.localizedDescription)
            }
        }
    }
    
    func resetSelectedMovie(){
        if self.selectedMovie != nil{
            self.selectedMovie = nil
        }
    }
}


struct PostMovieSelection : View{
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @Binding var isSelectMovie : Bool
    @State private var isAddDesc : Bool = false
    @StateObject var PostMovieVM  = PostMovieSelectionVM()
    @State private var currentIndex : Int = 0
    @Namespace var namespace
    var body: some View{
            ZStack(alignment:.bottom){
                ZStack(alignment:.topTrailing){
                    //background iamge using a tab View with page style
                    
                    HStack{
                        Button(action:{
                            //TODO: BACK TO THE PAGE
                            withAnimation(){
                                self.isSelectMovie.toggle()
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        HStack{
                            if self.PostMovieVM.isSearching{
                                Image(systemName: "magnifyingglass")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                                    .matchedGeometryEffect(id: "search", in: namespace)
                                
                                
                                TextField("搜尋文章連結電影...", text: self.$PostMovieVM.query)
                                    .submitLabel(.done)
                                    .accentColor(.white)
                                
                                Button(action:{
                                    withAnimation{
                                        self.PostMovieVM.resetSelectedMovie()
                                        if !self.PostMovieVM.query.isEmpty{
                                            self.PostMovieVM.query.removeAll()
                                        }else {
                                            self.PostMovieVM.isSearching.toggle()
                                        }
                                    }
                                }){
                                    Image(systemName: "xmark")
                                        .imageScale(.large)
                                        .foregroundColor(.white)
                                    
                                }
                            } else {
                                //                            Spacer()
                                Button(action:{
                                    withAnimation{
                                        self.PostMovieVM.isSearching.toggle()
                                    }
                                }){
                                    Image(systemName: "magnifyingglass")
                                        .imageScale(.large)
                                        .foregroundColor(.white)
                                        .matchedGeometryEffect(id: "search", in: namespace)
                                }
                            }
                        }
                        .padding(self.PostMovieVM.isSearching ? 10 : 8)
                        .padding(.horizontal,self.PostMovieVM.isSearching ? 5 : 0)
                        .background(BlurView(sytle: .systemMaterial))
                        .cornerRadius(25)
                    }
                    .zIndex(1)
                    .padding(.horizontal)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    if self.PostMovieVM.query.isEmpty && self.PostMovieVM.searchMovieList.isEmpty {
                        VStack{
                            Spacer()
                            Text("請輸入文章連結電影關鍵字進行搜尋🔍")
                                .font(.system(size: 16, weight: .semibold))
                                
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width)
                            
                    } else if self.PostMovieVM.seachingError != nil && self.PostMovieVM.searchingLoading{
                        VStack{
                            Spacer()
                            LoadingView(isLoading: self.PostMovieVM.searchingLoading, error: self.PostMovieVM.seachingError as NSError?){
                                    self.PostMovieVM.getSearchResult()
                                }
                            Spacer()
                        }
                    } else if self.PostMovieVM.searchMovieList.isEmpty && self.PostMovieVM.seachingError == nil && !self.PostMovieVM.searchingLoading{
                        VStack{
                            Spacer()
                            Text("抱歉...沒有找到您想要的電影:(")
                                .font(.system(size: 16, weight: .semibold))
                                
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    } else { TabView(selection:$currentIndex){
                            ForEach(self.PostMovieVM.searchMovieList.indices,id:\.self){ i in
                                GeometryReader{proxy in
                                    WebImage(url: self.PostMovieVM.searchMovieList[i].posterURL)
                                        .resizable()
                                        .placeholder{
                                            Text(self.PostMovieVM.searchMovieList[i].title)
                                        }
                                        .indicator(.activity) // Activity Indicator
                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                        .aspectRatio(contentMode:.fill)
                                        .frame(width:proxy.size.width,height:proxy.size.height)
                                        .cornerRadius(1)
                                }
                                .ignoresSafeArea()
                                .offset(y:-100)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                            }

                        }
                        .edgesIgnoringSafeArea(.top)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .ignoresSafeArea()
                        .animation(.easeOut(duration: 0.25))
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [
                                Color.clear,
                                Color.black.opacity(0.2),
                                Color.black.opacity(0.4),
                                Color.black,
                                Color.black,
                                Color.black,

                            ]), startPoint: .top, endPoint: .bottom)
                        )
                        //
                        ListSilder(trailingSpace:150,index: self.$currentIndex, items: self.PostMovieVM.searchMovieList){ movie in
                            PreviewView(card: movie)

                        }
                        .offset(y:UIScreen.main.bounds.height / 4)
                        .edgesIgnoringSafeArea(.all)
                        
                    }
   

                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                //TODO: AFTER SELECTED THE MOVIE
                //TODO: GO TO NEXT STEP
                if self.PostMovieVM.selectedMovie != nil{
                    NavigationLink(destination:
                                    
                                    AddPostView(selectedMovie: self.PostMovieVM.selectedMovie!, isSelectedMovie: self.$isSelectMovie, isAddPost: self.$isAddDesc)
                                    .navigationBarTitle("")
                                    .navigationTitle("")
                                    .navigationBarHidden(true)
                                    .environmentObject(postVM)
                                    .environmentObject(userVM),
                                   isActive: $isAddDesc){
                        VStack{
                            Spacer()
                            HStack{
                                Text("下一步")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                            }
                            .padding()
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(self.PostMovieVM.selectedMovie == nil ? .gray : .red)
                            .cornerRadius(25)
                          
                        }
                    }
                                   .buttonStyle(.plain)
                                   .zIndex(2)
                                   .padding(.bottom)
                                   .disabled(self.PostMovieVM.selectedMovie == nil)
                }
            }
            .background(Color("appleDark").edgesIgnoringSafeArea(.all))
            .ignoresSafeArea(.keyboard, edges: .bottom)
//            .ignoresSafeArea(.keyboard, edges: .top)
//            .navigationTitle("")
//            .navigationBarTitle("")
//            .navigationBarTitleDisplayMode(.inline)
            
//        }
        
    }
    
    @ViewBuilder
    private func PreviewView(card : Movie) -> some View{
        VStack(spacing:10){
            GeometryReader{proxy in
//                Image(card.image)
                WebImage(url: card.posterURL)
                    .resizable()
                    .placeholder{
                        Text(card.title)
                    }
                    .indicator(.activity) // Activity Indicator
                    .aspectRatio(contentMode:.fill)
                    .frame(width:proxy.size.width,height:proxy.size.height)
                    .cornerRadius(25)
                    
            }
            .padding(20)
            .background(BlurView(sytle: .systemUltraThinMaterialDark))
            .cornerRadius(25)
            .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(self.PostMovieVM.selectedMovie != nil && self.PostMovieVM.selectedMovie!.id == card.id ? .red : .clear,lineWidth: 3)
                        
                
                    
            )
            .frame(height:UIScreen.main.bounds.height / 2.5)
            .padding(.bottom,15)
            
            //the movie data here
            Text(card.title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            
            
            //movie rate
            HStack(spacing:3){
//                if card.voteAverage != nil{
                    ForEach(1...5,id:\.self){index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index <= Int(card.voteAverage)/2 ? .yellow: .gray)
                    }

                    Text("(\(Int(card.voteAverage)/2).0)")
                        .foregroundColor(.gray)
//                }
            }
            .font(.caption)
            
            
            Text(card.overview)
                .font(.callout)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.top,8)
                .padding(.horizontal)
                .foregroundColor(.white)
            
            
        }
        .onTapGesture {
            withAnimation(){
//                self.isShowResult.toggle()
                if self.PostMovieVM.selectedMovie != nil && self.PostMovieVM.selectedMovie!.id == card.id {
                    self.PostMovieVM.selectedMovie = nil
                    return
                }
                
                self.PostMovieVM.selectedMovie = card
            }
        }
        
    }
}





