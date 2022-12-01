//
//  MessageView.swift
//  IOS_DEV
//
//  Created by Jackson on 28/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
import CachedAsyncImage

class MessageViewModel : ObservableObject{
//    @Published var ChatList = ChatInfo.simpleChat
    @Published var rooms : [ChatData]  = []
    @Published var currentTalkingRoomID : Int = 0 //0 means user not in any room
    @Published var isInit = false
    var sortedChat : [ChatData] {
        var toBeSort = rooms
        toBeSort.sort(by: { ( first, second) in
            if first.last_sent != nil && second.last_sent != nil {
                return first.last_sent! > second.last_sent!
            }
            
            return false
        })
        
        return toBeSort
    }
    
    func findIndex(roomId : Int) -> Int{
        let idx = rooms.firstIndex(where: {$0.id == roomId})
        return idx!
    }
    
    func checkRoom(roomId : Int) -> Int?{
        let idx = rooms.firstIndex(where: {$0.id == roomId})
        return idx
    }
    
    static var shared = MessageViewModel() //share in whole app for now

    private init(){
        self.rooms = []
    }
    
    func FindChatRoom(roomID : Int) -> Int{
        if let index = rooms.firstIndex(where: {
            return roomID == $0.id
        }) {
            return index
        }
        
        return -1
    }
    
