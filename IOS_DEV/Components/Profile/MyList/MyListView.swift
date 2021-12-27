//
//  MyListView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/5.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct MyListView: View {
    
    @ObservedObject private var listController = ListController()
    @State var cardShown : Bool = false
    @State private var isAppear:Bool = false
    @State private var showAnimation = false
    let FullSize = UIScreen.main.bounds.size
    var columns = Array(repeating: GridItem(.flexible(),spacing:5), count: 2)
    @State var title:String = ""
    @State var editID: UUID?
    @State var editTitle:String = ""
    @State var editAction : Bool = false
    
    var body: some View{
        
        
        Spacer()
        
        ScrollView(.vertical, showsIndicators: false){
     
            ZStack(alignment: .center , content: {
  
                
                VStack()
                {
                
        
                    LazyVGrid(columns: columns, spacing: 20){
                        ForEach(listController.mylistData ,id: \.id) { list in
                           
                            MyListButton(list: list, editID: self.$editID, editTitle:self.$editTitle , editAction: self.$editAction)
  
                        }
                    }
        
                    
                }
                .ignoresSafeArea(edges: .top)
                

                NewListCard(cardShown: self.$cardShown, title: self.$title) //新增片單
                EditListCard(editAction: self.$editAction, title: self.$editTitle, listID: self.$editID) //編輯片單
                
            })
            
            
        }
        .navigationTitle("我的片單")
        .onAppear{
            self.listController.GetMyList(userID: NowUserID!)
        }
        .toolbar{
            Button(action:{
                self.cardShown.toggle()
            }){
                HStack{
                    Image(systemName: "plus")
//                    Text( "ADD")
                }
               
            }
         
        }
      
    
    }

}


struct MyListButton:View{
    @ObservedObject private var listController = ListController()
    @State var list:CustomList
    @State var todo : Bool = false
    @Binding var editID: UUID?
    @Binding var editTitle: String
    @Binding var editAction : Bool
    @State var deleteAction : Bool = false
    

    var body:some View{
        
        HStack{
            
            Button(action:{
                listController.GetListDetail(listID: list.id!)  //取得片單內容
            }){
               
                
                VStack(alignment:.leading){
                    
                
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
                    
                    
                    
                    Text(list.Title)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.todo = true
                })
            })
            //點擊button進入detailView
            .fullScreenCover(isPresented: self.$todo, content: {
                ListDetailView(todo: self.$todo, listDetails: listController.listDetails, listOwnerPhoto: list.user!.user_avatarURL, listOwner: list.user!.UserName, listTitle: list.Title)
                
            })
            //長按動作
            .contextMenu{
                Button(action: {
                    self.editID = list.id
                    self.editTitle = list.Title
                    self.editAction.toggle()
                }) {
                    HStack {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                }

                Button(action: {
                    self.deleteAction.toggle()
                 }) {
                     HStack {
                         Text("Delete")
                         Image(systemName: "trash")
                     }
                 }

            }
            //刪除的alert
            .alert(isPresented: self.$deleteAction, content: {
                Alert(title: Text("刪除此片單？"),
                      primaryButton: .default(Text("確定"),
                                              action: {listController.deleteList(ListID: list.id!)} ),
                      secondaryButton: .destructive(Text("取消")))

            })
            
            
      
        }

    }

}



