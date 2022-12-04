//
//  MovieSearchView.swift
//  IOS_DEV
//
//  Created by Jackson on 17/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Algorithms

class SearchingHistoryManager : ObservableObject {
    @AppStorage("searchHistroy") var history : [String] =  []
    
    func updateHistory(query : String){
        if self.history.count == 15{
            self.history.removeLast()
        }
        
        let exist = self.history.contains{$0 == query}
        if exist{
            //the string is inside the collection
            let index = self.history.firstIndex(of: query)
            self.history.remove(at: index!)
        }
        self.history.insert(query, at: 0)
    }
    
    func removeAllHistory(){
        self.history.removeAll()
    }
}

class MovieSearchVM : ObservableObject {
    @Published var searchingText : String = "" {
        didSet {
            getMovieSearchResult()
        }
    }
    @Published var searchResult : [Movie] = []//For actucal Result View
    
    @Published var searchResultPage : Int = 1
    @Published var searchCurPage : Int = 1
    @Published var isLoading : Bool = false
    @Published var fetchingError : NSError?
    @Published var recommandPlachold : String = "電影..."
//    @Published var isSearching = true //false : only for showing result
    init(){}
    
    func getMovieSearchResult(){
        if self.searchingText.isEmpty { return }
        self.isLoading = true
        self.fetchingError = nil
        MovieStore.shared.searchMovieInfo(query: self.searchingText) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                self.searchResult = data.results
                self.searchResultPage = data.totalPages
            case .failure(let err) :
                print(err.localizedDescription)
                self.fetchingError = err as NSError
            }
        }
    }
    
    @MainActor
    func getMoreMovieResult() async {
        if self.searchCurPage >= self.searchResultPage {
            return
        }
        self.isLoading = true
        self.searchCurPage += 1
        let resp = await MovieStore.shared.AsyncsearchMovieInfo(query: self.searchingText, page: self.searchCurPage)
        switch resp {
        case .success(let data):
            self.searchResult.append(contentsOf: data.results)
            let result = self.searchResult.uniqued()
            self.searchResult = Array(result)
            self.searchResultPage = data.totalPages
            print(self.searchResultPage)
        case .failure(let err):
            print(err.localizedDescription)
        }
        
        self.isLoading = false
    }

    
    func isLastMovie(movieID : Int) -> Bool {
        return self.searchResult.last?.id == movieID
    }
}

struct MovieMainSearchView: View {
    @Binding var isSeacrhing : Bool
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    @StateObject private var searchVM  = MovieSearchVM()
    @StateObject private var historyManager = SearchingHistoryManager()
   
    
    @FocusState private var isFocus : Bool
    let gridItems = Array(repeating: GridItem(.flexible(),spacing: 0), count: 2)
    
