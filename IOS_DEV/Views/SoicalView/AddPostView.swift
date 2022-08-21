//
//  AddPostView.swift
//  IOS_DEV
//
//  Created by Jackson on 12/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddPostView: View {
    
    var selectedMovie : Movie
    @Binding var isSelectedMovie : Bool
    @Binding var isAddPost : Bool
    @State private var title : String = ""
    @State private var desc : String = ""
    @FocusState private var isEditDesc : Bool
    
    var body: some View {
            ZStack(alignment:.top){
                VStack(spacing:0){
                    AddPostViewBar(isAddPost: $isSelectedMovie)
                    AddPostDescView(movieInfo: selectedMovie, title: $title, desc: $desc, isEditDesc: _isEditDesc)
                    PostButton(isSelectedMovie: $isSelectedMovie, isAddPost: $isAddPost, movieInfo: selectedMovie, title: $title, desc: $desc)
                       
                }
            }
            .frame(maxHeight:.infinity,alignment: .top)
            .background(Color("appleDark"))
            .ignoresSafeArea(.keyboard, edges: .bottom)

        
    }
}

struct AddPostViewBar : View{
    @Binding var isAddPost : Bool
    @Environment(\.dismiss) private var dissmiss
    var body: some View{
        HStack(alignment:.center){
            Button(action:{
                //TODO: BACK TO MOVIE SELECTION PAGE
                dissmiss()
//                withAnimation(){
//                    self.isAddPost.toggle()
//                }
            }){
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    
                    
            }
            .padding(.horizontal,5)
            
            
           Spacer()
            
            Image(systemName: "info.circle")
                .imageScale(.large)
                .foregroundColor(.white)
            
        }
        .padding(.horizontal,5)
        .frame(width:UIScreen.main.bounds.width,height:50)
        .background(Color("appleDark").edgesIgnoringSafeArea(.top))
    }
}

struct AddPostDescView : View {
    var movieInfo : Movie
    @Binding  var title : String
    @Binding  var desc : String
    @FocusState var isEditDesc: Bool
    @State private var placeHolder : String = "文章標題"
    @State private var isFocuse : [Bool] = [false,true]
    var body : some View{
        
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment:.leading,spacing:20){
                
                HStack(spacing:10){
                    WebImage(url: movieInfo.posterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(width: 110)
                    
//
//                    Button(action:{
//                        //TODO: ADD MORE IMAGE TO THE POST
//                    }){
//                        VStack(spacing:0){
//                            Image(systemName: "plus")
//                                .imageScale(.large)
//                                .foregroundColor(.gray)
//                            Text("尚未開放")
//                                .font(.system(size: 12, weight: .semibold))
//                                .frame(width: 110)
//                        }
//                        .cornerRadius(10)
//                        .frame(width: 110,height:110 * 1.5)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10, style: RoundedCornerStyle.continuous)
//                                .stroke(Color.gray.opacity(0.85), style: StrokeStyle(lineWidth: 1, dash: [12]))
//                        )
//
//                    }
//                    .disabled(true)
//

                    
                    
                }
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width,alignment: .leading)
                
                
                
                
                Text("#\(movieInfo.title)")
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .padding(.horizontal)
                
                //                .background(Color("app").cornerRadius(5))
                //Post Title
                VStack(spacing:8){
                    CustomUITextView(focuse:$isFocuse,text: $title, placeholder: placeHolder, keybooardType: .default, returnKeytype: .done, tag: 1,isSecureText:false,placeholderColor: UIColor.lightGray)
                        .frame(height:23)
                    
                    Divider()
                        .background(.white)
                        
                }
                .padding(.horizontal)

                //Post Desc
                
//
                Group{
                    AppTextEditor(isEditDesc:_isEditDesc,message: $desc, placeholder: "新增正文",backgrandColor: UIColor(Color("appleDark")))
                    Divider()
                        .background(.white)
                }
                .padding(.horizontal)
            }
        }
        .frame(maxHeight:.infinity,alignment: .top)

    }
}

// MARK: - AppTextEditor `stackoverflow`
struct AppTextEditor: View {
    @FocusState var isEditDesc: Bool
    @Binding var message: String
    let placeholder: LocalizedStringKey
    var backgrandColor : UIColor = .black
    var textColor: UIColor = .white
    var body: some View {
        ZStack(alignment: .topLeading) {
            if message.isEmpty {
                Text(placeholder)
                    .padding(.vertical,8)
                    .padding(.horizontal,5)
                    .foregroundColor(Color.placeholderColor)
                    .OswaldSemiBold(size: 14)
            }
            TextEditor(text: $message)
                .focused($isEditDesc)
                .frame(height: UIScreen.main.bounds.height / 5)
                .opacity(message.isEmpty ? 0.25 : 1)
                .toolbar{
                    ToolbarItemGroup(placement: .keyboard){
                        HStack{
                            Spacer()
                            Button(action:{
                                withAnimation{
                                    self.isEditDesc.toggle()
                                }
                            }){
                                Text("Done")
                            }
                        }
                    }
                }
            
        }
        .onAppear{
            UITextView.appearance().backgroundColor = backgrandColor
            UITextView.appearance().textColor = textColor
            UITextView.appearance().tintColor = .white
            
            
        }.onDisappear{
            UITextView.appearance().backgroundColor = .clear
            UITextView.appearance().textColor = .clear
            UITextView.appearance().tintColor = .clear
        }
    }
}

extension Color {
    static let placeholderColor = Color(UIColor.lightGray)
}



struct PostButton : View {
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @Binding var isSelectedMovie : Bool
    @Binding var isAddPost : Bool
    var movieInfo : Movie
    @Binding var title : String
    @Binding var desc : String
    @Environment(\.dismiss) private var dissmiss
    var body : some View {
        Button(action:{
            if title.isEmpty || desc.isEmpty{
                return
            }
           
            postVM.CreatePost(title: title, desc: desc, movie: movieInfo, user: userVM.profile!)
            //TODO: SENDING REQUEST! - IGNORE
            withAnimation{
                self.isAddPost = false
                self.isSelectedMovie = false
                self.postVM.index = .Follow
            }
            
            dissmiss()
            
        }){
            HStack{
                Text("Posts Your Review")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width / 2)
                .background(Color.red.cornerRadius(25))
                .padding(.bottom,5)
            
        }
    }
}


