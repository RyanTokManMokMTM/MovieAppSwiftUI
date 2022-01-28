//
//  MessageView.swift
//  IOS_DEV
//
//  Created by Jackson on 28/1/2022.
//

import SwiftUI

struct MessageUser : Identifiable{
    let id : Int
    let UserIcons :  UIImage
    let UserName : String
    let LatestMessage : String
}

var tempMessage = [
    MessageUser(id: 1, UserIcons:  UIImage(named: "icon1")!, UserName: "Phoenix Hunter", LatestMessage: "我們有相同愛好欸!"),
    MessageUser(id: 2, UserIcons: UIImage(named: "icon2")!, UserName: "Blair Baxter", LatestMessage: "我對你的電影片單十分感興趣。"),
    MessageUser(id: 3, UserIcons: UIImage(named: "icon3")!, UserName: "Alex Foster", LatestMessage: "是否能交個朋友呢"),
    MessageUser(id: 4, UserIcons: UIImage(named: "icon4")!, UserName: "Haiden Evans", LatestMessage: "感謝你的分享！"),
    MessageUser(id: 5, UserIcons: UIImage(named: "icon5")!, UserName: "Jackie Adams", LatestMessage: "已追蹤你"),
    MessageUser(id: 6, UserIcons: UIImage(named: "icon6")!, UserName: "Danny Hart", LatestMessage: "謝謝你的片單，我現在已經上癮了"),
    MessageUser(id: 7, UserIcons: UIImage(named: "icon7")!, UserName: "Val Keller", LatestMessage: "如果可以我們可以交流一下"),
    MessageUser(id: 8, UserIcons: UIImage(named: "icon8")!, UserName: "Ashley Hammond", LatestMessage: "謝謝你"),
    MessageUser(id: 9, UserIcons: UIImage(named: "icon9")!, UserName: "Skylar Riddle", LatestMessage: "如果你也對我的片單有興趣，也可以點個愛心"),
    MessageUser(id: 10, UserIcons: UIImage(named: "icon10")!, UserName: "Reed Peterson", LatestMessage: "嘿嘿，感謝你追蹤我"),
    

]

struct ChattingView : View{
    var body: some View{
        GeometryReader{proxy in
            VStack{
                HStack(){
                    Button(action:{
                        withAnimation(){
                        }
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.medium)
                    }
                    Text("Jackson_tmm")
                    Spacer()

                }
                .font(.system(size:15))
                .padding(.horizontal,5)
                .padding(.bottom,10)
            }
            .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MessageView: View {
    @State private var temp : [MessageUser] = tempMessage
    var body: some View {
        
        NavigationView{
            GeometryReader{proxy in
                VStack(spacing:0){
                    VStack(spacing:0){
                        VStack{
                            HStack(){
                                Spacer()
                                Text("Message")
                                Spacer()
                                
                            }
                            .font(.system(size:15))
                            .padding(.horizontal,5)
                            .padding(.bottom,10)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                        Divider()
                        MessageHeaderTab()
                            .padding(.top)
                        
                        List(){
                            
                            ForEach(temp,id:\.id){userInfo in
                                Button(action:{
                                    print("chat to ")
                                }){
                                    ChatIcon(info: userInfo)
                                }
                                .padding(.vertical,5)

                            }
                            .onDelete(perform: { indexSet in
                                temp.remove(atOffsets: indexSet)
                            })
                        }.listStyle(.plain)
                            .padding(.top)
                    }
                    //        }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
       
    }
}

struct ChatIcon : View{
    var info : MessageUser
    var body: some View{
        HStack(alignment:.center){
            Image(uiImage: info.UserIcons)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding(.trailing,5)
            
            VStack(alignment:.leading,spacing: 5){
                Text(info.UserName)
                    .lineLimit(1)

                Text(info.LatestMessage)
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Spacer()
        }
       
    }
}

struct MessageHeaderTab : View{
    var body: some View{
        HStack{
            Spacer()
            tabButton(systemIcon: "heart.circle.fill", iconColor: .red, buttonText: "Likes & Collects"){
                print("any like")
            }
            Spacer()
            tabButton(systemIcon: "person.fill", iconColor: .blue, buttonText: "New Followers"){
                print("any follow")
            }
            Spacer()
            tabButton(systemIcon: "paperplane.fill", iconColor: .orange, buttonText: "Comments"){
                print("any comment")
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func tabButton(systemIcon : String,iconColor : Color,buttonText : String,action :@escaping  ()->() )-> some View{
        VStack{
            Button(action:action){
                VStack{
                    HStack{
                        Image(systemName: systemIcon)
                            .foregroundColor(iconColor)
                            .font(.title2)
                            .imageScale(.medium)
                    }
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(BlurView().clipShape(CustomeConer(width: 10, height: 10, coners: [.allCorners])))
                }
            }
            Text(buttonText)
                .font(.footnote)
        }
    }
}


struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
