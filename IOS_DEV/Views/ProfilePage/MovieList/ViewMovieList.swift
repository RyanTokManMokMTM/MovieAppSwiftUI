//
//  ViewMovieList.swift
//  IOS_DEV
//
//  Created by Jackson on 30/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI



struct ViewMovieList: View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var postVM : PostVM
    var listIndex : Int
    @Binding var isViewList : Bool
    @State private var isShowMovieDetail : Bool = false
    @State private var movieID : Int = 0
    @State private var isManageMode : Bool = false
    @State private var isEditList : Bool = false
    @State private var removeMovie : [Int] = []

    init(index : Int,isViewList : Binding<Bool>){
        self.colums = 2
        self.HSpacing = 5
        self.VSpacing = 10
        self.listIndex = index
        self._isViewList = isViewList
        
    }
    
    var colums : Int
    var HSpacing : CGFloat
    var VSpacing : CGFloat
    var body: some View {
        GeometryReader{ proxy in
            VStack(spacing:0){
                VStack{
                    HStack(){
                        Button(action:{
                            if isManageMode {
                                withAnimation{
                                    self.isManageMode = false
                                    updateListMovie()
                                }
                            }else {
                                withAnimation{
                                    self.isViewList = false
                                }
                            }
                        }){
                            if self.isManageMode{
                                
                                Text("完成")
                                    .foregroundColor(.red)
                                    .font(.system(size: 15,weight:.semibold))
                                
                            }else {
                                Image(systemName: "chevron.left")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        
                        if !isManageMode{
                            
                            HStack{
                                Button(action:{
                                    self.isManageMode = true
                                }){
                                    
                                    
                                  Text("管理專輯")
                                        .font(.system(size:14))
                                        .foregroundColor(.white)
                                        .cornerRadius(25)
                                        .padding(.horizontal)
                                }
                                
                                Button(action:{
        //                            self.isManageMode = true
                                    self.isEditList = true
                                }){

                                    Image(systemName: "gearshape")
                                        .foregroundColor(.white)
                                        .imageScale(.large)
//                                        .cornerRadius(25)
                                }
                            }
                            .padding(.horizontal,15)

                        }
                     
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal,10)
                    .padding(.bottom,10)
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                .background(Color("DarkMode2"))
                Divider()
                
                ScrollView(.vertical,showsIndicators: false){
                    VStack(alignment:.leading,spacing:20){
                        
                        VStack(alignment:.leading,spacing:8){
                            Text(self.userVM.profile!.UserCustomList![listIndex].title)
                                .font(.system(size:25,weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(self.userVM.profile!.UserCustomList![listIndex].introStr )
                                .font(.system(size:12))
                                .foregroundColor(.white)
                        }
                        
                        userInfo()
                            .padding(.top,5)
                    }
                    .padding(8)
                    .frame(maxWidth:.infinity)
                    .background(Color("DarkMode2"))
                    
                    
                    if self.userVM.profile!.UserCustomList![listIndex].movie_list == nil || (self.userVM.profile!.UserCustomList![listIndex].movie_list != nil && self.userVM.profile!.UserCustomList![listIndex].movie_list!.count == 0 ) {
                        VStack{
                            Text("您沒有收藏任何電影喔～")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .padding(.vertical)
                    }else {
                        HStack(alignment:.top,spacing:HSpacing){
                            ForEach(customList(),id:\.self){datas in
                                LazyVStack(spacing:VSpacing){
                                    ForEach(datas) { info in
                                        
                                        MovieListCard(info: info, isManageMode: $isManageMode,movieID: $movieID,isShowMovieDetail:$isShowMovieDetail, removeList: $removeMovie)
                                    }
                                }
                            }
                            
                        }
                        .padding(.vertical,5)
                        .padding(.horizontal,3)
                    }
                    
                }
                .frame(maxWidth:.infinity)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .background(
            NavigationLink(destination: MovieDetailView(movieId: self.movieID, isShowDetail: $isShowMovieDetail)
                            .environmentObject(postVM)
                            .environmentObject(userVM)
                           ,isActive: $isShowMovieDetail){
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: EditMovieList(listIndex: listIndex, isBackToRoot:  $isViewList)
                            .environmentObject(userVM)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarHidden(true)
                           , isActive: $isEditList){
                EmptyView()
            }
        )
    }
    
    
    @ViewBuilder
    func userInfo() -> some View {
        HStack(spacing:8){
            WebImage(url: self.userVM.profile!.UserPhotoURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25, alignment: .center)
                .clipShape(Circle())
            Text(self.userVM.profile!.name)
                .font(.system(size:14,weight: .semibold))
                .foregroundColor(Color(UIColor.lightGray))
            
            Spacer()
            
            Text("收藏電影: \(self.userVM.profile!.UserCustomList![listIndex].movie_list == nil ? 0 : self.userVM.profile!.UserCustomList![listIndex].movie_list!.count)")
                .font(.system(size:14,weight: .semibold))
               
        }
        .foregroundColor(Color(UIColor.darkGray))
    }
    
    @ViewBuilder
    func MovieCard(info : MovieInfo) -> some View {
        ZStack(alignment:.topTrailing){
            WebImage(url: info.posterURL)
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .clipShape(CustomeConer(width: 5, height: 5, coners:.allCorners))
            
            if self.isManageMode{
                BlurView(sytle: .systemThinMaterialLight).frame(width: 25, height: 25).clipShape(Circle())
                    
            }
        }

        .background(Color("appleDark"))
        .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
    }
    
    private func customList() -> [[MovieInfo]] {
//        if self.userVM.profile!.UserCustomList![listIndex].movie_list == nil {
//            return [[]]
//        }
//        
        var curIndx = 0
        var gridList : [[MovieInfo]] = Array(repeating: [], count: self.colums)
        self.userVM.profile!.UserCustomList![listIndex].movie_list!.forEach{ data  in
            //each row have colums data
            gridList[curIndx].append(data)
            if curIndx == colums - 1 {
                curIndx = 0
            } else {
                curIndx += 1
            }
        }
        return gridList
    }
    
    private func updateListMovie(){
        if removeMovie.isEmpty {
            return
        }
        
        
        //Send Request!
    }
}

struct MovieListCard : View {
    var info : MovieInfo
    @Binding var isManageMode : Bool
    @Binding var movieID : Int
    @Binding var isShowMovieDetail : Bool
    @Binding var removeList : [Int]
    @State private var isRemove : Bool = false
    
    var body : some View {
        ZStack(alignment:.topTrailing){
            WebImage(url: info.posterURL)
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .clipShape(CustomeConer(width: 5, height: 5, coners:.allCorners))
            
            if self.isManageMode{
                Image(systemName: self.isRemove ? "checkmark.circle.fill" : "circle.fill")
                    .imageScale(.large)
                    .foregroundColor(isRemove ? Color.green : Color.white.opacity(0.5))
                    .zIndex(1)
                    .padding(5)
                    
            }
        }
        .onTapGesture{
            if isManageMode{
                withAnimation{
                    self.isRemove.toggle()
                    //insert into candindate list
                }
                updateList(movieID: info.id)
            }else {
                self.movieID = info.id
                self.isShowMovieDetail.toggle()
            }
        }
        .background(Color("appleDark"))
        .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
    }
    
    private func updateList(movieID : Int){
        if let _ = removeList.first(where: {
            return $0 == movieID
        }) {
         //exit
            let index = removeList.firstIndex(of: movieID)
            removeList.remove(at: index!)
            print("removed id\(movieID)")
        } else {
            //not exist
            removeList.append(movieID)
            print("added id\(movieID)")
        }
    }
    
    
}
