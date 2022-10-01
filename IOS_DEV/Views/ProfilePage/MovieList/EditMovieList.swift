//
//  SwiftUIView.swift
//  IOS_DEV
//
//  Created by Jackson on 20/9/2022.
//

import SwiftUI

struct EditMovieList: View {
    @EnvironmentObject var userVM : UserViewModel
    var listIndex : Int
    @Binding var isBackToRoot : Bool
    @State private var title = ""
    @State private var intro = ""
    @FocusState private var isTitleFocus
    @FocusState private var isIntroFocus
    @State private var isDelete = false
    
    
    @Environment(\.dismiss) private var dissmiss
    var body: some View {
        GeometryReader{proxy in
            VStack(alignment:.leading,spacing:0){
                VStack{
                    HStack(){
                        Button(action:{
                            withAnimation{
                                dissmiss()
                            }
                        }){
                           Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action:{
//                            if listTitle.isEmpty {return}
//                            CreateNewList()
//
                        }){
                          Text("完成")
                                .font(.system(size:16,weight:.semibold))
                                .foregroundColor(.red)
                                
                        }
                     
                    }
                    .overlay(
                        HStack{
                            Text("編輯專輯")
                                .font(.system(size:14,weight:.bold))
                                .foregroundColor(.white)
//                                .padding(.bottom,10)
                        }
                    
                    )
                    .font(.system(size: 14))
                    .padding(.horizontal,10)
                    .padding(.bottom,10)
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                .background(Color("DarkMode2"))
                Divider()
                
                List{
                    Section(){
                        HStack(spacing:5){
                            Text("標題")
                                .font(.system(size:14,weight:.semibold))
                                .foregroundColor(.white)
                                .padding(.trailing,5)
                            
                            TextField("", text: $title)
                                .font(.system(size:14))
                                .focused($isTitleFocus)
                                .submitLabel(.done)
                                .accentColor(.white)
    //                            .frame(maxWidth:.infinity)
                        }
                        .listRowBackground(Color("DarkMode2"))
                        
                        HStack(alignment:.center,spacing:5){
                            Text("簡介")
                                .font(.system(size:14,weight:.semibold))
                                .foregroundColor(.gray)
                                .padding(.trailing,5)
                            
                           TextEditor(text: $intro)
                                .font(.system(size:14))
                                .foregroundColor(.gray)
                                .focused($isIntroFocus)
                                .lineLimit(5)
                                .frame(height:100)
                                .accentColor(.gray)
    //                            .frame(maxWidth:.infinity)
                        }
                        .frame(height:100)
                        .listRowBackground(Color("DarkMode2"))
                    }
                    
//                    Section(){
                        Button(action:{
                            //TODO: REMOVE
                            withAnimation{
                                self.isDelete = true
                            }
                        }){
                           
                                Text("刪除專輯")
                                    .foregroundColor(.red)
                                    .frame(maxWidth:.infinity)
                                
                        }
                        .listRowBackground(Color("DarkMode2"))
                        
//                    }
                }
                .listStyle(GroupedListStyle())

                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear{
            self.title = self.userVM.profile!.UserCustomList![self.listIndex].title
            self.intro = self.userVM.profile!.UserCustomList![self.listIndex].introStr
        }
        .alert(isPresented: self.$isDelete){
            withAnimation(){
                Alert(title: Text("刪除當前專輯"), message: Text("確定刪掉?"),
                      primaryButton: .default(Text("取消")){
                        
                      },
                      secondaryButton: .default(Text("刪除")){
                        withAnimation{
//                            dissmiss()
                            self.isBackToRoot = false
                            
                        }
                      })
            }
            
        }
    }
    
    private func deleteList(){
        
    }
    
    private func updateList(){
        
    }
}

