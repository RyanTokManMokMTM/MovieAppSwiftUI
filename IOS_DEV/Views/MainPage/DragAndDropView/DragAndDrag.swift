//
//  AutoScroll.swift
//  IOS_DEV
//
//  Created by 張馨予 on 2021/5/18.
//

import SwiftUI
import UIKit
import MobileCoreServices
import SDWebImageSwiftUI
import CoreHaptics

struct SeachItem : Identifiable,Hashable{
    let id :String = UUID().uuidString
    let itemName : String
}


struct DragAndDropMainView: View {
//    @AppStorage("seachHistory") var history : [String] =  []
    @StateObject var DragAndDropPreview = DragSearchModel()
    
    @EnvironmentObject  var StateManager : SeachingViewStateManager
    @StateObject private var searchMV = SearchBarViewModel()
    @EnvironmentObject var previewModel : PreviewModel
//    @EnvironmentObject var dragSearchModel : DragSearchModel
    //    @StateObject var StateManager  = SeachingViewStateManager()
    //current view state
//    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var selectedPhoto:UIImage? // it may remove and instead with custom view
//    @State private var isCameraDisplay : Bool = false
//    @State private var isShowActionSheet :Bool = false

    init(){
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    var body: some View {
        return
            ZStack(alignment:.bottom){
                NavigationView{
                    VStack(spacing:0){
                        //TODO -DONE
                        if self.StateManager.previewResult{
                            //Loading previeModel preview Data
                            //Toggle preview result state
                            NavigationLink(destination:  MovieDetailView(movieId:self.previewModel.previewData!.id, isShowDetail: .constant(false)), isActive: self.$StateManager.previewResult){
                                EmptyView()
                                
                            }
                        }
                        
                        //TODO -DONE
                        if self.StateManager.previewMoreResult{
                            
                            NavigationLink(destination: MorePreviewResultView(isNavLink: true, backPageName: "Search", isActive: self.$StateManager.previewMoreResult), isActive: self.$StateManager.previewMoreResult){EmptyView()}
                            
                        }
                        
                        //TODO -Working in progress..
                        if self.StateManager.getSearchResult{
                            NavigationLink(
                                destination: SearchResultView(movie: self.searchMV.searchResult)
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true),
                                isActive: self.$StateManager.getSearchResult){EmptyView()}.buttonStyle(.plain)
       
                        }

//                        SearchingBar(isCameraDisplay: self.$isCameraDisplay)
                        SearchingBar()
                           
                        Divider()
                        
                        ZStack(alignment:.top){
                            SeachDragingView()
//                                .background(BlurView(sytle: .systemThickMaterialDark).edgesIgnoringSafeArea(.all))
                                .zIndex(0)
                            
                            //TODO - TestOnly
                            searchingField(history: self.StateManager.history)
                                .padding(.top,5)
                                .background(Color.black.edgesIgnoringSafeArea(.all))
                                .opacity(self.StateManager.isSeaching && !self.StateManager.isEditing ? 1 : 0)
                                .zIndex(1)
                            searchingResultList()
                                .ignoresSafeArea()
                                .background(Color.black.edgesIgnoringSafeArea(.all))
                                .opacity(self.StateManager.isEditing ? 1 : 0)
                                .zIndex(2)
                                
                        }

                    }
                    //                    .zIndex(0)
                    .edgesIgnoringSafeArea(.all)
//                    .fullScreenCover(isPresented: self.$isCameraDisplay){
//                        //show the phone or phone lib as sheet
//                        CameraView(closeCamera : self.$isCameraDisplay)
//                    }
                    .alert(isPresented: self.$StateManager.isRemove){
                        withAnimation(){
                            Alert(title: Text("刪除所有搜尋歷史"), message: Text("確定刪掉?"),
                                  primaryButton: .default(Text("取消")){
                                    self.StateManager.isFocuse = [false,true]
                                  },
                                  secondaryButton: .default(Text("刪除")){
                                    withAnimation{
                                        self.StateManager.removeAllHistory()
                                        self.StateManager.isFocuse = [false,true]
                                    }
                                  })
                        }
                        
                    }
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
                    .navigationTitle(self.StateManager.previewResult ? "Search" : "")
                    .navigationBarTitle(self.StateManager.previewResult ? "Search" : "")
                    .navigationBarHidden(true)
                }
            }
            .environmentObject(searchMV)
            .environmentObject(DragAndDropPreview)
    }
    
}

