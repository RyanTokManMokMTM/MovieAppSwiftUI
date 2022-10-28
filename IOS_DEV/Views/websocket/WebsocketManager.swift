//
//  WebsocketManager.swift
//  IOS_DEV
//
//  Created by Jackson on 24/10/2022.
//

import Foundation
import SwiftUI

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
                        
                        if obj.message_type == 0{
                            //MARK: A system message
                            BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .notification)
                        }else {
                            //MARK: A user message
                            let newMessage = MessageInfo(id: obj.message_id, message: obj.content, sender_id: obj.sender_info.id, sent_time: obj.send_time)
                            MessageViewModel.shared.addNewMessage(roomID: obj.group_id, message: newMessage)
                            
        
                            if MessageViewModel.shared.currentTalkingRoomID == 0 || MessageViewModel.shared.currentTalkingRoomID != obj.group_id{
                                BenHubState.shared.AlertMessageWithUserInfo(message: obj.content, userInfo: obj.sender_info,type: .message)
                            }
                            
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
    
//    func ping(){
//        //Send the websocket message with ping opcode
//
//    }
//
    
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
