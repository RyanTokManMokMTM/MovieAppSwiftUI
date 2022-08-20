//
//  MovieSearchView.swift
//  IOS_DEV
//
//  Created by Jackson on 17/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI


class MovieSearchVM : ObservableObject {
    @Published var searchingText : String = "" {
        didSet {
            getMovieSearchResult()
        }
    }
    @Published var searchResult : [Movie] = []//For Result View
    @Published var searchResultPage : Int = 1
    @Published var isLoading : Bool = false
    @Published var fetchingError : NSError?
    @Published var recommandPlachold : String = "奇異博士2：失控多重宇宙"
    
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
            case .failure(let err) :
                print(err.localizedDescription)
                self.fetchingError = err as NSError
            }
        }
    }
    
    func AddToHistory(){}
    
    
}

struct MovieMainSearchView: View {
    @Binding var isSeacrhing : Bool
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    @StateObject private var searchVM  = MovieSearchVM()
    
    @FocusState private var isFocus : Bool
    let gridItems = Array(repeating: GridItem(.flexible(),spacing: 0), count: 2)
    @AppStorage("searchHistory") var history : [String] =  ["Iron man","Dr.Stange"]
    
    @State private var isShowResult : Bool = false
    @State private var finalSearchingQuery = ""
    
    @Environment(\.dismiss) private var dissmiss
    var body: some View {
        VStack{
            SeachBar()
            
            //Contant Data right now... it may chagne in future
            
            if self.searchVM.searchingText.isEmpty  {
                if !history.isEmpty{
                    
                    HStack{
                        Text("搜尋歷史")
                            .fontWeight(.bold)
                            .font(.footnote)
                        Spacer()
                        
                        Button(action:{
                            withAnimation(.easeInOut(duration: 0.3)){
                                //                            self.StateManager.isRemove.toggle()
                                //                            self.StateManager.isFocuse = [false,false]
                            }
                        }){
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    
                    HistorList(history: self.history)
                        .padding(.bottom,5)
                    
                }
                Group{
                    HStack{
                        Text("推薦搜索")
                            .fontWeight(.bold)
                            .font(.footnote)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    
                    
                    if !hotItemTest.isEmpty{
                        LazyVGrid(columns: gridItems){
                            ForEach(0..<hotItemTest.count){ i in
                                //                            SearchHotCard(rank: i+1,rankColor: i <= 3 ? .red : .white, hotData: hotItemTest[i])
                                Button(action:{
                                    //                                self.searchMV.searchResult.removeAll()
                                    //                                self.StateManager.isSeaching.toggle()
                                    //                                self.searchMV.searchingText = hotData.title
                                    //                                self.StateManager.isEditing = false
                                    //                                withAnimation(.easeOut(duration:0.7)){
                                    //                                    self.StateManager.isFocuse = [false,false]
                                    //                                    self.StateManager.getSearchResult = true
                                    //                                }
                                    //                                self.StateManager.updateSearchingHistory(query: hotData.title)
                                    //                                self.searchMV.searchingText = hotData.title
                                    //                                self.searchMV.getSearchingResult()
                                }){
                                    VStack(alignment:.leading){
                                        HStack(spacing:15){
                                            VStack  {
                                                Spacer()
                                                Text("\(i + 1)")
                                                    .bold()
                                                    .font(.footnote)
                                                    .foregroundColor( i <= 3 ? .red : .white)
                                                Spacer()
                                            }
                                            VStack(alignment: .leading, spacing: 10){
                                                Text(hotItemTest[i].title)
                                                    .bold()
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                Text(hotItemTest[i].description)
                                                    .foregroundColor(.gray)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                            }
                                            Spacer()
                                        }
                                    }
                                    .padding(5)
                                }
                            }
                        }
                    }else{
                        Text("抱歉,沒有推薦的電影...")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
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
                           ,isActive: $isShowResult){
                               EmptyView()
                           }
            
        )
        
        
    }
    
    
    @ViewBuilder
    private func SeachBar() -> some View{
        HStack(spacing:5){
            HStack{
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
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
                            self.searchVM.searchingText.removeAll()
                        }
                    })
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
    
    @ViewBuilder
    private func SearchHistoryList() -> some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(self.history,id:\.self){key in
                    searchFieldButton(searchingText: key){
//                        self.searchMV.searchResult.removeAll() //remove previous datas
//                        self.StateManager.isSeaching.toggle()
//                        self.searchMV.searchingText = key
//                        self.StateManager.isEditing = false
//                        withAnimation(.easeOut(duration:0.7)){
//                            self.StateManager.isFocuse = [false,false]
//                            self.StateManager.getSearchResult = true
//                        }
//                        self.searchMV.isNoData = false
//                        self.StateManager.updateSearchingHistory(query: key)
//                        self.StateManager.searchingLoading = true
//                        self.searchMV.getSearchingResult() //get new datas
//

                    }
                }
                
            }
            .padding(.horizontal)
        }
    }
}

struct MovieMainSearchResultView: View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    
    var searchKeyWord : String
    @StateObject private var searchVM : MovieSearchVM = MovieSearchVM()
    @FocusState private var isFocus : Bool
    @AppStorage("searchHistory") var history : [String] =  ["Iron man","Dr.Stange"]
    let gridItems = Array(repeating: GridItem(.flexible(),spacing: 0), count: 2)
    
    @State private var tempQuery = ""
    @State private var isShowMovieDetail : Bool = false
    @State private var movieId : Int = 0
    
    @Environment(\.dismiss) private var dissmiss
    var body: some View {
        VStack{
            SeachBar()
            if isFocus {
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
    }
    
    @ViewBuilder
    func ShowSearchState() -> some View {
        if self.searchVM.searchingText.isEmpty  {
            if !history.isEmpty{
                
                HStack{
                    Text("搜尋歷史")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                    
                    Button(action:{
                        withAnimation(.easeInOut(duration: 0.3)){
//                            self.StateManager.isRemove.toggle()
//                            self.StateManager.isFocuse = [false,false]
                        }
                    }){
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical,5)
                
                HistorList(history: self.history)
                    .padding(.bottom,5)
                
            }
            Group{
                HStack{
                    Text("推薦搜索")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical,5)
                
            
                if !hotItemTest.isEmpty{
                    LazyVGrid(columns: gridItems){
                        ForEach(0..<hotItemTest.count){ i in
//                            SearchHotCard(rank: i+1,rankColor: i <= 3 ? .red : .white, hotData: hotItemTest[i])
                            Button(action:{
//                                self.searchMV.searchResult.removeAll()
//                                self.StateManager.isSeaching.toggle()
//                                self.searchMV.searchingText = hotData.title
//                                self.StateManager.isEditing = false
//                                withAnimation(.easeOut(duration:0.7)){
//                                    self.StateManager.isFocuse = [false,false]
//                                    self.StateManager.getSearchResult = true
//                                }
//                                self.StateManager.updateSearchingHistory(query: hotData.title)
//                                self.searchMV.searchingText = hotData.title
//                                self.searchMV.getSearchingResult()
                            }){
                                VStack(alignment:.leading){
                                    HStack(spacing:15){
                                        VStack  {
                                            Spacer()
                                            Text("\(i + 1)")
                                                .bold()
                                                .font(.footnote)
                                                .foregroundColor( i <= 3 ? .red : .white)
                                            Spacer()
                                        }
                                        VStack(alignment: .leading, spacing: 10){
                                            Text(hotItemTest[i].title)
                                                .bold()
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                            Text(hotItemTest[i].description)
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(5)
                            }
                        }
                    }
                }else{
                    Text("抱歉,沒有推薦的電影...")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
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
    func ShowSearchResult() -> some View {
        if searchVM.isLoading {
            HStack{
                Spacer()
                ActivityIndicatorView()
                Text("Loading...")
                Spacer()
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(Color("DarkMode2").frame(maxWidth:.infinity))
            
        }else {
            FlowLayoutView(list: self.searchVM.searchResult, columns: 2,HSpacing: 10,VSpacing: 15){ info in
                Button(action:{
                    DispatchQueue.main.async {
                        self.movieId = info.id
                        self.isShowMovieDetail = true
                    }
                }){
                    MovieCardView(movieData: info)
                }
            }
            .frame(maxWidth:.infinity)
            .background(Color("DarkMode2").frame(maxWidth:.infinity))
        }
    }
    
    @ViewBuilder
    func MovieCardView(movieData : Movie) -> some View {
        VStack(alignment:.leading,spacing:5){
            WebImage(url: movieData.posterURL)
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(.clear)
                        .aspectRatio(contentMode: .fit)
                        .overlay(Text(movieData.title))
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .clipShape(CustomeConer(width: 5, height: 5, coners: .allCorners))
            
            Group {
                VStack(alignment:.leading, spacing:2){
                    Text(movieData.title)
                        .font(.system(size:18,weight:.bold))
                        .foregroundColor(.white)
                    
                    Text(movieData.releaseDate ?? "Coming Soon")
                        .font(.system(size:12,weight:.semibold))
                        .foregroundColor(.gray)
                }
                .padding(.bottom,8)
                
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
//        .background(Color("appleDark"))
//        .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
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
                TextField(self.searchVM.recommandPlachold, text: self.$searchVM.searchingText)
                    .accentColor(.white)
                    .submitLabel(.search)
                    .focused($isFocus)
                    .onSubmit({
                        self.isFocus = false
                        self.searchVM.getMovieSearchResult()
                    })
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
                ForEach(self.history,id:\.self){key in
                    searchFieldButton(searchingText: key){
//                        self.searchMV.searchResult.removeAll() //remove previous datas
//                        self.StateManager.isSeaching.toggle()
//                        self.searchMV.searchingText = key
//                        self.StateManager.isEditing = false
//                        withAnimation(.easeOut(duration:0.7)){
//                            self.StateManager.isFocuse = [false,false]
//                            self.StateManager.getSearchResult = true
//                        }
//                        self.searchMV.isNoData = false
//                        self.StateManager.updateSearchingHistory(query: key)
//                        self.StateManager.searchingLoading = true
//                        self.searchMV.getSearchingResult() //get new datas
//

                    }
                }
                
            }
            .padding(.horizontal)
        }
    }
}
