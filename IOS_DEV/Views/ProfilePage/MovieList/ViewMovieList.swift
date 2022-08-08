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
    @State var isShowMovieDetail : Bool = false
    @State var movieID : Int = 0
    
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
                            withAnimation{
//                                self.isCreateList = false
                                self.isViewList = false
                            }
                        }){
                           Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action:{
                            
                        }){
                            
                          Text("管理專輯")
                                .font(.system(size:14))
                                .foregroundColor(.white)
                                .padding(.horizontal,15)
//                                .background(Color.red)
                                .cornerRadius(25)
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
                                        Button(action:{
                                            withAnimation{
                                                self.movieID = info.id
                                                self.isShowMovieDetail.toggle()
                                            }
                                        }){
                                            MovieCard(info: info)
                                        }
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
        VStack(alignment:.leading){
            Group {
                WebImage(url: info.posterURL)
                    .placeholder(Image(systemName: "photo"))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(CustomeConer(width: 5, height: 5, coners:.allCorners))
//                    .matchedGeometryEffect(id: postData.id.description, in: namespace)
                    
                
//                VStack{
//                    Text(info.title)
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding(.vertical,5)
//                        .lineLimit(2)
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal,5)
//
//                    HStack(spacing:5){
//                        ForEach(0..<5){i in
//                            Image(systemName:"star.fill" )
//                                .imageScale(.small)
//                                .foregroundColor(i < Int(info.vote_average / 2) ? Color.yellow : Color.gray)
//                                .font(.system(size:12))
//                        }
//                    }
//                }
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
}
