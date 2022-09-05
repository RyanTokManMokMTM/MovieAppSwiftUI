//
//  MyArticleView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import SwiftUI
//
//
//struct MyArticleView: View {
//    @ObservedObject private var forumController = ForumController()
////    var articles:[Article]
////    @State var cardShown : Bool = false
//    @State var deleteAction : Bool = false
//    
//    var body: some View{
//        
//        
//        Spacer()
//        
//        ScrollView(.vertical, showsIndicators: false){
//     
//            ZStack(alignment: .center , content: {
//  
//                
//                VStack()
//                {
//                
//        
//                 
//                    ForEach(forumController.articleData ,id: \.id) { article in
//                      
//                        HStack{
//                            
//                            NavigationLink(destination:GetMessageBoardView(article: article))
//                            {
//                                TopicFrame(article:article)
//                                    //長按刪除
//                                    .contextMenu{
//                                        Button(action: {
//                                            self.deleteAction.toggle()
//                                         }) {
//                                             HStack {
//                                                 Text("Delete")
//                                                 Image(systemName: "trash")
//                                             }
//                                         }
//
//                                    }
//                                    .alert(isPresented: self.$deleteAction, content: {
//                                        Alert(title: Text("刪除此文章？"),
//                                              primaryButton: .default(Text("確定"),
//                                                                      action: { forumController.DeleteArticle(articleID: article.id!)} ),
//                                              secondaryButton: .destructive(Text("取消")))
//
//                                    })
//                            }
//                                
//                        }
//
//                    }
//                    
//        
//                    
//                }
//                .ignoresSafeArea(edges: .top)
//                
//
//                
//            })
//            
//            
//        }
//        .navigationTitle("我發表過的文章")
//        .onAppear{
//            self.forumController.GetMyArticle(userID: NowUserID!)
//        }
////        .toolbar{
////            Button(action:{
////                self.cardShown.toggle()
////            }){
////                HStack{
////                    Image(systemName: "plus")
////                }
////            }
////        }
//    
//      
//    
//    }
//
//}
//
