//
//  TractateView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/5/23.
//

import Foundation
import SwiftUI

struct TractateView: View
{
    var articles:[Article]
    let FullSize = UIScreen.main.bounds.size
    var columns = Array(repeating: GridItem(.flexible(),spacing:15), count: 2)
    
    var body: some View
    {
        NavigationView{
        VStack()
        {
            //top pic can not move
            ZStack()
            {
                Image("ta")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .top)
                    .frame(width: FullSize.width, height: 250)
                    .clipped()
            LinearGradient(
                gradient: Gradient(colors: [.white, .gray]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
            .blendMode(.multiply)
            .frame(width: FullSize.width, height: 250)
                //漸層
            }
            
                
            ScrollView(.vertical, showsIndicators: true)
            {
                Spacer()
                
                    //TODO
                    //two 'TractateFrame' in a Row
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(self.articles ,id: \.id) { article in
                      
                            TractateButton(article: article)

                        

                    }
       
                }
         

                            
            }
        }
        .ignoresSafeArea(edges: .top)
//        .frame(width: FullSize.width, height: FullSize.height)
       
        
        }

    }
}


struct TractateButton:View{
    let controller = ForumController()
    @State var article:Article

    @State private var todo : Bool = false
    var body:some View{
        
        HStack{
            
            Button(action:{
                controller.articleDetails(articleID: article.id!)
       
            }){
                TractateFrame(article: article)
            
            }
            .simultaneousGesture(TapGesture().onEnded{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.todo = true
                })
            })
            .fullScreenCover(isPresented: $todo, content: {
//                MessageBoardView(article: article ,comment: controller.commentData, todo:$todo)

            })
          
            
      
        }

    }

}


//struct TractateView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        TractateView(articles: stubbedArticles)
//    }
//}
