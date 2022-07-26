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
    var namespace : Namespace.ID
    var postData : Post
    var action : () -> ()
    var body: some View {
        VStack(alignment:.leading){
            
            Group {
                WebImage(url: postData.post_movie_info.PosterURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "\(postData.user_info.id)_\(postData.post_movie_info.id)_\(postData.create_at)", in: namespace)
                    .transition(.move(edge: .bottom))
                    .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))
                    
                Text(postData.post_title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
    //                    .matchedGeometryEffect(id: postData.post_title, in: namespace)
                    .padding(.vertical,5)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal,5)
            }
            .onTapGesture {
                action()
            }

            Group{
////                Title of the post
//                Text("#\(postData.movie_info.movie_name)")
//                    .font(.system(size: 14))
//                    .foregroundColor(.blue)
//
                
                
                HStack{
                    WebImage(url: postData.user_info.UserPhotoURL)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
//                        .matchedGeometryEffect(id: postData.user_info.user_avatar, in: namespace)
                    
                    Text(postData.user_info.name)
                        .font(.system(size: 12, weight: .semibold))
//                        .matchedGeometryEffect(id: postData.user_info.id, in: namespace)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: self.isLiked ?  "heart.fill" : "heart" )
                        .imageScale(.small)
                        .foregroundColor(self.isLiked ? .red : .gray)
                        .onTapGesture {
                            withAnimation{
                                self.isLiked.toggle()
                            }
                        }
                    Text(postData.post_like_count.description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal,5)
        }
        .padding(.bottom,5)
        .background(Color("appleDark"))
        .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
    }
}