    func GetUserRooms(){
        if isInit {
            return
        }
        
        APIService.shared.GetUserRooms(){result in
            switch result{
            case .success(let data):
                print(data.rooms)
                self.isInit = true
                self.rooms = data.rooms
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //Update read flag
    func updateReadMark(_ newValue : Bool ,info : ChatData) {
        
        APIService.shared.SetIsRead(req: SetIsReadReq(room_id: info.id)){ result in
            switch result{
            case .success(_):
                if let index = self.rooms.firstIndex(where: { $0.id == info.id}){
                    DispatchQueue.main.async {
                        self.rooms[index].is_read = newValue
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        //Calling api

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
        
            let message = MessageInfo(id: UUID().uuidString, msg_identity: 0, message: text, sender_id: sender, sent_time: Int(Date().timeIntervalSince1970))
            if let index = self.rooms.firstIndex(where: {$0.id == chat.id}){
                self.rooms[index].messages.append(message)
                let req = MessageReq(opcode: WebsocketOpCode.OpText.rawValue, message_id: message.id, group_id: chat.id, message: message.message, sent_time: message.sent_time)
                WebsocketManager.shared.onSend(message: req)
                return message //create a new message instace
            }
            DispatchQueue.main.async {
                var newChat = chat
                newChat.messages.append(message)
                self.rooms.append(newChat)
            }
            let req = MessageReq(opcode: WebsocketOpCode.OpText.rawValue, message_id: message.id, group_id: chat.id, message: message.message, sent_time: message.sent_time)
            WebsocketManager.shared.onSend(message: req)
            return message //create a new message instace
        
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
    
    func isLastMessage(messageID : Int,charRoomID : Int) -> Bool {
        return self.rooms[charRoomID].messages.first?.msg_identity == messageID
    }
}

struct ChattingView : View{
//    @State private var messageMetaData : MetaData? = nil
    @State private var isLoading = false
    @EnvironmentObject private var userVM : UserViewModel
    @EnvironmentObject private var msgVM : MessageViewModel
    let chatId : Int
//    let chatInfo : ChatData
    let roomId : Int
//    let messageID : Int
    private let colum = [GridItem(.flexible(minimum: 10))]
    @State private var isSend = false
    
    @State private var message : String = ""
    @FocusState private var isFocus
    
    @State private var scrollToMessageID : UUID?
    var body: some View{
        VStack{
            GeometryReader{proxy in
                ScrollViewReader{reader in
                    ScrollView(.vertical,showsIndicators: true){
                        getMessageView(width: proxy.size.width)
                            .padding(.horizontal)
                            .onChange(of: self.msgVM.rooms[chatId].messages.count){_ in
                                if !isSend {
                                    return
                                }
                                
                                if let msgID = self.msgVM.rooms[chatId].messages.last?.RoomUUID {
                                    //if not nil
                                    //scrolling to the msgID
                                    isSend = false
                                    scrollTo(messageID: msgID, shouldAnima: true, scrollViewReader: reader)
                                }
                            }
                            .onAppear(){
                                if let messageID = self.msgVM.rooms[chatId].messages.last?.RoomUUID{
                                    print(messageID)
                                    scrollTo(messageID: messageID, anchor: .bottom,shouldAnima: false, scrollViewReader: reader)
                                }
                            }
                    }
                    //load more room???
                }
            }

            
            ToolBar()
        }
//        .ignoresSafeArea(.all,edges: .bottom)
        .padding(.top,1)
        .navigationBarItems(leading:HStack{
            AsyncImage(url: self.msgVM.rooms[self.chatId].users[0].UserPhotoURL){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ActivityIndicatorView()
            }
            .frame(width: 40,height:40)
            .clipShape(Circle())
            .clipped()

            Text(self.msgVM.rooms[self.chatId].users[0].name)
                .font(.system(size:16))
            }.padding(.trailing)
        )
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.white)
        .onAppear(){
            self.msgVM.currentTalkingRoomID = roomId
            self.msgVM.updateReadMark(true,info: self.msgVM.rooms[self.chatId])
        }
        .onDisappear(){
            self.msgVM.currentTalkingRoomID = 0
        }
//        .task{
//            print("again?????")
////            await self.GetRoomMessage()
//        }
//
    }
    
    @MainActor
    private func GetRoomMessage() async {
        //TODO: we need to get the last id which id is the first message in messageInfo
//        let last_id = self.roomMessages.
//        let resp = await APIService.shared.AsyncGetRoomMessage(req: GetRoomMessageReq(room_id: self.roomId, last_id: 0))
//        switch resp {
//        case .success(let data):
////            self.roomMessages
//            print(data.messages)
////            print(data.meta_data) /
//            self.roomMessages = data.messages
////            self.messageMetaData = data.meta_data
//        case .failure(let err):
//            print(err.localizedDescription)
//            //Show err???
//        }
    }
    
    @MainActor
    private func loadMoreMessage() async {
        
        if  self.msgVM.rooms[self.chatId].meta_data.total_pages ==  self.msgVM.rooms[self.chatId].meta_data.page {
            return
        }
        self.isLoading = true
        //TODO: we need to get the last id which id is the first message in messageInfo
        let lastID =  self.msgVM.rooms[chatId].messages.first?.msg_identity ?? 0
//        print(lastID)
        let resp = await APIService.shared.AsyncGetRoomMessage(req: GetRoomMessageReq(room_id: self.roomId, last_id: lastID),page:  self.msgVM.rooms[self.chatId].meta_data.page + 1)
        switch resp {
        case .success(let data):
            self.msgVM.rooms[chatId].messages.insert(contentsOf: data.messages.reversed(), at: 0)
            self.msgVM.rooms[self.chatId].meta_data.page +=  1
//            print(data.messages)
        case .failure(let err):
            print(err.localizedDescription)
            //Show err???
        }
        
        self.isLoading = false
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
                    .submitLabel(.send)
                    .onSubmit{
                        sendMessage()
                    }
                
                //Send Button
                Button(action:{
                    //send the message
                    DispatchQueue.main.async {
                        self.isSend = true
                        sendMessage()
                    }
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
        
        VStack{
            if self.isLoading {
                ActivityIndicatorView()
                    .padding(.top,15)
            }
            LazyVGrid(columns: colum,spacing:0){
                let sectionMsg = MessageViewModel.shared.messageGrouping(for: self.msgVM.rooms[chatId].messages)
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
                                              
                                                AsyncImage(url: self.msgVM.rooms[self.chatId].users[0].UserPhotoURL){ image in
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
                                                    
                                                    AsyncImage(url: self.userVM.profile!.UserPhotoURL){ image in
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
                                                
                                                
                                            }

                                            
                                                    
                                            

                                        }
                                    }
                                    .frame(width: width * 0.8, alignment: isRecevied ? .leading : .trailing)
                                    .padding(.vertical,8)

                                }
                                .frame(maxWidth:.infinity,alignment: isRecevied ? .leading : .trailing)
                                .id(msg.RoomUUID)
                                .task{
//                                    self.isLoading = true
                                    if self.msgVM.isLastMessage(messageID: msg.msg_identity, charRoomID: self.chatId) {
                                        await self.loadMoreMessage()
                                    }
                                }
                            }
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
        
        if let newMessage = MessageViewModel.shared.sendMessage(message, sender: self.userVM.userID!, in: self.msgVM.rooms[self.chatId]){
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
//                    Divider()
                    
                    MessageHeaderTab(isShowLikesNotification: $isShowLikesNotification, isShowFollowingNotification: $isShowFollowingNotification, isShowCommentNotification: $isShowCommentNotification)
                        .padding(.top)
                        
//                    if self.msgVM.rooms != nil {
                        List(){
                            //Sort by last_message time!
                            ForEach(msgVM.sortedChat, id: \.id){ info in
//                                ZStack{
                                NavigationLink(destination:ChattingView(chatId: self.msgVM.findIndex(roomId: info.id),roomId: info.id)
                                    .environmentObject(userVM)
                                    .environmentObject(msgVM)

                                ){
                                    chatRow(info:info)
                                        .navigationTitle("")
                                        .navigationBarHidden(true)

                                }
                                .listRowBackground(Color("DarkMode2"))
                                .swipeActions(edge: .trailing,allowsFullSwipe: true){
                                    Button(action:{
                                        self.msgVM.rooms.remove(at: self.msgVM.findIndex(roomId: info.id))
                                        
                                        //TODO: Here we need to update server side too
                                        
                                    }){
                                        Text("刪除")
                                            .fontWeight(.semibold)
                                    }
                                    .tint(.red)
                                    
                                    if !info.is_read {
                                        Button(action:{
                                            self.msgVM.rooms[self.msgVM.findIndex(roomId: info.id)].is_read = true
                                            
                                            //TODO: Here we need to update server side too
                                            
                                        }){
                                           Text("已讀")
                                                .fontWeight(.semibold)
                                        }
                                        .tint(.blue)
                                    }
                                    
                                }
                            }
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
                .environmentObject(userVM)
                .environmentObject(msgVM)
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
                BenHubAlertWithUserInfo(user: HubState.senderInfo!, message: HubState.message)
            case .message:
                BenHubAlertWithMessage(user: HubState.senderInfo!, message: HubState.message)
            }
        }
    }
}

struct chatRow : View{
//    var info : ChatInfo
    @EnvironmentObject private var userVM : UserViewModel
    var info : ChatData
    var body: some View{
        HStack(alignment:.center,spacing: 8){
//            AsyncImage(url: info.users[0].UserPhotoURL){ image in
//                image
//                    .resizable()
//                    .scaledToFill()
//            } placeholder: {
//                ActivityIndicatorView()
//            }
//            .frame(width: 45,height:45)
//            .clipShape(Circle())
//            .clipped()
            WebImage(url: info.users[0].UserPhotoURL)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 45, height: 45, alignment: .center)
            .clipShape(Circle())
            .overlay(alignment: .topTrailing) {
                //not read and sender exist and not sender
                Circle()
                    .foregroundColor(!self.info.is_read && self.info.last_sender_id != 0 && self.info.last_sender_id != self.userVM.userID! ? .blue : .clear)
                    .frame(width: 12, height: 12)
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
    @EnvironmentObject private var userVM : UserViewModel
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
                            .environmentObject(notificationVM)
                            .environmentObject(userVM)
                           ,isActive: $isShowLikesNotification){
//                ZStack(alignment:.topTrailing){
                    tabButton(systemIcon: "heart.circle.fill", iconColor: .red, buttonText: "點讚"){
                        withAnimation{
                            self.isShowLikesNotification = true
                        }
                    }
                    .overlay(alignment: .topTrailing){
                        if userVM.profile!.notification_info!.likes_notification_count > 0{
                            Text(userVM.profile!.notification_info!.likes_count)
                                .font(.system(size: 10,weight: .medium))
                                .frame(width: 22, height: 22)
                                .background(
                                    Circle()
                                        .fill(Color.red)
                                )
                                .offset(x: 5, y: -5)
                        }
                          
                    }

//                }
            }
            
            Spacer()
            
            NavigationLink(destination: FollowingNotification(isShowView:$isShowFollowingNotification)
                            .navigationBarBackButtonHidden(true)
                            .navigationTitle("")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(notificationVM)
                            .environmentObject(userVM)
                           ,isActive: $isShowFollowingNotification){
                    tabButton(systemIcon: "person.fill", iconColor: .blue, buttonText: "好友邀請"){
                        withAnimation{
                            self.isShowFollowingNotification = true
                        }
                    }
                    .overlay(alignment: .topTrailing){
                        if userVM.profile!.notification_info!.friend_notification_count > 0{
                            Text(userVM.profile!.notification_info!.friend_count)
                                .font(.system(size: 10,weight: .medium))
                                .frame(width: 22, height: 22)
                                .background(
                                    Circle()
                                        .fill(Color.red)
                                )
                                .offset(x: 5, y: -5)
                        }
                           
                    }
            }
            
            Spacer()
            
            NavigationLink(destination: CommentNotificationView(isShowView: $isShowCommentNotification)
                            .navigationBarBackButtonHidden(true)
                            .navigationTitle("")
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(notificationVM)
                            .environmentObject(userVM)
                           ,isActive: $isShowCommentNotification){
                    tabButton(systemIcon: "paperplane.fill", iconColor: .orange, buttonText: "評論"){
                        withAnimation{
                            self.isShowCommentNotification = true
                        }
                    }
                    .overlay(alignment: .topTrailing){
                        if userVM.profile!.notification_info!.comment_notification_count > 0{
                            Text(userVM.profile!.notification_info!.comment_count)
                                .font(.system(size: 10,weight: .medium))
                                .frame(width: 22, height: 22)
                                .background(
                                    Circle()
                                        .fill(Color.red)
                                )
                                .offset(x: 5, y: -5)
                        }
                           
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

