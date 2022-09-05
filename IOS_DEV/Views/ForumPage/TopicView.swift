//
//  Topic.swift
//  new
//
//  Created by 張馨予 on 2021/3/21.
//

import SwiftUI
import SDWebImageSwiftUI


//struct GetTopicView: View{
//    let movie: Movie
//    @ObservedObject private var forumController = ForumController()
// 
//    var body: some View {
//        ZStack {
//
//            TopicView(articles: forumController.articleData, movie: movie)
//            
//            
//        }
//        .onAppear {
//            self.forumController.GetAllArticle(movieID: movie.id)
//            
//        }
//    }
//}
//
//struct TopicView: View
//{
//    let articles:[Article]
//    let movie: Movie
//    let FullSize = UIScreen.main.bounds.size
//    @State var hideBar = false
//    @State var offset : CGFloat = 0
//    @State var lastOffset : CGFloat = 0
//    @ObservedObject private var forumController = ForumController()
//    @State var createAction = false
//
//    
//    var body: some View
//    {
//
//        
//            
//            VStack {
//
//                ZStack()
//                {
//                    WebImage(url: movie.backdropURL)
//                        .resizable()
//                        .ignoresSafeArea(edges: .top)
//                        .frame(width: FullSize.width, height: FullSize.height/8)
//                    
//                    Text(movie.title)
//                        .bold()
//                        .font(.system(size: 30))
//                        .padding(25)
//                        .foregroundColor(.white)
//
//                }
//                
//                TabView(){
//                
//                ScrollView(.vertical, showsIndicators: false)
//                {
//                    Spacer()
//                        
//                        VStack()
//                        {
//                        
//                
//                            ForEach(self.articles ,id: \.id) { article in
//                              
//                                HStack{
//                                    
//                                    NavigationLink(destination:GetMessageBoardView(article: article))
//                                    {
//                                        TopicFrame(article:article)
//                                    }
//                                        
//                                }
//
//                            }
//                
//                            
//                        }
//                        .ignoresSafeArea(edges: .top)
//                        .overlay(
//                            GeometryReader{ proxy -> Color in
//                                
//                                let minY = proxy.frame(in: .named("SCROLL")).minY
//                                
//                                // hide tab bar offset
//                                let durationOffset : CGFloat = 10
//                                
//                                DispatchQueue.main.async {
//                                    //scroll up
//                                    if offset < 0 && -minY > (lastOffset + durationOffset ) {
//                                        // hidding tab and updating last offset
//                                        withAnimation(.easeOut.speed(1.5)){
//                                            hideBar = true
//                                        }
//                                        
//                                        lastOffset = -offset
//                                    }
//                                    //scroll down
//                                    if minY > offset && -minY < (lastOffset - durationOffset){
//                                        // showing tab and updating last offset
//                                        withAnimation(.easeOut.speed(1.5)){
//                                            hideBar = false
//                                        }
//                                        
//                                        lastOffset = -offset
//                                    }
//                                    
//                                    self.offset = minY
//                                }
//                                return Color.clear
//                                
//                            }
//                        
//                        )
//                   
//                   
//                }
//                .coordinateSpace(name: "SCROLL")
//            }
//            .overlay(
//                VStack{
//                    Button{
//                        self.createAction.toggle()
//                    } label:{
//                        HStack(spacing:hideBar ? 0 : 12){
//                            Image(systemName: "pencil")
//                                .font(.title)
//                            
//                            Text("Compose")
//                                .fontWeight(.semibold)
//                                .frame(width: hideBar ? 0 : nil, height: hideBar ? 0 : nil)
//                        }
//                        .foregroundColor(Color("CustomRed"))
//                        .padding(.vertical, hideBar ? 15 : 12)
//                        .padding(.horizontal)
//                        .background(Color(.black))
//                        .cornerRadius(20)
//                        .shadow(color: .white.opacity(0.06), radius: 5, x: 5, y: 10)
//                    }
//                    .padding(.trailing)
//                    .offset(y: -15)
//                    .frame(width: FullSize.width, alignment: .trailing)
//                }
//                   
//                ,alignment: .bottom
//            )
//            
//        }
//        .sheet(isPresented: self.$createAction, content: {
//            NewArticleCard(createAction: self.$createAction, title: "", text: "", movieID: movie.id)
//        })
//        
//        
//           
//                
//            
//    }
//}



//struct TopicViewButton:View{
//    let controller = ForumController()
//    @State var article:Article
//
//    @State private var todo : Bool = false
//    var body:some View{
//
//        HStack{
//
//            Button(action:{
//                controller.articleDetails(articleID: article.id!)
//
//            }){
//                TopicFrame(article:article)
//
//            }
//            .simultaneousGesture(TapGesture().onEnded{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                    self.todo = true
//                })
//            })
//            .fullScreenCover(isPresented: $todo, content: {
//                MessageBoardView(article: article ,comment: controller.commentData, todo:$todo)
//
//            })
//
//
//        }
//
//    }
//
//}


//struct TopicView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        TopicView(articles: stubbedArticles, movie: stubbedMovie[0])
//      
//
//    }
//}
