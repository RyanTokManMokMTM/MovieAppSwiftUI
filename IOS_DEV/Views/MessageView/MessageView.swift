//
//  MessageView.swift
//  IOS_DEV
//
//  Created by Jackson on 28/1/2022.
//

import SwiftUI

//Chatting user Info
struct MessageUser : Identifiable{
    let id = UUID()
    let UserIcons :  UIImage
    let UserName : String

}

//User chatting list
struct ChatInfo : Identifiable {
    var id : UUID
    let user : MessageUser
    var messages : [Message]
    var hasUnrealMsg : Bool = false
}

//Message record
struct Message : Identifiable {
    enum MessageType {
        case Sent,Recevied
    }
    
    let id = UUID()
    let date : Date
    let message : String
    let type : MessageType
    
    init(_ text : String,type : MessageType,date:Date){
        self.date = date
        self.message = text
        self.type = type
    }
    
    init(_ text : String,type : MessageType){
        self.init(text, type: type,date: Date())
    }
}

class MessageViewModel : ObservableObject{
    @Published var ChatList = ChatInfo.simpleChat
    init(){
    }
    
    //Update read flag
    func updateReadMark(_ newValue : Bool ,info : ChatInfo) {
        if let index = self.ChatList.firstIndex(where: {$0.id == info.id}){
            self.ChatList[index].hasUnrealMsg = newValue
        }
    }
    
    func sendMessage(_ text : String, in chat : ChatInfo) -> Message?{
        if let index = self.ChatList.firstIndex(where: {$0.id == chat.id}){
            //find that gay in the list
            let message = Message(text, type: .Sent)
            self.ChatList[index].messages.append(message)
            return message //create a new message instace
        }
        return nil
    }
    
