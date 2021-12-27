//
//  ActorAvatarList.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//


import SwiftUI
import SDWebImageSwiftUI

struct ActorAvatarList: View {
    var actorList : [MovieActor]
    var body:some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(){
                ForEach(0..<actorList.count){index in
                    Avatar(actorList: actorList[index])
                        
                }
            }
            
        }
    }
}

struct ActorAvatarList_Previews: PreviewProvider {
    static var previews: some View {
        ActorAvatarList(actorList: ActorLists)
    }
}

struct Avatar:View{
    var actorList : MovieActor
    var body:some View{
        VStack(spacing:5){
            WebImage(url: URL(string:actorList.actorAvatorImage))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(lineWidth: 1.0)
                        .foregroundColor(.purple)

                )
            
            Group{
                Text(actorList.actorName)
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                //    .multilineTextAlignment(.center)
                    .frame(width:120)
                
                Text(actorList.actorCharactorName)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
    }
}
