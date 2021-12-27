//
//  Article.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/22.
//

import Foundation

struct Article: Decodable, Identifiable{
    var id: UUID?
    var Title: String
    var Text: String
    var user: Owner?
    var movie: Int
    var LikeCount: Int
    var updatedOn: String?   //db is 'DATE', but here is 'STRING'
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var dateText: String {
        guard let updatedOn = self.updatedOn, let date = Utils.Formatter.date(from: updatedOn) else {
            return "n/a"
        }
        return Article.dateFormatter.string(from: date)
    }
    
    var timeText: String {
        guard let updatedOn = self.updatedOn, let date = Utils.Formatter.date(from: updatedOn) else {
            return "n/a"
        }
        return Article.timeFormatter.string(from: date)
    }
    
}

struct Owner: Decodable, Identifiable{
    var id: UUID?
    var UserName: String
    var UserPhoto: String
    
    var user_avatarURL: URL {
        return URL(string: "\(baseUrl)/UserPhoto/\(UserPhoto)")!
    }
    
}


//let stubbedArticles:[Article] = [
//    Article(Title: "看真人快打前需要先做什麼功課", Text: "近期想跟朋友去電影院看...", user: ArticleOwner(UserName: "Angelababy"), movie: 111, LikeCount: 12, updatedOn: "123"),
//    Article(Title: "真人快打劇情討論", Text: "劇情設定本身蠢都無所謂...", user: ArticleOwner(UserName: "Abc"), movie: 111, LikeCount: 23, updatedOn: "123"),
//    Article(Title: "「閒聊」鬼滅之刃", Text: "鬼夜之刃相對於其他動漫...", user: ArticleOwner(UserName: "Sean"), movie: 111, LikeCount: 1, updatedOn: "123")
//]