    func messageGrouping(for chat : ChatInfo) ->[[Message]]{
        var result = [[Message]]()
        var temp = [Message]()
        
        for msg in chat.messages{
            if let firstMsg = temp.first{
                let daysBetween = firstMsg.date.daysBetween(date: msg.date)
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

extension ChatInfo{
    static let simpleChat = [
        ChatInfo(id: UUID(), user: MessageUser(UserIcons:  UIImage(named: "icon1")!, UserName: "Charlie"), messages: [
            Message("在嗎?", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("有什麼事麼?", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("想問一下你有沒有看過我的手錶，我記得今天早上跟你出去的時候有戴著。", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("我記得你在吃飯的時候摘了下來，放到包包裡了。", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("喔，是嗎！我去看看喔", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("有了！我看到了，謝謝你🥰🥰🥰", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("要不要一起出去看電影？", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("可能要下週才有看～下週可以嗎", type: .Sent,date: Date(timeIntervalSinceNow: -86400)),
        ], hasUnrealMsg: false),
        
        ChatInfo(id: UUID(), user: MessageUser(UserIcons: UIImage(named: "icon2")!, UserName: "Evans"), messages: [
            Message("你好！我是你班上的同學，有些事情想請教你，不知道會不會打擾到你", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 5)),
            Message("hi,你有遇到了什麼問題麼?", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 5)),
            Message("啊，就是今天上課的內容有些地方有些不了解", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 5)),
            Message("就是數學作業的第三題，我不太懂可以怎麼解。", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("我剛好做完數學作業，我看看題目喔，稍等一下～", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("好的！", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("這一題可能有些複雜，方便打電話嗎？", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("當然可以！", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("十分感謝你！！！", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("不客氣！！！", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 1)),
        ], hasUnrealMsg: true),
        
        ChatInfo(id: UUID(), user: MessageUser(UserIcons: UIImage(named: "icon9")!, UserName: "Brazier"), messages: [
            Message("今天晚上要不要來聊聊他!", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 6)),
            Message("可以啊，什麼時候。", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 6)),
            Message("大概晚上10點左右", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 6)),
            Message("可能要在晚一點點", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 6)),
            Message("好，如果你好了就來我們discord群！。", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 6))
        ], hasUnrealMsg: false),
        
        ChatInfo(id: UUID(), user: MessageUser(UserIcons: UIImage(named: "icon10")!, UserName: "Anderson"), messages: [
            Message("在幹嘛鴨", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 15)),
            Message("有空一起來打有些遊戲嗎?", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 15)),
            Message("等我一下喔！大概5分鐘左右", type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 15)),
            Message("行！好了叫我,帶你飛 😎😎", type: .Recevied,date: Date(timeIntervalSinceNow: -86400 * 15))
        ], hasUnrealMsg: true),
    ]
}

var tempMessage = [
    MessageUser(UserIcons:  UIImage(named: "icon1")!, UserName: "Phoenix Hunter"),
    MessageUser(UserIcons: UIImage(named: "icon2")!, UserName: "Blair Baxter"),
    MessageUser( UserIcons: UIImage(named: "icon3")!, UserName: "Alex Foster"),
    MessageUser(UserIcons: UIImage(named: "icon4")!, UserName: "Haiden Evans"),
    MessageUser(UserIcons: UIImage(named: "icon5")!, UserName: "Jackie Adams"),
    MessageUser(UserIcons: UIImage(named: "icon6")!, UserName: "Danny Hart"),
    MessageUser(UserIcons: UIImage(named: "icon7")!, UserName: "Val Keller"),
    MessageUser(UserIcons: UIImage(named: "icon8")!, UserName: "Ashley Hammond"),
    MessageUser(UserIcons: UIImage(named: "icon9")!, UserName: "Skylar Riddle"),
    MessageUser(UserIcons: UIImage(named: "icon10")!, UserName: "Reed Peterson"),
    

]

struct ChattingView : View{
    @EnvironmentObject var msgVM : MessageViewModel
    let chatInfo : ChatInfo
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
                            .onChange(of: scrollToMessageID){_ in
                                if let msgID = scrollToMessageID {
                                    //if not nil
                                    //scrolling to the msgID
                                    scrollTo(messageID: msgID, shouldAnima: true, scrollViewReader: reader)
                                }
                            }
                            .onAppear(){
                               
                                if let messageID = chatInfo.messages.last?.id{
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
            Image(uiImage: chatInfo.user.UserIcons)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35, alignment: .center)
                .clipShape(Circle())

                Text(chatInfo.user.UserName)
                    .font(.system(size:16))
            }.padding(.trailing)
        )
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            msgVM.updateReadMark(false, info: chatInfo)
//            UITextView.appearance().tintColor = .gray
        }) //updated unread to read
//        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
    
    
    
    @ViewBuilder
    func ToolBar() -> some View{
        VStack{
            HStack{
                TextField("Message...",text:$message)
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
            let sectionMsg = msgVM.messageGrouping(for: chatInfo)
            ForEach(sectionMsg.indices,id:\.self){ sectionIndex in
                let groupingMessage = sectionMsg[sectionIndex]
                Section(header:MessageHeader(firstMessage: groupingMessage.first!)){
                    ForEach(groupingMessage){msg in
                        let isRecevied = msg.type == .Recevied
                        HStack{
                            ZStack{
                                HStack{
                                    if isRecevied{
                                        Image(uiImage: chatInfo.user.UserIcons)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .clipShape(Circle())
                                    }
                                    Text(msg.message)
                                        .font(.system(size:15))
                                        .padding(.horizontal)
                                        .padding(.vertical,12)
                                        .background(isRecevied ? Color("appleDark").opacity(0.85) : Color.blue.opacity(0.9))
                                        .cornerRadius(13)
                                }
                            }
                            .frame(width: width * 0.7, alignment: isRecevied ? .leading : .trailing)
                            .padding(.vertical)
                            
                        }
                        .frame(maxWidth:.infinity,alignment: isRecevied ? .leading : .trailing)
                        .id(msg.id)
                    }
                }
            }
           
            
        }
    }
    
    func sendMessage() {
        if self.message.isEmpty{
            return
        }
        
        if let newMessage = self.msgVM.sendMessage(message, in: chatInfo){
            //set the message to empty
            message = ""
            
            //after created, auto scroll to the message by id
            self.scrollToMessageID = newMessage.id
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
    func MessageHeader(firstMessage msg:Message) -> some View{
        ZStack{
            Text(msg.date.dateDescriptiveString(dataStyle: .medium))
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
    @StateObject private var msgVM = MessageViewModel()
    
    var body: some View {
        GeometryReader{ proxy in
            VStack(spacing:0){
                VStack(spacing:0){
                    VStack{
                        HStack(){
                            Spacer()
                            Text("訊息")
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
                        ForEach(self.msgVM.ChatList,id:\.id){info in
                            ZStack{
                                chatRow(info:info)
                                
                                NavigationLink(destination:ChattingView(chatInfo: info)
                                                .environmentObject(msgVM)
                                ){
                                    EmptyView()
                                }
                                .opacity(0)
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: 0)
                            }
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
                        .onDelete(perform: { indexSet in
                            self.msgVM.ChatList.remove(atOffsets: indexSet)
                        })
                    }
                    .listStyle(.plain)
                    
                    
                    .padding(.top)
                }
                //        }
            }
            .edgesIgnoringSafeArea(.all)
            
        }
        .accentColor(.white)
        .background(Color("DarkMode2").edgesIgnoringSafeArea(.all))
    }
}

struct chatRow : View{
    var info : ChatInfo
    var body: some View{
        HStack(alignment:.top){
            Image(uiImage: info.user.UserIcons)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
            ZStack{
                VStack(alignment:.leading,spacing: 5){
                    HStack{
                        Text(info.user.UserName)
                            .bold()
                            .font(.body)
                            
                        Spacer()
                        
                        Text(info.messages.last?.date.dateDescriptiveString() ?? "")
                            .font(.system(size:14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth:.infinity)
                    
                    HStack{
                        Text(info.messages.last?.message ?? "")
                            .lineLimit(2)
                            .foregroundColor(.gray)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .padding(.trailing,40)
                            .font(.system(size: 15))
                    }
                }
                
                Circle()
                    .foregroundColor(info.hasUnrealMsg ? .blue : .clear)
                    .frame(width: 10, height: 10)
                    .frame(maxWidth : .infinity,alignment: .trailing)
            }
            Spacer()
        }
        .frame(height:80)
       
    }
}

struct MessageHeaderTab : View{
    var body: some View{
        HStack{
            Spacer()
            tabButton(systemIcon: "heart.circle.fill", iconColor: .red, buttonText: "點讚"){
                print("any like")
            }
            Spacer()
            tabButton(systemIcon: "person.fill", iconColor: .blue, buttonText: "新增追蹤"){
                print("any follow")
            }
            Spacer()
            tabButton(systemIcon: "paperplane.fill", iconColor: .orange, buttonText: "評論"){
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
