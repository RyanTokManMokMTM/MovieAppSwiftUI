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
    var postData : Post
    var namespace : Namespace.ID
    var action : () -> ()
    var body: some View {
        VStack(alignment:.leading){
            
            Group {
                WebImage(url: postData.post_movie_info.PosterURL)
                    .placeholder(Image(systemName: "photo")) //
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    
                    .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))
//                    .matchedGeometryEffect(id: postData.id.description, in: namespace)
                    
                    
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

                HStack{
                    WebImage(url: postData.user_info.UserPhotoURL)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .clipShape(Circle())

                    Text(postData.user_info.name)
                        .font(.system(size: 12, weight: .semibold))
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
