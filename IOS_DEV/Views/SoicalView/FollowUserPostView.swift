//
//  FollowUserPostView.swift
//  IOS_DEV
//
//  Created by Jackson on 15/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowUserPostView: View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @State private var isShowMovieDetail = false
    @State private var movieId = -1
    
    @State private var isShowMorePostDetail : Bool = false
    @State private var postId : Int = -1
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            
            if postVM.followingData.isEmpty {
                VStack{
                    Text("You haven't follow any people yet")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.vertical)
            }else {
                ForEach(self.postVM.followingData){ info in
                    FollowPostCell(isShowMovieDetail: $isShowMovieDetail, movieId: $movieId,info: info, isShowMorePostDetail:self.$isShowMorePostDetail, postId: self.$postId)
                        .padding(.bottom,10)
                }
//                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom )

            }
        }
        .SheetWithDetents(isPresented:  self.$isShowMorePostDetail, detents: [.medium(),.large()]){
            self.isShowMorePostDetail = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.postId = 0
            }
        } content : {
            PostBottomSheet(isShowMorePostDetail: $isShowMorePostDetail,postId:postId)
                .environmentObject(postVM)
                .environmentObject(userVM)
        }
        .frame(maxWidth:.infinity)
        .background(Color("DarkMode2"))
        .background(
            NavigationLink(destination: MovieDetailView(movieId: movieId, isShowDetail: $isShowMovieDetail)
                            .environmentObject(postVM)
                            .environmentObject(userVM)

                           , isActive: $isShowMovieDetail){
                EmptyView()
            }
        )

    }
}


struct FollowPostCell : View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @State private var commentText : String = ""
    
    @Binding var isShowMovieDetail : Bool
    @Binding var movieId : Int
    
    var info : Post
    @Binding var isShowMorePostDetail : Bool
    @Binding var postId : Int
    
    @State private var moreText : Bool = false
    @State private var isShowAll = false
    var body: some View{
        VStack(spacing:10){
            UserInfoCell()
            UserPostInfo()
        }
        .padding(.vertical,5)
        .frame(width: UIScreen.main.bounds.width)

    }
    
    @ViewBuilder
    func UserInfoCell() -> some View{
        HStack(alignment:.center){
            WebImage(url:info.user_info.UserPhotoURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())

            HStack(alignment:.center, spacing:10){
                Text(info.user_info.name)
                    .font(.system(size: 16, weight: .semibold))
                Text(info.post_at.dateDescriptiveString())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: {
                //TODO: DO SOME MORE THING??
            }){
                Image(systemName: "ellipsis")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .disabled(true)
            
            
        }
        .padding(.horizontal,10)
    }
    
    @ViewBuilder
    func UserPostInfo() -> some View {
        VStack(alignment: .leading,spacing: 8){
//                TabView(selection:$index){
            WebImage(url:info.post_movie_info.PosterURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth:.infinity,maxHeight: UIScreen.main.bounds.height / 2.2)
            
//            PostButton()
            
            HStack{
                Button(action:{
                    withAnimation{
                        self.isShowMovieDetail = true
                    }
                    self.movieId = info.post_movie_info.id
                }){
                    Text("#\(info.post_movie_info.title)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.top,5)
                }
                Spacer()
                PostButton()
            }

            HStack(alignment:.bottom){
                Text(info.post_desc)
                    .lineLimit(self.isShowAll ? nil : 1)
                    .background(
                        Text(info.post_desc).lineLimit(1)
                            .background(GeometryReader { visibleTextGeometry in
                                ZStack { //large size zstack to contain any size of text
                                    Text(info.post_desc)
                                        .background(GeometryReader { fullTextGeometry in
                                            Color.clear.onAppear {
                                                self.moreText = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                            }
                                        })
                                        
                                }
                                .frame(height: .greatestFiniteMagnitude)
                               
                            })
                            .hidden() //keep hidden
                )
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top,5)
                    .foregroundColor(Color(uiColor: UIColor.lightGray))
  
                if moreText && !isShowAll{
                    Button(action:{
                        //TODO: A BOTTON SHEET SHOW COMMENT LIST AND INFO
//                        self.postId = info.id
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                            withAnimation{
//                                self.isShowMorePostDetail = true
//                            }
//                        }
                        withAnimation{
                            self.isShowAll = true
                        }
                    }){
                        Text("顯示全部")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
            
//            HStack{
//                WebImage(url: userVM.profile!.UserPhotoURL) //user???
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 30, height: 30)
//                    .clipShape(Circle())
//
//                HStack{
//                    TextField("喜歡的就留下您的評論", text: $commentText)
//                        .font(.system(size: 14))
//                        .padding(.horizontal,5)
//                        .submitLabel(.done)
//                }
//
//
//            }
//            .padding(5)
//            .background(.ultraThinMaterial)
//            .clipShape(CustomeConer(width: 25, height: 25, coners: [.allCorners]))
//            .padding(.top)
        }
        .padding(.horizontal,10)

    }
    
    @ViewBuilder
    func PostButton() -> some View {
        HStack(alignment:.center){
//            Button(action:{
//                //TODO: SHARE - NOT
//            }){
//                HStack{
//                    Image(systemName: "square.and.arrow.up")
//                        .imageScale(.medium)
//                }
//                .foregroundColor(.white)
//            }
//            .disabled(true)
            Spacer()
            
            HStack(spacing:10){
                Button(action:{
                    //TODO: Like the post
                }){
                    HStack(spacing:5){
                        Image(systemName: "heart")
                            .imageScale(.medium)
                        Text(info.post_like_count.description)
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                }
                
                Button(action:{
                    self.postId  = info.id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        withAnimation{
                            self.isShowMorePostDetail = true
                        }
                    }
                }){
                    HStack(spacing:5){
                        Image(systemName: "text.bubble")
                            .imageScale(.medium)
                        Text(info.post_comment_count.description)
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                }
            }

        }

    }

}