    @State private var isShowResult : Bool = false
    @State private var finalSearchingQuery = ""
    
    
    @State private var isDelete : Bool = false
    @Environment(\.dismiss) private var dissmiss
    var body: some View {
        VStack(spacing:0){
            SeachBar()
            Divider()
            //Contant Data right now... it may chagne in future
            
            if self.searchVM.searchingText.isEmpty  {
                if !self.historyManager.history.isEmpty{
                    
                    HStack{
                        Text("搜尋歷史")
                            .fontWeight(.bold)
                            .font(.footnote)
                        Spacer()
                        
                        Button(action:{
                            withAnimation(.easeInOut(duration: 0.3)){
                                //                            self.StateManager.isRemove.toggle()
                                //                            self.StateManager.isFocuse = [false,false]
                                self.isDelete = true
//                                self.searchVM.removeAllHistory()
                            }
                        }){
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    
                    history(history: self.historyManager.history)
                        .padding(.bottom,5)
//                    HistorList
                    
                }
//                Group{
//                    HStack{
//                        Text("推薦搜索")
//                            .fontWeight(.bold)
//                            .font(.footnote)
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical,5)
//
//
//                    if !hotItemTest.isEmpty{
//                        LazyVGrid(columns: gridItems){
//                            ForEach(0..<hotItemTest.count){ i in
//                                //                            SearchHotCard(rank: i+1,rankColor: i <= 3 ? .red : .white, hotData: hotItemTest[i])
//                                Button(action:{
//                                }){
//                                    VStack(alignment:.leading){
//                                        HStack(spacing:15){
//                                            VStack  {
//                                                Spacer()
//                                                Text("\(i + 1)")
//                                                    .bold()
//                                                    .font(.footnote)
//                                                    .foregroundColor( i <= 3 ? .red : .white)
//                                                Spacer()
//                                            }
//                                            VStack(alignment: .leading, spacing: 10){
//                                                Text(hotItemTest[i].title)
//                                                    .bold()
//                                                    .font(.footnote)
//                                                    .foregroundColor(.white)
//                                                    .lineLimit(1)
//                                                Text(hotItemTest[i].description)
//                                                    .foregroundColor(.gray)
//                                                    .font(.caption)
//                                                    .lineLimit(1)
//                                            }
//                                            Spacer()
//                                        }
//                                    }
//                                    .padding(5)
//                                }
//                            }
//                        }
//                    }else{
//                        Text("抱歉,沒有推薦的電影...")
//                            .foregroundColor(.secondary)
//                            .font(.caption)
//                    }
//                }
            }
            else if self.searchVM.isLoading{
                HStack{
                    ActivityIndicatorView()
                    Text("Loading...")
                        .font(.system(size:14,weight:.semibold))
                }
            } else if self.searchVM.searchResult.isEmpty{
                Text("There are no such movie...")
            } else {
                List(){
                    ForEach(self.searchVM.searchResult,id:\.self){ movie in
                        Button(action: {
                            //GO THE Movie Detail Page
                            self.finalSearchingQuery = movie.title
                            withAnimation{
                                self.isShowResult = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.historyManager.updateHistory(query: movie.title)
                                self.searchVM.searchingText.removeAll()
                            }
                            
                        }){
                            HStack(spacing:0){
                                Text(movie.title)
                                    .font(.system(size: 14))
                                    .bold()
                                    
                                
                                Spacer()
                                
                                
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowBackground(Color("DarkMode2"))
                }
                .listStyle(.plain)
            }
            Spacer()
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarTitle("")
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .background(Color("DarkMode2"))
        .background(
            NavigationLink(destination: MovieMainSearchResultView(searchKeyWord: finalSearchingQuery)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .environmentObject(userVM)
                            .environmentObject(postVM)
                            .environmentObject(historyManager)
                           ,isActive: $isShowResult){
                               EmptyView()
                           }
            
        )
        .alert(isPresented: self.$isDelete){
            withAnimation(){
                Alert(title: Text("刪除所有搜尋歷史"), message: Text("確定刪掉?"),
                      primaryButton: .default(Text("取消")){
                        self.isFocus = true
                      },
                      secondaryButton: .default(Text("刪除")){
                        withAnimation{
                            self.historyManager.removeAllHistory()
                            self.isFocus = true
                            
                        }
                      })
            }
            
        }
        
        
    }
    
    @ViewBuilder
    private func history(history : [String]) -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(history,id:\.self){key in
                    searchFieldButton(searchingText: key){
                        //TODO: remove all result which are older searching data
                        self.searchVM.searchResult.removeAll()
                        self.searchVM.searchingText = key
                        self.historyManager.updateHistory(query: key)
                        self.isFocus = true //set to focusting...
                    }
                }
                
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func SeachBar() -> some View{
        HStack(spacing:5){
            HStack{
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
                VStack{
                    Spacer()
                    TextField(self.searchVM.recommandPlachold, text: self.$searchVM.searchingText)
                        .accentColor(.white)
                        .submitLabel(.search)
                        .focused($isFocus)
                        .onSubmit({
                            if searchVM.searchResult.isEmpty { return }
                            
                            DispatchQueue.main.async {
                                self.finalSearchingQuery = self.searchVM.searchingText
                                withAnimation{
                                    self.isShowResult = true
                                }
                                self.historyManager.updateHistory(query: self.searchVM.searchingText)
                                self.searchVM.searchingText.removeAll()
                            }
                            
                           
                        })
                    Spacer()
                }.ignoresSafeArea(.keyboard,edges: .bottom)

            }
            .frame(height: 22)
            .padding(.horizontal,5)
//            .background(Color("appleDark"))
            
            Button(action:{
                self.searchVM.searchingText.removeAll()
            }){
               Image(systemName: "xmark")
                    .imageScale(.small)
                    .padding(5)
                    .background(
                        BlurView(sytle: .systemThickMaterialDark).frame(width: 25, height: 25).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
                    )
                    .foregroundColor(.gray)
                
            }
            .padding(.horizontal,8)
            .opacity(self.searchVM.searchingText.isEmpty ? 0 : 1)
            
            Button(action:{
                //Back To home page
                self.isSeacrhing = false
            }){
                Text("取消")
                    .foregroundColor(.gray)
                    .font(.system(size:14,weight: .semibold))
            }
        }
        .padding(.horizontal,8)
        .frame(width: UIScreen.main.bounds.width, height: 40)
        .background(Color("DarkMode2"))
        
        
        
    }
}

struct MovieMainSearchResultView: View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var historyManager : SearchingHistoryManager
    
    var searchKeyWord : String
    @State private var isDelete : Bool = false
    @StateObject private var searchVM : MovieSearchVM = MovieSearchVM()
    @FocusState private var isFocus : Bool
    private let gridItems = Array(repeating: GridItem(.flexible(),spacing: 0), count: 2)
    
    @State private var tempQuery = ""
    @State private var isShowMovieDetail : Bool = false
    @State private var movieId : Int = 0
    
    @Environment(\.dismiss) private var dissmiss
    var body: some View {
        VStack(spacing:0){
            SeachBar()
            Divider()
            if isFocus || isDelete{
                //Show searching...
                ShowSearchState()
            }else {
                //just show the result
                ShowSearchResult()
            }

        }
        .onAppear{
            if self.searchVM.searchingText.isEmpty{
                self.searchVM.searchingText = searchKeyWord
                self.searchVM.getMovieSearchResult()
            }

        }
        .background(Color("DarkMode2"))
        .background(
            NavigationLink(destination: MovieDetailView(movieId: self.movieId, isShowDetail: self.$isShowMovieDetail)
                            .environmentObject(userVM)
                            .environmentObject(postVM)
                           
                           ,isActive: self.$isShowMovieDetail){
                EmptyView()
            }
        
        )
        .alert(isPresented: self.$isDelete){
            withAnimation(){
                Alert(title: Text("刪除所有搜尋歷史"), message: Text("確定刪掉?"),
                      primaryButton: .default(Text("取消")){
                        self.isFocus = true
                      },
                      secondaryButton: .default(Text("刪除")){
                        withAnimation{
                            self.historyManager.removeAllHistory()
                            self.isFocus = true
                            
                        }
                      })
            }
            
        }
    }
    
    @ViewBuilder
    func ShowSearchState() -> some View {
        if self.searchVM.searchingText.isEmpty  {
            if !self.historyManager.history.isEmpty{
                
                HStack{
                    Text("搜尋歷史")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                    
                    Button(action:{
                        withAnimation(.easeInOut(duration: 0.3)){
//                            self.StateManager.isRemove.toggle()
//                            self.StateManager.isFocuse = [false,false]
                            self.isDelete = true
//                            self.searchVM.removeAllHistory()
                        }
                    }){
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical,5)
                
                history(history: self.historyManager.history)
                    .padding(.bottom,5)
                
            }
//            Group{
//                HStack{
//                    Text("推薦搜索")
//                        .fontWeight(.bold)
//                        .font(.footnote)
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .padding(.vertical,5)
//
//
//                if !hotItemTest.isEmpty{
//                    LazyVGrid(columns: gridItems){
//                        ForEach(0..<hotItemTest.count){ i in
////                            SearchHotCard(rank: i+1,rankColor: i <= 3 ? .red : .white, hotData: hotItemTest[i])
//                            Button(action:{
////                                self.searchMV.searchResult.removeAll()
////                                self.StateManager.isSeaching.toggle()
////                                self.searchMV.searchingText = hotData.title
////                                self.StateManager.isEditing = false
////                                withAnimation(.easeOut(duration:0.7)){
////                                    self.StateManager.isFocuse = [false,false]
////                                    self.StateManager.getSearchResult = true
////                                }
////                                self.StateManager.updateSearchingHistory(query: hotData.title)
////                                self.searchMV.searchingText = hotData.title
////                                self.searchMV.getSearchingResult()
//                            }){
//                                VStack(alignment:.leading){
//                                    HStack(spacing:15){
//                                        VStack  {
//                                            Spacer()
//                                            Text("\(i + 1)")
//                                                .bold()
//                                                .font(.footnote)
//                                                .foregroundColor( i <= 3 ? .red : .white)
//                                            Spacer()
//                                        }
//                                        VStack(alignment: .leading, spacing: 10){
//                                            Text(hotItemTest[i].title)
//                                                .bold()
//                                                .font(.footnote)
//                                                .foregroundColor(.white)
//                                                .lineLimit(1)
//                                            Text(hotItemTest[i].description)
//                                                .foregroundColor(.gray)
//                                                .font(.caption)
//                                                .lineLimit(1)
//                                        }
//                                        Spacer()
//                                    }
//                                }
//                                .padding(5)
//                            }
//                        }
//                    }
//                }else{
//                    Text("抱歉,沒有推薦的電影...")
//                        .foregroundColor(.secondary)
//                        .font(.caption)
//                }
//            }
        }
        else if self.searchVM.isLoading{
            HStack{
                ActivityIndicatorView()
                Text("Loading...")
                    .font(.system(size:14,weight:.semibold))
            }
        } else if self.searchVM.searchResult.isEmpty{
            Text("There are no such movie...")
        } else {
            List(){
                ForEach(self.searchVM.searchResult,id:\.self){ movie in
                    Button(action: {
                        //GO THE Movie Detail Page
                        self.isFocus = false
                        self.searchVM.searchingText = movie.title
                        self.historyManager.updateHistory(query: movie.title)

                    }){
                        HStack(spacing:0){
                            Text(movie.title)
                                .font(.system(size: 14))
                                .bold()
                            
                            Spacer()
                            

                        }
                        .contentShape(Rectangle())
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color("DarkMode2"))
            }
            .listStyle(.plain)
        }
        Spacer()
    }
    
    @ViewBuilder
    private func history(history : [String]) -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(history,id:\.self){key in
                    searchFieldButton(searchingText: key){
                        //TODO: remove all result which are older searching data
                        self.searchVM.searchResult.removeAll()
                        self.searchVM.searchingText = key
                        self.historyManager.updateHistory(query: key)
                        self.isFocus = true //set to focusting...
                    }
                }
                
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func ShowSearchResult() -> some View {
        if searchVM.isLoading && self.searchVM.searchResult.isEmpty {
            HStack{
                Spacer()
                ActivityIndicatorView()
                Spacer()
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(Color("DarkMode2").frame(maxWidth:.infinity))
            
        }else {
            
            FlowLayoutWithLoadMoreView(isLoading: $searchVM.isLoading,list: self.searchVM.searchResult, columns: 2,HSpacing: 10,VSpacing: 15){info in
                Button(action:{
                    DispatchQueue.main.async {
                        self.movieId = info.id
                        self.isShowMovieDetail = true
                    }
                }){
                    MovieCardView(movieData: info)
                        .background(Color("appleDark").edgesIgnoringSafeArea(.all).cornerRadius(8))
                        .task {
                            if self.searchVM.isLastMovie(movieID: info.id){
                                await self.searchVM.getMoreMovieResult()
                            }
                        }
                }
            }
            .frame(maxWidth:.infinity)
            .background(Color("DarkMode2").frame(maxWidth:.infinity))
        }
    }
    


    
    @ViewBuilder
    private func SeachBar() -> some View{
        HStack(spacing:5){
            HStack{
                Button(action:{
                    //Back to the page
                    dissmiss()
                }){
                    Image(systemName: "arrow.left")
                        .imageScale(.medium)
                        .foregroundColor(.gray)
                }
                VStack{
                    Spacer()
                    TextField(self.searchVM.recommandPlachold, text: self.$searchVM.searchingText)
                        .accentColor(.white)
                        .submitLabel(.search)
                        .focused($isFocus)
                        .onSubmit({
                            self.isFocus = false
                            self.historyManager.updateHistory(query: self.searchVM.searchingText)
                            self.searchVM.getMovieSearchResult()
                             
                        })
                    
                    Spacer()
                }.ignoresSafeArea(.keyboard,edges: .bottom)
            }
            .frame(height: 22)
            .padding(.horizontal,5)
//            .background(Color("appleDark"))
            
            Button(action:{
                self.tempQuery = self.searchVM.searchingText
                self.isFocus = true
                self.searchVM.searchingText.removeAll()
            }){
               Image(systemName: "xmark")
                    .imageScale(.small)
                    .padding(5)
                    .background(
                        BlurView(sytle: .systemThickMaterialDark).frame(width: 25, height: 25).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners))
                    )
                    .foregroundColor(.gray)
                
            }
            .padding(.horizontal,8)
            .opacity(self.searchVM.searchingText.isEmpty ? 0 : 1)
            
            
            if self.isFocus {
                Button(action:{
                    //Back To home page
                    if self.searchVM.searchingText.isEmpty {
                        self.searchVM.searchingText = self.tempQuery
                    }
                    
                    self.isFocus = false
                }){
                    Text("取消")
                        .foregroundColor(.gray)
                        .font(.system(size:14,weight: .semibold))
                }
            }
            
        }
        .padding(.horizontal,8)
        .frame(width: UIScreen.main.bounds.width, height: 40)
        .background(Color("DarkMode2"))
        
        
        
    }
    
    @ViewBuilder
    private func SearchHistoryList() -> some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(self.historyManager.history,id:\.self){key in
                    searchFieldButton(searchingText: key){
                        //on tag set query string to this key
                        
                    }
                }
                
            }
            .padding(.horizontal)
        }
    }
}

struct  MovieCardView : View {
    var movieData : Movie
    var body : some  View {
        VStack(alignment:.leading,spacing:5){
            WebImage(url: movieData.posterURL)
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("appleDark"))
                        .aspectRatio(contentMode: .fit)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))
            
            Group {
                VStack(alignment:.leading, spacing:2){
                    Text(movieData.title)
                        .font(.system(size:15,weight:.bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(movieData.releaseDate ?? "Coming Soon")
                        .font(.system(size:12,weight:.semibold))
                        .foregroundColor(.gray)
                }
                .padding(.bottom,5)
                
                HStack(spacing:3){
                    ForEach(1...5,id:\.self){index in
                        Image(systemName: "star.fill")
                            .imageScale(.small)
                            .foregroundColor(index <= Int(movieData.voteAverage)/2 ? .yellow: .gray)
                    }
                    Spacer()
                    Text("(\(Int(movieData.voteAverage)/2).0)")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    
                }
            }
            .padding(5)
        }
        .padding(.bottom,5)
    }
   
}

