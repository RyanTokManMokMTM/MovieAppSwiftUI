//
//  ListView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/10.
//


import Foundation
import SwiftUI
import CryptoKit
import SDWebImageSwiftUI

struct ListView: View
{
    @ObservedObject private var popularState = MovieListState(endpoint: .popular)
    var lists:[CustomList]
    let FullSize = UIScreen.main.bounds.size
    var columns = Array(repeating: GridItem(.flexible(),spacing:5), count: 2)
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 0
  
    var body: some View
    {
        
        VStack()
        {
            if popularState.movies != nil {
                ZStack()
                {
                    TabView(selection: $currentIndex ){
                        ForEach(0..<popularState.movies!.count){ index in
                            WebImage(url: popularState.movies![index].backdropURL)
                                .resizable()
                                .scaledToFill()
                                .tag("\(index)")
                                .overlay(Color.black.opacity(0.2))
                            
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(width: FullSize.width, height: FullSize.height/3)
                    .onReceive(timer, perform: { _ in
                        withAnimation{
                            currentIndex = currentIndex < popularState.movies!.count ? currentIndex + 1 : 0
                        }
                       
                    })
                    

                
                }

            }
            
                
            ScrollView(.vertical, showsIndicators: false)
            {
                Spacer()
                
                   
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(self.lists ,id: \.id) { list in
                        ListButton(list: list)
                    }
                }
         

                            
            }
            
        
            
        }
        .ignoresSafeArea(edges: .top)

//        .frame(width: FullSize.width, height: FullSize.height)
        

        
       
    

    }
}


struct ListButton:View{
    @ObservedObject private var listController = ListController()
    @State var list:CustomList
    @State private var todo : Bool = false
    let FullSize = UIScreen.main.bounds.size
    
    var body:some View{
        
    
            Button(action:{
//                listController.GetListDetail(listID: list.id!)  //取得片單內容
                
            }){
               
                
                VStack(alignment: .leading){
                    
                
                    HStack(){
                        
                        WebImage(url: list.user!.user_avatarURL)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(30)
                        
                       
                        Text(list.user!.UserName)
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                    }
                    .padding(.top,15)
                    
                    
                    
                    Text(list.title)
                        .bold()
                        .font(.system(size: 18))
                        .padding(.top,25)
                            
                    
                    Spacer()
                    
                    
                }
                .frame(width:160,height: 160, alignment: .leading)
                .padding([.leading],15)
                .background(BlurView().cornerRadius(25))
                //.background(Color(hue: 1.0, saturation: 0.0, brightness: 0.144, opacity: 0.329))
                .shadow(color: .gray, radius: 0.5)
                .foregroundColor(.white)
                .cornerRadius(20)
                
        

            
            }
            .simultaneousGesture(TapGesture().onEnded{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.todo = true
                })
            })
            .fullScreenCover(isPresented: self.$todo, content: {
                ListDetailView(todo: self.$todo,listDetails: stubbedListDetail, listOwnerPhoto: list.user!.user_avatarURL,listOwner:list.user!.UserName,listTitle:list.title)
                
            })
          
            
      

    }

}


//struct ListView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ListView(articles: stubbedArticles, index: 0)
//    }
//}
