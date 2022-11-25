//
//  AddMoviePostView.swift
//  IOS_DEV
//
//  Created by Jackson on 23/11/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddMoviePostView: View {
    @EnvironmentObject private var userVM : UserViewModel
    @EnvironmentObject private var postVM : PostVM
    var movie : Movie
    @Binding var isAddNewPost : Bool
    @Binding var isShowSheet : Bool
    @State private var postTitle : String  = ""
    @FocusState private var isFocus : Bool
    @State private var desc : String = ""
    @FocusState var isEditDesc: Bool
    @State private var isFocuse : [Bool] = [false,true]
    var body: some View {
        VStack(spacing:0){
            Text("新文章")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor.lightText))
                .overlay(
                    HStack{
                        if !postTitle.isEmpty && !desc.isEmpty {
                            Button(action: {
//                                CreateNewList()
                                createNewPost()
                            }){
                                Text("發表")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        
                        Spacer()
                        Button(action: {
                            withAnimation{
                                self.isShowSheet = false
                                self.isAddNewPost = false
                            }
                        }){
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                    }
                        .padding(.horizontal,10)
                        .frame(width: UIScreen.main.bounds.width)
                )
                .padding(.bottom,8)
                .padding(5)
            VStack(spacing:0){
                HStack{
                    WebImage(url: movie.posterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .cornerRadius(8)
                    
                    VStack{
                        TextField("文章標題...", text: $postTitle)
                            .submitLabel(.done)
                            .accentColor(.white)
                            .ignoresSafeArea(.keyboard)
//                            .focused($isFocus)
                            .font(.system(size:14))
                        
                        Divider()
                    }
                    .padding(.horizontal,8)
                }
            }
            .padding(5)
            
            Group{
                AppTextEditor(isEditDesc:_isEditDesc,message: $desc, placeholder: "新增正文",backgrandColor: .clear)
                
                Spacer()
            }
        }
        .frame(maxHeight:.infinity,alignment:.top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding(.top)
        .padding(.horizontal)
    }
    
    private func createNewPost(){
        if postTitle.isEmpty || desc.isEmpty{
            return
        }
        
        //TODO: Not Add to the VM directly,but refershing the view instead
        
        postVM.CreatePost(title: postTitle, desc: desc, movie: self.movie, user: userVM.profile!)
        DispatchQueue.main.async {
            withAnimation{
                DispatchQueue.main.async {
                    self.isAddNewPost.toggle()
                    self.isShowSheet.toggle()
                }
                //                    dissmiss()
            }
        }
    }
}