struct ResultCareVIew : View{
    let movie : Movie
    var body: some View{
        VStack(alignment:.center){
            WebImage(url:  self.movie.posterURL)
                .placeholder(Image(systemName: "photo")) //
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(width:150,height:230)
            
                .cornerRadius(15)
                .clipped()

            VStack(alignment:.center){
                Text(movie.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .font(.system(size: 15))
            .frame(width:150,height:45,alignment: .center)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            
            HStack{
                HStack(spacing:0){
                    if self.movie.genreIds != nil{
                        Text(self.movie.genreStr)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.horizontal,3)
                    }
                    else{
                        Text("n/a...")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .lineLimit(1)
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("DropBoxColor"), lineWidth: 1)
        )
        .background(Color("ResultCardBlack").cornerRadius(10).padding(3))
        .padding(5)
    }
}

struct SearchResultsView : View {
    let movies :[Movie]
    @EnvironmentObject var searchVM : SearchBarViewModel
    @Binding var isShowDetail : Bool
    @Binding var selectedID : Int
    @State private var isLoading : Bool = false
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 10), count: 2)
    var body: some View{
        SearchScrollView(isLoading:self.$isLoading){
            VStack(spacing:0){
                LazyVGrid(columns: gridItem){
                    ForEach(movies,id:\.self){ info in
                        VStack{
                            NavigationLink(destination:   MovieDetailView(movieId:selectedID, isShowDetail: .constant(false)), isActive: self.$isShowDetail){
                                    ResultCareVIew(movie: info)
                                    .onTapGesture(){
                                        self.selectedID = info.id
                                        withAnimation(){
                                            self.isShowDetail.toggle()
                                        }
                                    }
                            }
                        }

                    }
                }
                
                if self.searchVM.isNoData{
                    HStack(spacing:0){
                        Text("已經空空如也...")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.bottom,5)
                } else if self.isLoading {
                    VStack(spacing:0){
                        ActivityIndicatorView()
                    }
                    .padding(.bottom,5)
                }
            }
            

//            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
    }
}

struct searchingResultList :View{
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    var body: some View{
        List(){
            if self.searchMV.searchRecommandResult.count > 0{
                ForEach(self.searchMV.searchRecommandResult,id:\.id){ searchData in
                    Button(action: {
                        self.searchMV.searchingText = searchData.title
                        self.StateManager.isSeaching.toggle()
                        self.StateManager.isFocuse = [false,false]
                        self.StateManager.isEditing.toggle()
                        withAnimation(.easeInOut(duration: 0.3)){
                            self.StateManager.getSearchResult = true
                        }
                        self.StateManager.updateSearchingHistory(query: searchData.title)
                    }){
                        HStack(spacing:0){
                            Text(searchData.title)
                                .font(.system(size: 14))
                                .bold()
                            
                            Spacer()

                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

//TODO - May Change
struct searchingField : View{
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    let gridItems = Array(repeating: GridItem(.flexible(),spacing: 0), count: 2)
    var history : [String]
    var body :some View{
        ScrollView(.vertical, showsIndicators: false){

            if !history.isEmpty{
                
                HStack{
                    Text("搜尋歷史")
                        .fontWeight(.bold)
                        .font(.footnote)
                    Spacer()
                    
                    Button(action:{
                        withAnimation(.easeInOut(duration: 0.3)){
                            self.StateManager.isRemove.toggle()
                            self.StateManager.isFocuse = [false,false]
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
                if !self.searchMV.hotList.isEmpty{
                    LazyVGrid(columns: gridItems){
                        ForEach(0..<self.searchMV.hotList.count){ i in
                            SearchHotCard(rank: i+1,rankColor: i <= 3 ? .red : .white, hotData: self.searchMV.hotList[i])
                            
                        }
                    }
                }else{
                    Text("抱歉,沒有推薦的電影...")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            
  
            Spacer()
        }
        .onAppear(){
            self.searchMV.getHotSeachList()
        }

    }
}

struct HistorList : View{
//    @EnvironmentObject var StateManager : SeachingViewStateManager
//    @EnvironmentObject var searchMV : SearchBarViewModel
    var history :[String]
    var body: some View{

            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(self.history,id:\.self){key in
                        searchFieldButton(searchingText: key){
//                            self.searchMV.searchResult.removeAll() //remove previous datas
//                            self.StateManager.isSeaching.toggle()
//                            self.searchMV.searchingText = key
//                            self.StateManager.isEditing = false
//                            withAnimation(.easeOut(duration:0.7)){
//                                self.StateManager.isFocuse = [false,false]
//                                self.StateManager.getSearchResult = true
//                            }
//                            self.searchMV.isNoData = false
//                            self.StateManager.updateSearchingHistory(query: key)
//                            self.StateManager.searchingLoading = true
//                            self.searchMV.getSearchingResult() //get new datas
                            

                        }
                    }
                    
                }
                .padding(.horizontal)
            }
        }
}

struct SearchHotCard : View{
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    var rank : Int
    var rankColor : Color = .white
    var hotData : SearchHotItem
    var body: some View{
        Button(action:{
            self.searchMV.searchResult.removeAll()
            self.StateManager.isSeaching.toggle()
            self.searchMV.searchingText = hotData.title
            self.StateManager.isEditing = false
            withAnimation(.easeOut(duration:0.7)){
                self.StateManager.isFocuse = [false,false]
                self.StateManager.getSearchResult = true
            }
            self.StateManager.updateSearchingHistory(query: hotData.title)
            self.searchMV.searchingText = hotData.title
            self.searchMV.getSearchingResult()
        }){
            VStack(alignment:.leading){
                HStack(spacing:15){
                    VStack  {
                        Spacer()
                        Text(rank.description)
                            .bold()
                            .font(.footnote)
                            .foregroundColor(rankColor)
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text(hotData.title)
                            .bold()
                            .font(.footnote)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(hotData.description)
                            .foregroundColor(.gray)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    Spacer()
                }
            }
            .padding(5)
        }
//        .frame(maxWidth:.infinity,maxHeight: .infinity)
    }
}

//TODO -NOT USED
struct HStackLayout: View {
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    var list : [String]
    var body: some View {
        VStack{
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.list, id: \.self) { item in
                searchFieldButton(searchingText: item){
                    self.StateManager.isSeaching.toggle()
                    self.searchMV.searchingText = item
                    self.StateManager.isEditing = false
                    withAnimation(.easeOut(duration:0.7)){
                        self.StateManager.isFocuse = [false,false]
                        self.StateManager.getSearchResult = true
                    }
                }
                .padding([.horizontal, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if item == self.list.last! {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if item == self.list.last! {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }
    }

}

struct searchFieldButton : View {
    var searchingText:String
    var action : ()->()
    var body: some View{
        return VStack{
            Button(action:action){
                Text(searchingText)
                    .font(.system(size: 15))
                    .foregroundColor(Color.white)
            }
            .frame(width:getStrWidth(searchingText),height:30)
            .padding(.horizontal,5)
            .background(BlurView())
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 0)
        }
    }

    func getStrWidth(_ str:String)->CGFloat{
        //get current string size
        return str.widthOfStr(Font: .systemFont(ofSize: 15,weight: .bold))
    }
}

struct SearchingMode: View {
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    
    @State private var isDelete:Bool = false
    var body: some View {
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(.horizontal,8)
                
                UITextFieldView(keybooardType: .default, returnKeytype: .search, tag: 1)
                    .frame(height:22)
                
                if self.StateManager.isEditing {
                    Button(action:{
                        withAnimation{
                            self.searchMV.searchingText.removeAll()
                        }
                    }){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(self.StateManager.isSeaching ? 2 : 0)
    }
}

struct SeachingButton: View {
    @EnvironmentObject var StateManager : SeachingViewStateManager
//    @Binding var isCameraDisplay : Bool
    var body: some View {
        HStack(spacing:0){
            Button(action:{
                self.StateManager.isFocuse = [false,true]
                //TO EXPAND THE SEACHING BAR
                self.StateManager.isSeaching.toggle()
                
            }){
                Image(systemName: "magnifyingglass")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(Color("DropBoxColor").clipShape(CustomeConer(coners: [.topLeft,.bottomLeft,.topRight,.bottomRight])))

//            Button(action:{
//                withAnimation{
//                    //just toggle the camera viesw
//                    self.isCameraDisplay.toggle()
//                }
//            }){
//                Image(systemName: "camera")
//                    .padding(10)
//                    .foregroundColor(.white)
//            }
//            .background(Color("DropBoxColor").clipShape(CustomeConer(coners: [.topRight,.bottomRight])))
        }
    }
}

struct SearchingBar: View {
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    
//    @Binding var isCameraDisplay :Bool
    var body: some View {
        HStack(spacing:0){
            if !self.StateManager.isSeaching {
                Text("Search")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }

            HStack{
                if self.StateManager.isSeaching {
                    HStack{
                        Button(action: {
                            self.StateManager.isSeaching.toggle()
                            withAnimation(.easeInOut){
                                self.searchMV.searchingText.removeAll() //for currrent view only
                                self.StateManager.isEditing = false
                                self.StateManager.isFocuse = [false,false]
                            }
                            
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 2)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        
                        SearchingMode()
                    }
                }
                else {
//                    SeachingButton(isCameraDisplay: self.$isCameraDisplay)
                    SeachingButton()
                }
            }
            .padding(self.StateManager.isSeaching ? 2 : 0)
//            .cornerRadius(25)
        }
//        .padding(.top, 50 )
        .padding(.horizontal)
        .padding(.bottom,5)
        .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("DarkMode2"))
    }
}

struct ResultList : View{
    var result : [Movie]
    @Binding var isShowDetail : Bool
    @Binding var selectedID : Int?
    var body: some View{
        HStack{
            ForEach(self.result){ item in
                ResultCardView(isShowDetail: self.$isShowDetail, selectedID: self.$selectedID, movie: item)
            }
        }
    }
}

struct SearchResultView: View {
    @AppStorage("seachHistory") var history : [String] =  []
    
    @EnvironmentObject var StateManager : SeachingViewStateManager
    @EnvironmentObject var searchMV : SearchBarViewModel
    
    @State private var page = 1
    //    @State private var showAsList : Bool = false
    
    @State private var isShowDetail : Bool = false
    @State private var selectedID : Int = 0
    var movie : [Movie]
    var body: some View {
        NavigationView{
            
                VStack(spacing:0){
                    HStack{
                        Button(action: {
                            withAnimation(){
                                if !self.StateManager.isSeaching {
                                    self.StateManager.getSearchResult = false
                                    self.searchMV.searchingText.removeAll()
                                }

                                if !self.StateManager.isEditing{
                                    self.StateManager.getSearchResult = false
                                    self.searchMV.isNoData = false
                                }

                                self.StateManager.isSeaching = false
                                self.StateManager.isEditing = false
                            }
                            
                            

                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 2)

                        if !self.StateManager.isSeaching {
                            HStack{
                                HStack{
                                    Text(self.searchMV.searchingText)
                                        .foregroundColor(.white)
                                        .padding(.leading,5)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .frame(maxWidth:.infinity)
                                .background(Color.black.opacity(0.05))
                                .onTapGesture {
                                    self.StateManager.isFocuse = [false,true]
                                    withAnimation(){
                                        self.StateManager.isSeaching = true
                                        self.StateManager.isEditing = false
                                    }

                                }
                                Spacer()
                                Button(action:{
                                    withAnimation(){
                                        //Clean the text and turn on the search mode
                                        //now is nothing to do
                                        self.StateManager.isSeaching = true
                                        self.searchMV.searchingText.removeAll()
                                        self.StateManager.isFocuse = [false,true]

                                    }
                                }){
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .padding(.horizontal,3)
                                }

                            }
                            .transition(.identity)
                            .padding(.vertical,5)
                        }else{
                            SearchingMode()
                                .padding(.vertical,5)
                        }


                    }
                    .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .padding(.horizontal,8)
                    .padding(.vertical,5)
                    .background(Color("DarkMode2").edgesIgnoringSafeArea(.all))

                    Divider()
                    ZStack(alignment:.top){
                        //show history view
                        searchingField(history: self.history)
                            .padding(.top,5)
                            .ignoresSafeArea()
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .opacity(self.StateManager.isSeaching && !self.StateManager.isEditing ? 1 : 0)
                            .zIndex(1)
                        //                            .transition(.identity)

                        //show seaching recommandation view
                        searchingResultList()
                            .ignoresSafeArea()
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .opacity(self.StateManager.isEditing ? 1 : 0)
                            .zIndex(2)

                        //First time to search and fetching
                        if self.searchMV.isLoading && self.searchMV.searchResult.isEmpty && !self.searchMV.isNoResult{
                            VStack{
                                Spacer()
                                HStack{
                                    ActivityIndicatorView()
                                    Text("Loading...")
                                        .bold()
                                        .font(.caption)
                                }
                                Spacer()
                            }

                        }else if !self.searchMV.isLoading && self.searchMV.isNoResult {
                            //networking is done, but no data and
                            VStack{
                                Text("抱歉,沒有搜尋結果...")
//                                    .foregroundColor(.secondary)
//                                    .font(.body)
                            }
                            .padding(.top,30)


                        }else{
                            SearchResultsView(movies: movie, isShowDetail: self.$isShowDetail, selectedID: self.$selectedID)
                                .transition(.opacity)
                        }


                    }
                }
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .navigationTitle("")
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct MovieResultList : View {
    let movies :[Movie]
    @Binding var isShowDetail : Bool
    @Binding var selectedID : Int?
    var body: some View{
        List{
            ForEach(movies,id:\.self){ movie in
                Button(action:{
                    withAnimation(){
                        self.selectedID = movie.id
                        self.isShowDetail.toggle()
                    }
                }){
                    MovieResultListCell(movie: movie)
                }
            }
            
        }
        .listStyle(PlainListStyle())
    }
}

struct MovieResultListCell : View {
    let movie : Movie
    var body: some View{
        HStack(alignment:.top){
            WebImage(url: movie.posterURL)
                .resizable()
                .placeholder{
                    Text(movie.title)
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.width / 3.5)
                .clipped()
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 6, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 1)
                )
                .cornerRadius(10)
            
            
            
            VStack(alignment:.leading,spacing:10){
                Text(movie.title)
                    .bold()
                    .font(.headline)
                    .lineLimit(1)
                
                Text("Language: \(movie.originalLanguage)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                //Genre
                HStack(spacing:0){
                    Text("Genre: ")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    if self.movie.genres != nil{
                        HStack(spacing:0){
                            ForEach(0..<(movie.genres!.count >= 2 ? 2 : movie.genres!.count)){ i in
                                
                                Text(movie.genres![i].name)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                if i != (movie.genres!.count >= 2 ? 1 : movie.genres!.count - 1){
                                    Text(",")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .lineLimit(1)
                    }else{
                        Text("n/a")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                //actor
                HStack(spacing:0){
                    //at most show 2 genre!
                    Text("Actor: ")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    if self.movie.cast != nil{
                        HStack(spacing:0){
                            ForEach(0..<(self.movie.cast!.count >= 2 ? 2 :  self.movie.cast!.count) ){ i in

                                Text(self.movie.cast![i].name)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)

                                if i != (movie.cast!.count >= 2 ? 1 : self.movie.cast!.count - 1){
                                    Text(",")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .lineLimit(1)
                    }else{
                        Text("n/a")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }

                }
//
                Text("Release: \(movie.releaseDate ?? "Coming soon...")")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Text("Time: \(movie.durationText)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.top,5)
            
            Spacer()
        }

    }
}

struct MovieSeachResultView : View{
    @State private var page = 0
    
    @Binding var isShowDetail : Bool
    @Binding var selectedID : Int?
    var movie : [Movie]
    var body : some View{
        return
            ZStack{
                TabView(selection:$page){
                    ForEach(movie.indices,id:\.self){ i in
                        GeometryReader{proxy in
                            WebImage(url:  movie[i].posterURL)
                                .resizable()
                                .aspectRatio(contentMode:.fill)
                                .frame(width:proxy.size.width,height:proxy.size.height)
                                .cornerRadius(1)
                        }
                        .offset(y:-100)
                    }

                }
                .edgesIgnoringSafeArea(.top)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
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
                
                GeometryReader{proxy in
                    UIHScrollList(width: proxy.frame(in: .global).width, hegiht: proxy.frame(in: .global).height, cardsCount: movie.count, page: self.$page){
                        ResultList(result: movie, isShowDetail: self.$isShowDetail, selectedID: self.$selectedID)
                    }
                }

            }
    }
}

struct ResultCardView: View{
    @Binding var isShowDetail : Bool
    @Binding var selectedID : Int?
    let movie : Movie
    var body : some View{
        VStack{
            VStack(spacing:10){
                Text(movie.title)
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical,3)
                    .padding(.top,5)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                
                //max 3 only
                if movie.genres != nil{
                    HStack(alignment:.center){
                        
                        ForEach(0..<(movie.genres!.count > 3 ? 3 : movie.genres!.count)){i in
                            Text(movie.genres![i].name)
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal,3)
                            if i != (self.movie.genres!.count > 3 ? 2 : movie.genres!.count - 1){
                                Circle()
                                    .frame(width: 5, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.red)
                            }
                            
                        }
                    }
                    .padding(.bottom)
                }else{
                    HStack(alignment:.center){
                        Text("Genre:N/A")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal,3)
                    }
                    .padding(.bottom)
                    
                }
            
                
                WebImage(url: movie.posterURL)
                    .resizable()
                    .placeholder{
                        Text(movie.title)
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .aspectRatio(contentMode: .fit)
                    .frame(width:UIScreen.main.bounds.width / 1.65)
                    .clipped()
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 6, y: 6)
                    .padding(.bottom)
                    
                
                
                HStack(alignment:.center){
                    VStack(alignment:.leading,spacing:3){
                        Text("RELEASE")
                        Text(movie.releaseDate ?? "Comming soon...")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 3){
                        Text("PLAY TIME")
                        Text(movie.durationText)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                    }
                    
                }
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.horizontal,30)
                
                VStack{
                    
                    HStack(){
                        
                        SmallRectButton(title: "Like", icon: "heart", textColor: .white){
                            
                        }
                        
                        Spacer()
                        
                        SmallRectButton(title: "Detail", icon: "ellipsis.circle",buttonColor: Color("BluttonBulue2")){
                            withAnimation(){
                                self.isShowDetail.toggle()
                                self.selectedID = movie.id
                            }
                        }
                       
                    }
                    .padding(.horizontal,20)
                }

                
            }
            .padding(.vertical,15)
            .background(BlurView().cornerRadius(20))
            .padding()
            
        }
        .padding(.horizontal,10)
        .padding(.leading,5)
    }
}

