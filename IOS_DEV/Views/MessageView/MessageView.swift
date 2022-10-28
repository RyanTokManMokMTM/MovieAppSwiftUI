//
//  MessageView.swift
//  IOS_DEV
//
//  Created by Jackson on 28/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

class MessageViewModel : ObservableObject{
//    @Published var ChatList = ChatInfo.simpleChat
    @Published var rooms : [ChatData] = []
    @Published var currentTalkingRoomID : Int = 0 //0 means user not in any room
    static var shared = MessageViewModel() //share in whole app for now

    private init(){}
    
    func FindChatRoom(roomID : Int) -> Int{
        if let index = rooms.firstIndex(where: {
            return roomID == $0.id
        }) {
            return index
        }
        
        return -1
    }
    
    func GetUserRooms(){
        APIService.shared.GetUserRooms(){result in
            switch result{
            case .success(let data):
                print(data.rooms)
                self.rooms = data.rooms
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //Update read flag
    func updateReadMark(_ newValue : Bool ,info : ChatData) {
//        if let index = self.rooms.firstIndex(where: {$0.RoomUUID == info.RoomUUID}){
//            self.ChatList[index].hasUnrealMsg = newValue
//        }
    }
    
    func addNewMessage(roomID : Int, message : MessageInfo){
        if let index = self.rooms.firstIndex(where: {$0.id == roomID}){
            //find that gay in the list
//            let message = Message(text, type: .Sent)
//            self.ChatList[index].messages.append(message
            print(message)
            self.rooms[index].messages.append(message)
//            for msg in self.rooms[index].messages {
//                print(msg.message)
//            }
//
        }
    }
    
    func sendMessage(_ text : String,sender : Int, in chat : ChatData) -> MessageInfo?{
        if let index = self.rooms.firstIndex(where: {$0.id == chat.id}){
            //find that gay in the list
//            let message = Message(text, type: .Sent)
//            self.ChatList[index].messages.append(message)
            let message = MessageInfo(id: UUID().uuidString, message: text, sender_id: sender, sent_time: Int(Date().timeIntervalSince1970))
            self.rooms[index].messages.append(message)
            //calling websocket send function
            let req = MessageReq(opcode: WebsocketOpCode.OpText.rawValue, message_id: message.id, group_id: chat.id, message: message.message, sent_time: message.sent_time)
            WebsocketManager.shared.onSend(message: req)
            return message //create a new message instace
        }
        return nil
    }
    
    func messageGrouping(for messages : [MessageInfo]) ->[[MessageInfo]]{
        var result = [[MessageInfo]]()
        var temp = [MessageInfo]()
        
        for msg in messages{
            if let firstMsg = temp.first{
                let daysBetween = firstMsg.SendTime.daysBetween(date: msg.SendTime)
                if daysBetween >= 1{
                    //large then a day
                    result.append(temp)
                    temp.removeAll()
                    temp.append(msg)
                }else{
                    //Today message
                    temp.append(msg)
                }
            } else {
                //there is not any message in the tmep array
                temp.append(msg)
            }
        }
        result.append(temp)
    
        return result
    }
}

struct ChattingView : View{
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var msgVM : MessageViewModel
    let chatInfo : ChatData
    let roomId : Int
//    let messageID : Int
    @Binding var roomMessages : [MessageInfo]
    private let colum = [GridItem(.flexible(minimum: 10))]
    
    @State private var message : String = ""
    @FocusState private var isFocus
    
    @State private var scrollToMessageID : UUID?
    var body: some View{
        VStack{
            GeometryReader{proxy in
                ScrollView{
                    ScrollViewReader{reader in
                        getMessageView(width: proxy.size.width)
                            .padding(.horizontal)
                            .onChange(of: roomMessages.count){_ in
                                if let msgID = roomMessages.last?.RoomUUID {
                                    //if not nil
                                    //scrolling to the msgID
                                    scrollTo(messageID: msgID, shouldAnima: true, scrollViewReader: reader)
                                }
                            }
               
 
                            .onAppear(){
//
                                if let messageID = roomMessages.last?.RoomUUID{
                                    scrollTo(messageID: messageID, anchor: .bottom,shouldAnima: false, scrollViewReader: reader)
                                }
                            }
                    }
                    
                }
            }
            
            //            .background(Color("appleDark"))
            
            ToolBar()
        }
//        .ignoresSafeArea(.all,edges: .bottom)
        .padding(.top,1)
        .navigationBarItems(leading:HStack{
            AsyncImage(url: chatInfo.users[0].UserPhotoURL){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ActivityIndicatorView()
            }
            .frame(width: 40,height:40)
            .clipShape(Circle())
            .clipped()

            Text(chatInfo.users[0].name)
                .font(.system(size:16))
            }.padding(.trailing)
        )
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.white)
        .onAppear(){
            self.msgVM.currentTalkingRoomID = roomId
        }
        .onDisappear(){
            self.msgVM.currentTalkingRoomID = 0
        }
        
    }
    

    @ViewBuilder
    func ToolBar() -> some View{
        VStack{
            HStack{
                TextField("訊息",text:$message)
                    .padding(.horizontal)
                    .frame(height:37)
                    .background(BlurView())
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocus)
                
                //Send Button
                Button(action:{
                    //send the message
                    sendMessage()
                }){
                    Image(systemName: "paperplane.fill")
                        .foregroundColor( .white)
                        .frame(width: 37, height: 37)
                        .background(
                            Circle()
                                .foregroundColor( .blue)
                        )
                        .disabled(message.isEmpty)
                }
            }
            .frame(height: 37)
        }
        .padding()
        .background(.thickMaterial)
    }
    
    @ViewBuilder
    func getMessageView(width : CGFloat) -> some View{
        
        LazyVGrid(columns: colum,spacing:0){
            let sectionMsg = MessageViewModel.shared.messageGrouping(for: roomMessages)
            ForEach(sectionMsg.indices,id:\.self){ sectionIndex in
                let groupingMessage = sectionMsg[sectionIndex]
                
                if !groupingMessage.isEmpty {
                    Section(header:MessageHeader(firstMessage: groupingMessage.first!)){
                        ForEach(groupingMessage,id:\.RoomUUID){msg in
                            let isRecevied = msg.sender_id != self.userVM.userID!
                            HStack{
                                ZStack{
                                    HStack{
                                        if isRecevied{
                                            AsyncImage(url: chatInfo.users[0].UserPhotoURL){ image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                ActivityIndicatorView()
                                            }
                                            .frame(width: 35, height: 35, alignment: .center)
                                            .clipShape(Circle())
                                            .clipped()
                                        }
                                        
                                        if isRecevied{
                                            HStack(alignment:.bottom){
                                                Text(msg.message)
                                                    .font(.system(size:15))
                                                    .padding(.horizontal)
                                                    .padding(.vertical,12)
                                                    .background(isRecevied ? Color("appleDark").opacity(0.85) : Color.blue.opacity(0.9))
                                                    .cornerRadius(13)
                                                Text(msg.SendTime.sendTimeString())
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 12,weight: .regular))
                                                    .padding(.horizontal,3)
                                            }
                                                
                                        }else {
                                            HStack(alignment:.bottom){
                                                Text(msg.SendTime.sendTimeString())
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 12,weight: .regular))
                                                    .padding(.horizontal,3)
                                                Text(msg.message)
                                                    .font(.system(size:15))
                                                    .padding(.horizontal)
                                                    .padding(.vertical,12)
                                                    .background(isRecevied ? Color("appleDark").opacity(0.85) : Color.blue.opacity(0.9))
                                                    .cornerRadius(13)
                                            }
                                        }

                                        
                                                
                                        

                                    }
                                }
                                .frame(width: width * 0.7, alignment: isRecevied ? .leading : .trailing)
                                .padding(.vertical,8)

                            }
                            .frame(maxWidth:.infinity,alignment: isRecevied ? .leading : .trailing)
                            .id(msg.RoomUUID)
                        }
                    }
                }
            }
            
            


        }
    }
    
    func sendMessage() {
        if self.message.isEmpty{
            return
        }
        
        if let newMessage = MessageViewModel.shared.sendMessage(message, sender: self.userVM.userID!, in: self.chatInfo){
            //set the message to empty
            message = ""
            print(newMessage)
            
            //after created, auto scroll to the message by id
            self.scrollToMessageID = newMessage.RoomUUID
        }
    }
    
    func scrollTo(messageID : UUID,anchor : UnitPoint? = nil,shouldAnima : Bool,scrollViewReader : ScrollViewProxy){
        DispatchQueue.main.async {
            withAnimation(shouldAnima ? .easeIn : nil){
                scrollViewReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    @ViewBuilder
    func MessageHeader(firstMessage msg: MessageInfo) -> some View{
        ZStack{
            Text(msg.SendTime.dateDescriptiveString(dataStyle: .medium))
                .foregroundColor(.gray)
                .font(.system(size: 14,weight: .regular))
                .frame(width: 120)
                .padding(.vertical,5)
//                .background(Capsule().foregroundColor(Color("appleDark")))
                
        }
        .padding(.vertical)
        .frame(maxWidth:.infinity)
    }

}

struct MessageView: View {
    @StateObject var HubState : BenHubState = BenHubState.shared
    @StateObject private var notificationVM  = NotificationVM()
    @StateObject private var msgVM = MessageViewModel.shared
    @EnvironmentObject private var userVM : UserViewModel
    @State private var newChat = false
    @State private var isShowLikesNotification : Bool = false
    @State private var isShowFollowingNotification : Bool = false
    @State private var isShowCommentNotification : Bool = false
    var body: some View {
        GeometryReader{ proxy in
            VStack(spacing:0){
                VStack(spacing:0){
                    VStack{
                        HStack(){
                            Spacer()
                            Text("訊息與通知")
                            Spacer()
                            
                        }
                        .font(.system(size:15))
                        .padding(.horizontal,5)
                        .padding(.bottom,10)
                        .overlay(){
                            HStack{
                                Spacer()
                                Button(action:{
                                    withAnimation{
                                        self.newChat = true
                                    }
                                }){
                                    Text("新聊天")
                                        .font(.system(size:13))
                                        .padding(.horizontal,5)
                                        .padding(.bottom,10)
                                    
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                    Divider()
                    
                    MessageHeaderTab(isShowLikesNotification: $isShowLikesNotification, isShowFollowingNotification: $isShowFollowingNotification, isShowCommentNotification: $isShowCommentNotification)
                        .padding(.top)
                        
//                    if self.msgVM.rooms != nil {
                        List(){
                            ForEach(0..<MessageViewModel.shared.rooms.count, id: \.self){i in
//                                ZStack{
                                NavigationLink(destination:ChattingView(chatInfo: msgVM.rooms[i],roomId: msgVM.rooms[i].id, roomMessages: $msgVM.rooms[i].messages)
                                    .environmentObject(userVM)
                                    .environmentObject(msgVM)
                                ){
                                    chatRow(info:msgVM.rooms[i])
                                        .navigationTitle("")
                                        .navigationBarHidden(true)
                                        
                                }
//                                }
                                .listRowBackground(Color("DarkMode2"))

                                //                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                //                                    Button(action:{
                                //                                        self.msgVM.updateReadMark(!info.hasUnrealMsg, info: info)
                                //                                    }){
                                //                                        if info.hasUnrealMsg{
                                //                                            Label("Read", image: "text.bubble")
                                //                                        }else{
                                //                                            Label("Unread", image: "circle.fill")
                                //                                        }
                                //                                    }
                                //                                    .tint(.blue)
                                //                                }

                            }
//                            .onDelete(perform: { indexSet in
//                                self.msgVM.ChatList.remove(atOffsets: indexSet)
//                            })
                        }
                        .listStyle(.plain)
                        .padding(.top)
//                    }
                }
                //        }
            }
            .edgesIgnoringSafeArea(.all)
            .environmentObject(notificationVM)
            
        }
        .fullScreenCover(isPresented: $newChat){
            NewChatView(isNewChat: $newChat)
        }
        .accentColor(.white)
        .background(Color("DarkMode2").edgesIgnoringSafeArea(.all))
        .wait(isLoading: $HubState.isWait){
            BenHubLoadingView(message: HubState.message)
        }
        .alert(isAlert: $HubState.isPresented){
            switch HubState.type{
            case .normal,.system_message:
                BenHubAlertView(message: HubState.message, sysImg: HubState.sysImg)
            case .notification:
                BenHubAlertWithFriendRequest(user: HubState.senderInfo!, message: HubState.message)
            case .message:
                BenHubAlertWithMessage(user: HubState.senderInfo!, message: HubState.message)
            }
        }
    }
}

struct chatRow : View{
//    var info : ChatInfo
    var info : ChatData
    var body: some View{
        HStack(alignment:.center,spacing: 8){
            AsyncImage(url: info.users[0].UserPhotoURL){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ActivityIndicatorView()
            }
            .frame(width: 45,height:45)
            .clipShape(Circle())
            .clipped()
            .overlay(alignment: .topTrailing) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 10, height: 10)
            }


            
            VStack(alignment:.leading,spacing: 5) {
              
                HStack{
                    Text(info.users[0].name)
                        .bold()
                        .font(.system(size: 18))
                        
                    Spacer()
                    
                    if !info.messages.isEmpty{
                        Text(info.messages.last?.SendTime.dateDescriptiveString() ?? "UNKNOW")
                            .font(.system(size:12))
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth:.infinity)
//                Spacer()
                
//                if !info.messages.isEmpty{
                    HStack{
                        Text(info.messages.isEmpty ? "" : info.messages.last?.message ?? "" )
                            .lineLimit(1)
                            .foregroundColor(.gray)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .padding(.trailing,40)
                            .font(.system(size: 15,weight: .semibold))
                            .padding(.top,4)
                    }
//                }
            }
        }
        .frame(height:70)
       
    }
}

struct MessageHeaderTab : View{
    @EnvironmentObject private var notificationVM : NotificationVM
    @Binding var isShowLikesNotification : Bool
    @Binding var isShowFollowingNotification : Bool
    @Binding var isShowCommentNotification : Bool
    
    var body: some View{
        HStack{
            Spacer()
            NavigationLink(destination: LikesNotificationView(isShowView: $isShowLikesNotification)
                            .navigationBarBackButtonHidden(true)
                            .navigationTitle("")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                           ,isActive: $isShowLikesNotification){
                ZStack(alignment:.topTrailing){
                    tabButton(systemIcon: "heart.circle.fill", iconColor: .red, buttonText: "點讚"){
                        withAnimation{
                            self.isShowLikesNotification = true
                        }
                    }
                    
                    Text("10")
                        .font(.system(size: 12,weight: .medium))
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(Color.red)
                        )
                        .offset(x: 5, y: -5)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: FollowingNotification(isShowView:$isShowFollowingNotification)
                            .navigationBarBackButtonHidden(true)
                            .navigationTitle("")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(notificationVM)
                           ,isActive: $isShowFollowingNotification){
                ZStack(alignment:.topTrailing){
                    tabButton(systemIcon: "person.fill", iconColor: .blue, buttonText: "新增追蹤"){
                        withAnimation{
                            self.isShowFollowingNotification = true
                        }
                    }
                    
                    Text("8")
                        .font(.system(size: 12,weight: .medium))
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(Color.red)
                        )
                        .offset(x: 5, y: -5)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: CommentNotificationView(isShowView: $isShowCommentNotification)
                            .navigationBarBackButtonHidden(true)
                            .navigationTitle("")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                           ,isActive: $isShowCommentNotification){
                ZStack(alignment:.topTrailing){
                    tabButton(systemIcon: "paperplane.fill", iconColor: .orange, buttonText: "評論"){
                        withAnimation{
                            self.isShowCommentNotification = true
                        }
                    }
                    
                    Text("1")
                        .font(.system(size: 12,weight: .medium))
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(Color.red)
                        )
                        .offset(x: 5, y: -5)
                }
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
                    .background(BlurView()
                                    .clipShape(CustomeConer(width: 10, height: 10, coners: [.allCorners]))
                    )
//                    .overlay(
//                        ZStack(alignment:.topLeading){
//                            Circle()
//                                .fill(.red)
//                                .frame(width: 12, height: 12)
//                                .overlay(
//                                    Text("10")
//                                        .font(.system(size: 10))
//                                )
//                        }
//                    )
                }
            }
            
            
            Text(buttonText)
                .font(.footnote)
        }
    }
}

