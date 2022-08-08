//
//  OtherUserProfile.swift
//  IOS_DEV
//
//  Created by Jackson on 7/8/2022.
//

import SwiftUI
import SDWebImageSwiftUI

//same as person profile
//but fetching all data when appear
//
//class UserProfileManager : ObservableObject {
//    @Published var profile : Profile?
//    @Published var isFecthingProfile : Bool
//    @Published var FetchingProfileErr : Error?
//    private var userID : Int
//    init(){
//    }
//    
//    func SetUserID(userId : Int){
//        self.userID = userId
//    }
//    
//    func GetUserProfile(){
//        
//    }
//}
//
//struct OtherUserProfile: View {
//    @StateObject var userVM = UserProfileManager()
//    var userID : Int
//    var body: some View {
//        GeometryReader{proxy in
//            let topEdge = proxy.safeAreaInsets.top
//            UserProfileView(topEdge: topEdge)
//                .ignoresSafeArea(.all, edges: .top)
//        }
//        .onAppear{
//            self.userVM.SetUserID(userId: userID)
//        }
//    }
//}
//
//struct UserProfileView : View {
//    @EnvironmentObject var userVM : UserProfileManager
//    
//    private let max = UIScreen.main.bounds.height / 2.5
//    var topEdge : CGFloat
//    @State private var offset:CGFloat = 0.0
//    @State private var menuOffset:CGFloat = 0.0
//    @State private var isShowIcon : Bool = false
//    @State private var tabBarOffset = UIScreen.main.bounds.width
//    @State private var tabOffset : CGFloat = 0.0
//    @State private var tabIndex : Int = 0
//    @State private var listIndex : Int = 0
//    @State private var isViewMovieList : Bool = false
//    
//
//    
//    var body: some View {
//        ZStack(alignment:.top){
//            ZStack{
////                it may add in the Future
//                HStack{
//                    Button(action:{}){
//                        Image(systemName: "line.3.horizontal")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .frame(height: topEdge)
//                .padding(.top,30)
//                .zIndex(1)
//                
//                VStack(alignment:.center){
//                    Spacer()
//                    HStack{
//                        WebImage(url: userVM.profile!.UserPhotoURL)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .clipShape(Circle())
//                        
//                        Text(userVM.profile?.name)
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
//                .transition(.move(edge: .bottom))
//                .offset(y:self.isShowIcon ? 0 : 40)
//                .padding(.trailing,20)
//                .frame(width:UIScreen.main.bounds.width ,height: topEdge)
//                .padding(.top,30)
//                .zIndex(10)
//                .clipped()
//            }
//            .background(Color("ResultCardBlack").opacity(getOpacity()))
//            .zIndex(1)
//            
//            GeometryReader { proxy in
//                ScrollView(showsIndicators: false){
//                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
//                        GeometryReader{ proxy  in
//                            ZStack(alignment:.top){
//                                WebImage(url: userVM.profile!.UserBackGroundURL)
//                                    .resizable()
//                                    .aspectRatio( contentMode: .fill)
//                                    .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
//                                    .scaleEffect(offset > 0 ? (offset / 500) + 1 : 1)
//                                    .overlay(
//                                        LinearGradient(colors: [
//                                            Color("PersonCellColor").opacity(0.3),
//                                            Color("PersonCellColor").opacity(0.6),
//                                            Color("PersonCellColor").opacity(0.8),
//                                            Color("PersonCellColor"),
//                                            Color.black
//                                        ], startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
//                                            .scaleEffect(offset > 0 ? (offset / 500) + 1 : 1)
//                                    )
//                                  
//                                    .zIndex(0)
//                                
//                                
//                                profile()
//                                    .frame(maxWidth:.infinity)
//                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
//                                    .zIndex(1)
//                                
//                            }
//                        }
//                        .frame(height:max)
//                        .offset(y:-offset)
//                        
//                        Section {
//                            switch tabIndex{
//                            case 0:
//                                OtherPersonPostCardGridView()
//                                    .padding(.vertical,3)
//                                        .environmentObject(userVM)
//                            case 1:
//                                LikedPostCardGridView()
//                                    .environmentObject(userVM)
//                                    .padding(.vertical,3)
//                                    .onAppear{
//                                        if userVM.profile!.UserLikedMovies == nil{
//                                            userVM.getUserLikedMovie()
//                                        }
//                                    }
//                            case 2:
//                                CustomListView(addList: $isAddingList,isViewMovieList:$isViewMovieList, listIndex:$listIndex)
//                                    .environmentObject(userVM)
//                                    .padding(.vertical,3)
//                                    .onAppear{
//                                        if userVM.profile!.UserCustomList == nil{
//                                            userVM.getUserList()
//                                        }
//                                    }
//                            default:
//                                EmptyView()
//                            }
//                        
//            
//                        } header: {
//                            VStack(spacing:0){
//                                //
//                                PersonPostTabBar(tabIndex: $tabIndex)
//                                Divider()
//                            }
//                            .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
//                            .overlay(
//                                GeometryReader{proxy -> Color in
//                                    let minY = proxy.frame(in: .global).minY
//                                    
//                                    DispatchQueue.main.async {
//                                        self.menuOffset = minY
//                                    }
//                                    return Color.clear
//                                }
//                            )
//                        }
//                        
//                        
//                        
//                    }
//                    .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
//                    .frame(alignment:.top)
//                }
//                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
//                .zIndex(0)
//                .onAppear{
//                    self.userVM.getUserPosts()
//                    
//                }
//            }
//            
//        }
//        .background(
//            NavigationLink(destination:ViewMovieList(index: listIndex, isViewList: $isViewMovieList)
//                            .environmentObject(userVM)
//                            .environmentObject(postVM)
//                            .navigationTitle("")
//                            .navigationBarTitle("")
//                            .navigationBarHidden(true)
//                            .navigationBarBackButtonHidden(true)
//                           ,isActive:$isViewMovieList){
//                               EmptyView()
//                           }
//        )
//        
//        
//    }
//    
//    
//    private func getHeaderHigth() -> CGFloat{
//        //setting the height of the header
//        
//        let top = max + offset
//        //constrain is set to 80 now
//        // < 60 + topEdge not at the top yet
//        return top > (40 + topEdge) ? top : 40 + topEdge
//    }
//    
//    private func getOpacity() -> CGFloat{
//        let progress = -(offset + 40 ) / 70
//        return -offset > 40  ?  progress : 0
//    }
//}
//
//struct OtherPersonPostCardGridView : View{
////    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
//    @EnvironmentObject var userVM : UserViewModel
//    @EnvironmentObject var postVM : PostVM
//    var body: some View{
//        if userVM.profile!.UserCollection == nil {
//            if self.userVM.IsPostLoading {
//                LoadingView(isLoading: self.userVM.IsPostLoading, error: self.userVM.PostError as NSError?){
//                    self.userVM.getUserPosts()
//                }
//            }
//        } else if userVM.profile!.UserCollection != nil{
//            if userVM.profile!.UserCollection!.isEmpty{
//                VStack{
//                    Spacer()
//                    Text("Not Post yet")
//                        .font(.system(size:15))
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//                .frame(height:UIScreen.main.bounds.height / 2)
//            }else{
//                FlowLayoutView(list: userVM.profile!.UserCollection!, columns: 2,HSpacing: 5,VSpacing: 10){ info in
//                
//                    profileCardCell(post: info)
//                        .onTapGesture {
//                            withAnimation{
//                                postVM.selectedPost = info
//                                postVM.isShowPostDetail = true
//                            }
//                        }
//                }
//                .background(
//                    NavigationLink(destination:   PostDetailView(namespace: namespace)
//                                    .navigationBarTitle("")
//                                    .navigationTitle("")
//                                    .navigationBarBackButtonHidden(true)
//                                    .navigationBarHidden(true)
//                                    .environmentObject(postVM), isActive: self.$postVM.isShowPostDetail){
//                        EmptyView()
//                        
//                    }
//                )
//                
//
//                
//            }
//            
//        }
//    }
//        
//}
//
//
//struct OtherLikedPostCardGridView : View {
//    @EnvironmentObject var userVM : UserViewModel
//    @EnvironmentObject var postVM : PostVM
//    @State private var isShowMovieDetail : Bool = false
//    @State private var movieId : Int = -1
//    
//    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
//    var body: some View{
//        VStack{
//            if userVM.IsLikedMovieLoading || userVM.LikedError != nil{
//                LoadingView(isLoading: userVM.IsLikedMovieLoading, error: userVM.ListError as NSError?){
//                    self.userVM.getUserLikedMovie()
//                }
//            } else if userVM.profile!.UserLikedMovies != nil{
//                if userVM.profile!.UserLikedMovies!.isEmpty{
//                    VStack{
//                        Spacer()
//                        Text("You have't liked any movies yet!")
//                            .font(.system(size:15))
//                            .foregroundColor(.gray)
//                        Spacer()
//                    }
//                    .frame(height:UIScreen.main.bounds.height / 2)
//
//                }else{
//                    LazyVGrid(columns: gridItem){
//                        ForEach(userVM.profile!.UserLikedMovies!,id:\.id){info in
//                            Button(action:{
//                                self.movieId = info.id
//                                withAnimation{
//                                    self.isShowMovieDetail = true
//                                }
//                            }){
//                                LikedCardCell(movieInfo: info)
//                            }
//                        }
//                        
//                    }
//                }
//            }
//        }
//        .background(
//        
//            NavigationLink(destination: MovieDetailView(movieId: self.movieId, isShowDetail: $isShowMovieDetail)
//                            .environmentObject(userVM)
//                            .environmentObject(postVM)
//                            .navigationBarTitle("")
//                            .navigationTitle("")
//                            .navigationBarHidden(true)
//                           ,isActive: $isShowMovieDetail){
//                EmptyView()
//            }
//        )
//    }
//}
