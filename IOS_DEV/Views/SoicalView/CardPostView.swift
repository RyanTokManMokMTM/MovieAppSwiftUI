//
//  CardPostView.swift
//  IOS_DEV
//
//  Created by Jackson on 9/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardPostView: View {
    @State private var isLiked : Bool = false
    @EnvironmentObject var postVM : PostVM
    var Id : Int
    var action : () -> ()
    var body: some View {
        VStack(alignment:.leading,spacing:5){
            
            Group {
                WebImage(url: self.postVM.postData[Id].post_movie_info.PosterURL)
                    .placeholder {
                        Rectangle()
                            .foregroundColor(Color("appleDark"))
                            .aspectRatio(contentMode: .fit)
                    }
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))
//                    .matchedGeometryEffect(id: postData.id.description, in: namespace)
                    
                    
                Text(self.postVM.postData[Id].post_title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
    //                    .matchedGeometryEffect(id: postData.post_title, in: namespace)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal,5)
            }
            .onTapGesture {
                action()
            }

            
            HStack{
                WebImage(url: self.postVM.postData[Id].user_info.UserPhotoURL)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 20,maxWidth: 20)
                    .clipShape(Circle())
                
                Text(self.postVM.postData[Id].user_info.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: self.postVM.postData[Id].is_post_liked ?  "heart.fill" : "heart" )
                    .imageScale(.small)
                    .foregroundColor(self.postVM.postData[Id].is_post_liked ? .red : .gray)
                    .onTapGesture {
                        withAnimation{
                            if self.postVM.postData[Id].is_post_liked {
                                UnLikePost()
                            }else {
                                LikePost()
                            }
                            //                                self.isLiked.toggle()
                        }
                    }
                Text(self.postVM.postData[Id].post_like_count.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            .padding(.horizontal,5)
        }
        .padding(.bottom,5)
        .background(Color("appleDark"))
        .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
    }
    
    
    private func UnLikePost(){
        self.postVM.postData[Id].is_post_liked = false
        self.postVM.postData[Id].post_like_count =  self.postVM.postData[Id].post_like_count - 1
        let req = RemovePostLikesReq(post_id: self.postVM.postData[Id].id)
        APIService.shared.RemovePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post unliked")
            case .failure(let err):
                self.postVM.postData[Id].is_post_liked = true
                self.postVM.postData[Id].post_like_count =  self.postVM.postData[Id].post_like_count + 1
                print(err.localizedDescription)
            
            }
        }
        
    }
    
    private func LikePost(){
        self.postVM.postData[Id].is_post_liked = true
        self.postVM.postData[Id].post_like_count =  self.postVM.postData[Id].post_like_count + 1
        let req = CreatePostLikesReq(post_id: self.postVM.postData[Id].id)
        APIService.shared.CreatePostLikes(req: req){ result in
            switch result {
            case .success(_):
                print("post likes")
            case .failure(let err):
                self.postVM.postData[Id].is_post_liked = false
                self.postVM.postData[Id].post_like_count =  self.postVM.postData[Id].post_like_count - 1
                print(err.localizedDescription)
            
            }
        }
    }
}
