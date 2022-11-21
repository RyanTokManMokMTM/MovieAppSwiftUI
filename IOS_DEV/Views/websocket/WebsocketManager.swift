//
//  WebsocketManager.swift
//  IOS_DEV
//
//  Created by Jackson on 24/10/2022.
//

import Foundation
import SwiftUI
import Combine

enum WebsocketOpCode : UInt8 {
    case OpContinuation  = 0x0
    case OpText          = 0x1
    case OpBinary        = 0x2
    case OpClose         = 0x8
    case OpPing          = 0x9
    case OpPong          = 0xa
    
    var value: UInt8 {
        return self.rawValue
    }
}

enum MessageType : Int {
    case SYSTEM  = 0
    case MESSAGE          = 1
    case FRIEND        = 2
    case COMMENT         = 3
    case LIKES          = 4
    
    var value: Int {
        return self.rawValue
    }
}

struct MessageResp : Decodable{
    let opcode : UInt8
    let message_type : Int
    let message_id : String
    let group_id : Int
    let to_user : Int
    let user_id : Int
    let sender_info : SimpleUserInfo
    let content : String
    let send_time : Int
}

struct SenderData : Decodable{
    let user_id : Int
    let user_name : String
}

struct MessageReq : Encodable{
    let opcode : UInt8
    let message_id : String
    let group_id : Int
    let message : String
    let sent_time : Int
}

//struct ChatMessage : Identifiable{
//    let id = UUID().uuidString
//    let content : String
//}

class WebsocketManager : ObservableObject{
    @AppStorage("userToken") var token : String = ""
    private let TTL = 5  //5 ping
    static var shared = WebsocketManager()
    private var cancellable : AnyCancellable?
    var userVM : UserViewModel? {
        didSet{
            print("setting up user vm in websocket as object...")
            self.objectWillChange.send()
            cancellable = userVM?.objectWillChange.sink(receiveValue: { _ in
                print("sending???")
                self.objectWillChange.send()
            })
        }
    }
    
    @Published var conn : URLSessionWebSocketTask?
    
    private init(){}

    
    func connect(){
        if self.conn != nil { //no need to connecte again
            print("no need to reconnect to ws!")
            return
        }
        
        guard let url = URL(string: SERVER_WS) else {
            print("websocket connected error. Reason - URL error")
            return
        }
//
    
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//
//
        conn = URLSession.shared.webSocketTask(with: req)
        conn?.receive(completionHandler: onReceive(resultReq:))
        conn?.resume()
        print("websocket connected")
    }
    
    
    func disconnect(){}
    
    func onSend(message : MessageReq){
        
        
        do {
            let req = try encode(obj: message)
            print("sending the request via socket server")
            conn?.send(.data(req)){err in
                if let err = err {
                    print("send message error :  \(err.localizedDescription)")
                }
            }
        }catch(let err){
            print("encode error \(err)")
        }
    }
    
    private func onReceive(resultReq :Result<URLSessionWebSocketTask.Message, Error>){
        conn?.receive(completionHandler: onReceive(resultReq:))
        switch resultReq{
        case .success(let message):
            switch message{
            case .string(let str):
                print("receive a string : \(str)")
                let strObj = Data(str.utf8)
                
                do {
                    let obj = try  decode(type: MessageResp.self, obj: strObj)
                    if obj.opcode == WebsocketOpCode.OpPing.rawValue{
                        let pingMessage =  MessageReq(opcode: WebsocketOpCode.OpPong.rawValue, message_id: "", group_id: 0, message: "", sent_time: 0)
                        self.onSend(message: pingMessage)
                    }else if obj.opcode == WebsocketOpCode.OpText.rawValue{
                        
                        switch obj.message_type {
                        case 0 :
                            BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .normal)
                        case 1 :
                            pushMessageToChat(obj: obj)
                        case 2:
                            //MARK: FRIEND_NOTIFICATION
                            pushFriendNotification(obj: obj)
                        case 3:
                            //MARK: COMMENT_NOTIFICATION
                            pushCommentNotification(obj: obj)
                        case 4:
                            //MARK: LIKES_NOTIFICATION
                            pushLikesNotification(obj: obj)
                        default:break
                        }
                        
    
                    }
                    
                } catch ( let err ){
                    print("decode err : \(err.localizedDescription)")
                }

            case .data(let data):
                print("receive a data \(data.description)")
            @unknown default:
                fatalError()
            }
        case .failure(let err):
            print("receive an error \(err.localizedDescription)")
        }
    }
    
    
    private func pushMessageToChat(obj : MessageResp){
        //MARK: A user message
        //msg_identity = 0 -> if this a new chat room -> id = 0 means no any oldest data
        //msg_identidy = 0 -> is a active chat room, but the last id is the oldest message we got
        //so we set it to 0
        let newMessage = MessageInfo(id: obj.message_id, msg_identity: 0, message: obj.content, sender_id: obj.sender_info.id, sent_time: obj.send_time)
        
        
        //MARK: This may change....
        let index = MessageViewModel.shared.FindChatRoom(roomID: obj.group_id)
        if index != -1 {
            
            MessageViewModel.shared.rooms[index].last_sender_id = obj.sender_info.id
            
            if MessageViewModel.shared.currentTalkingRoomID == obj.group_id {
                print("inside the room")
                MessageViewModel.shared.rooms[index].is_read = true
                
                //MARK: is set false by default
                //MARK: and user is now in the room
                //MARK: so we need to change the is_read field to true
                APIService.shared.SetIsRead(req: SetIsReadReq(room_id: obj.group_id)){ reuslt in
                    switch reuslt{
                    case .success(_):
                        print("read state is updated")
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }else {
                MessageViewModel.shared.rooms[index].is_read = false
            }
            
            MessageViewModel.shared.addNewMessage(roomID: obj.group_id, message: newMessage)
        } else {
            //we need to get the room info first?
            APIService.shared.GetRoomInfo(req: GetRoomInfoReq(roome_id: obj.group_id)){ result in
                switch result{
                case .success(let data):
                    MessageViewModel.shared.rooms.append(data.info)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
        
            
        if MessageViewModel.shared.currentTalkingRoomID == 0 || MessageViewModel.shared.currentTalkingRoomID != obj.group_id{
            BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .message)
        }
    }
    
    private func pushFriendNotification(obj : MessageResp) {
        userVM?.profile?.notification_info?.friend_notification_count += 1
        BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .notification)
    }
    private func pushCommentNotification(obj : MessageResp) {
        userVM?.profile?.notification_info?.comment_notification_count += 1
        BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .notification)
    }
    private func pushLikesNotification(obj : MessageResp) {
        userVM?.profile?.notification_info?.likes_notification_count += 1
        BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .notification)
    }
    
    
    private func decode<T : Decodable>(type : T.Type,obj : Data) throws -> T{
        do {
            let decoder = JSONDecoder()
            let message = try decoder.decode(T.self, from: obj)
            return message
        } catch (let err) {
            throw err
        }
    }
    
    private func encode<T : Encodable>(obj : T) throws -> Data {
        do {
            let encoder = JSONEncoder()
            let req = try encoder.encode(obj)
            return req
        } catch (let err ){
            throw err
        }
    }
}
