//
//  NewChatView.swift
//  IOS_DEV
//
//  Created by Jackson on 25/10/2022.
//

import SwiftUI



struct NewChatView: View {
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var msgVM : MessageViewModel
    @State private var friends : [FriendInfo] = []
    @Binding var isNewChat : Bool
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                ZStack{
                    VStack(alignment:.leading){
                        VStack{
                            HStack(){
                                Button(action:{
                                    withAnimation{
                                        self.isNewChat = false
                                    }
                                }){
                                    Text("取消")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                }
                                Spacer()
                                Text("新聊天")
                                    .font(.system(size: 14))
                                Spacer()
                                
                            }
                            .font(.system(size: 14))
                            .padding(.horizontal,10)
                            .padding(.bottom,10)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
    //                    .background(Color("appleDark"))
    //                    Divider()
                        
                        List(friends, id:\.id){ info in
                            NavigationLink(destination: NewChattingView(chatUserInfo: info.info, roomId: info.id)
                                .environmentObject(userVM)
                                .environmentObject(msgVM)
                            ){
                                HStack{
                                    AsyncImage(url: info.info.UserPhotoURL){ image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ActivityIndicatorView()
                                    }
                                    .frame(width: 40,height:40)
                                    .clipShape(Circle())
                                    .clipped()
                    
                                    
                                    Text(info.info.name)
                                        .bold()
                                        .font(.system(size: 16))
                                }
                                .padding(.vertical,5)
                            }
                        

                        }.listStyle(.plain)
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                }
            }
            .onAppear{
                APIService.shared.GetFriendRoomList(){ result in
                    switch result{
                    case .success(let data):
                        self.friends = data.lists
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationTitle("")
            .navigationBarHidden(true)
            
        }
    }
}

struct NewChattingView : View{
    @EnvironmentObject private var userVM : UserViewModel
    @EnvironmentObject private var msgVM : MessageViewModel
    var chatUserInfo : SimpleUserInfo
    @State private var chatInfo : ChatData? = nil
    let roomId : Int
//    let messageID : Int
    @State private var roomMessages : [MessageInfo] = []
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
            AsyncImage(url: chatUserInfo.UserPhotoURL){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ActivityIndicatorView()
            }
            .frame(width: 40,height:40)
            .clipShape(Circle())
            .clipped()

            Text(chatUserInfo.name)
                .font(.system(size:16))
            }.padding(.trailing)
        )
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.white)
        .onAppear(){
            msgVM.currentTalkingRoomID = roomId
            GetRoomInfo()
        }.onDisappear(){
            msgVM.currentTalkingRoomID = 0
        }

        
    }
    
    private func GetRoomInfo(){
        APIService.shared.GetRoomInfo(req: GetRoomInfoReq(roome_id: roomId)){ result in
            switch result {
            case .success(let data):
                self.chatInfo = data.info
                self.roomMessages = data.info.messages
            case .failure(let err):
                print(err.localizedDescription)
            }
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
                                            AsyncImage(url: self.chatUserInfo.UserPhotoURL){ image in
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
        if self.message.isEmpty || self.chatInfo == nil{
            return
        }

     
        if let newMessage = MessageViewModel.shared.sendMessage(message, sender: self.userVM.userID!, in: self.chatInfo!){
            //set the message to empty
            message = ""
            print(newMessage)

            self.roomMessages.append(newMessage)
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
        }
        .padding(.vertical)
        .frame(maxWidth:.infinity)
    }

}
