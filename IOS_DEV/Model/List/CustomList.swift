//
//  CustomList.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/1.
//

import Foundation

//--------------------------------所有片單（GET)----------------------------------------//
struct CustomList: Decodable, Identifiable{       //取片單
    var id: UUID?
    var Title: String
    var user: Owner?
    var updatedOn: String   //db is 'DATE', but here is 'STRING'

}

//struct ListOwner: Decodable, Identifiable{      //取片單的user
//    var id: UUID?
//    var UserName: String
//}

//--------------------------------特定片單的內容(GET)-----------------------------------------//
struct ListDetail:Decodable, Identifiable {         //取片單裡內容
    var id: UUID?
    var movie: Int
    var title: String
    var posterPath: String?
    var ratetext: Int
    var feeling: String
    var list: thisListID?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    
}

struct thisListID: Decodable, Identifiable{      //片單id
    var id: UUID
}

//--------------------------------新增片單(POST)--------------------------------------//
struct NewList: Decodable, Encodable{
    var UserName: String
    var Title: String
}
struct NewListRes: Decodable, Identifiable{       //取片單
    var id: UUID?
    var Title: String
    var user: NewListUser?
    var updatedOn: String   //db is 'DATE', but here is 'STRING'
}
struct NewListUser: Decodable, Identifiable{
    var id: UUID?
}
//--------------------------------編輯片單（PUT)----------------------------------------//

struct UpdateList: Decodable,Encodable{
    var listID : UUID
    var listTitle : String
}




//-------------------------------------------------------------------------//
//let stubbedList:[CustomList] = [
//    CustomList( Title: "打發時間片單", user: ListOwner(UserName: "joyce"), updatedOn: "2021-08-02"),
//    CustomList( Title: "2021恐怖電影", user: ListOwner(UserName: "angela"), updatedOn: "2021-08-02"),
//    CustomList( Title: "111111", user: ListOwner(UserName: "joyce"), updatedOn: "2021-08-02"),
//    CustomList( Title: "222222", user: ListOwner(UserName: "angela"), updatedOn: "2021-08-02"),
//    CustomList( Title: "sdfsdfsd", user: ListOwner(UserName: "joyce"), updatedOn: "2021-08-02"),
//    CustomList( Title: "ewrwerwer", user: ListOwner(UserName: "angela"), updatedOn: "2021-08-02"),
//    CustomList( Title: "53423434s", user: ListOwner(UserName: "joyce"), updatedOn: "2021-08-02"),
//    CustomList( Title: "awdawd", user: ListOwner(UserName: "angela"), updatedOn: "2021-08-02"),
//    CustomList( Title: "間片單", user: ListOwner(UserName: "joyce"), updatedOn: "2021-08-02"),
//    CustomList( Title: "20怖電影", user: ListOwner(UserName: "angela"), updatedOn: "2021-08-02")
//]

let stubbedListDetail:[ListDetail] = [
    ListDetail(movie: 123, title: "劇場版鬼滅之刃：無限列車篇", posterPath: "/ozQvWjtC7B2KtDUEdQvUdvCzHUo.jpg", ratetext: 4, feeling: "鬼！"),
    ListDetail(movie: 1234, title: "123", posterPath: "/ozQvWjtC7B2KtDUEdQvUdvCzHUo.jpg", ratetext: 4, feeling: "鬼滅是必看的動漫之一，不看會後悔的！"),
    ListDetail(movie: 12345, title: "00000", posterPath: "/ozQvWjtC7B2KtDUEdQvUdvCzHUo.jpg", ratetext: 4, feeling: "鬼滅是必，不看會後悔的！")
]
