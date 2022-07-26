//
//  ProfileView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/6.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI


enum SideOfState: String, CaseIterable {
    case movie = "電影"
    case article = "文章"
}//Picker Content

//struct GetProfileView: View {
//    @ObservedObject private var listController = ListController()
//    @ObservedObject private var forumController = ForumController()
//    @State var isLoading : Bool = true
//
//    var body:some View{
//
//        VStack{
//
//            if self.isLoading == false {
//                ProfileView(myListData: listController.mylistData, myArticleData: forumController.articleData)
//            }
//        }
//        .onAppear{
//            self.listController.GetMyList(userID: NowUserID!)
//            self.forumController.GetMyArticle(userID: NowUserID!)
//            DispatchQueue.main.asyncAfter(deadline:.now() + 3){
//                self.isLoading = false
//            }
//        }
//    }
//
//
//}


struct ProfileView: View {
    
//    init(){
//        UISegmentedControl.appearance().selectedSegmentTintColor = .systemYellow
//    }
    
    @State private var userID = NowUserName
    @State private var likedMovie = 30
    @State private var notification = true
    @State private var select: SideOfState = .movie
//    @ObservedObject private var userController = UserController()
//    @ObservedObject private var favoriteController = FavoriteController()
    let MovieData:[LikeMovie]
    let ArticleData:[LikeArticle]
    @State private var appearPhoto = false
    
    @State var isLoading : Bool = true
    
    var body: some View{
        NavigationView{
            
            ScrollView{
                    VStack{
                            NowUserPhoto?
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                           
                            
                            Text(NowUserName)
                                .bold()

                    }
//                    .onAppear(){
//                        self.userController.GetUserInfo(userID: NowUserID!)
//                        self.favoriteController.GetLikeMovie(userID: NowUserID!)
//                        self.favoriteController.GetLikeArticle(userID: NowUserID!)
//                    }
                  
               
                  
                  
                    HStack{
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                            .frame(width: 8)
                        Text("\(likedMovie) movies")
                            .font(.system(size: 12))
                    }
                    
                    Group{
                        NavigationLink(
                            destination: AccountSettingView(userID: $userID),
                            label: {
                                Text("帳號設定")
                                    .font(.system(size: 15))
                                    .frame(width: 350, height: 40, alignment: .center)
                                    .background(Color("CustomRed"))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            })
                            
                        
                        NavigationLink(
                            destination: MovieSettingView(),
                            label: {
                                Text("電影喜好設定")
                                    .font(.system(size: 15))
                                    .frame(width: 350, height: 40, alignment: .center)
                                    .background(Color("CustomRed"))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            })
                            
                        NavigationLink(
                            destination: MyListView(),
                            label: {
                                Text("我的片單")
                                    .font(.system(size: 15))
                                    .frame(width: 350, height: 40, alignment: .center)
                                    .background(Color("CustomRed"))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            })
                            
                        NavigationLink(
                            destination: MyArticleView(),
                            label: {
                                Text("我發表過的文章")
                                    .font(.system(size: 15))
                                    .frame(width: 350, height: 40, alignment: .center)
                                    .background(Color("CustomRed"))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            })
                           
                        
                    }
                
                Spacer()
                
                VStack{
                    ContentChartView(MovieData:MovieData,ArticleData:ArticleData)
                }
                
                Spacer()
//----------喜愛項目----------//
//                    Text("喜愛項目")
//                        .bold()
//                    Picker("123", selection: $select){
//                        ForEach(SideOfState.allCases, id:\.self){
//                            Text($0.rawValue)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    .padding(5)
//                    .frame(width: 360)
//                    switch select{
//                    case .movie:
//                        VStack{
//                            movieRecord(movies: MovieData)
//                        }
//                    case .article:
//                        VStack{
//                            articleRecord(articles: ArticleData)
//                        }
//                    }
                    Spacer()
                }
            .navigationTitle("")
            .navigationBarTitle("")

        }
        .accentColor(.red)
     

    }
    
}

struct AccountSettingView: View {
    
    let FullSize = UIScreen.main.bounds.size
    @Binding var userID:String
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State var show = false
    @State var showImagePicker: Bool = false
    @State var selectedImage: Image? = NowUserPhoto
    @ObservedObject private var userController = UserController()

    
    var body: some View{
        
        ZStack{
            VStack{
                self.selectedImage?
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    
                
                VStack(spacing:10){
                    Button(action:{
                        self.showImagePicker.toggle()
                    }, label:{
                        Text("選擇大頭照")
                    })
        
                    
                    
                }
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePicker(image: self.$selectedImage)
                })
                
                Spacer(minLength: 0)
                
                Form{
                    Section(header: Text("Name")){
                        TextField("\(NowUserName)", text: $name)
                    }
                    Section(header: Text("Email")){
                        TextField("Enter Email", text: $email)
                    }
                    Section(header: Text("Password")){
                        SecureField("Enter Password", text: $password)
                        SecureField("Confirm Password", text: $confirm)
                    }
                }
            }
            
            if self.show == true{
               
                Loader()
                    .frame(width:FullSize.width , height: FullSize.height/1.4, alignment: .center)
                    .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
            
                
                
            }
        
        }
        .navigationTitle("Account Setting")
        .toolbar{
            Button("Save"){
                if NowUserPhoto != selectedImage {
                    self.show = true
                    DispatchQueue.main.asyncAfter(deadline:.now() + 0.1){
                        let uiImage: UIImage = self.selectedImage.asUIImage()
                        userController.PostUserPhoto(uiImage:uiImage)
                        NowUserPhoto = selectedImage
                    }
                    DispatchQueue.main.asyncAfter(deadline:.now() + 2){
                        self.show = false
                    }
                }
                
            }
           
        }
        
    }
}

struct MovieSettingView: View {
    @ObservedObject var dramaData=dramaInfoData()
    let genreData = DataLoader().genreData
    var columns = Array(repeating: GridItem(.flexible(),spacing:15), count: 3)
    var body: some View{
        
        Spacer()
        
        ScrollView(.vertical, showsIndicators: false){
            

            Text("選擇您喜愛的類別")
                .font(.body)
                .padding(15)
            
            LazyVGrid(columns: columns, spacing: 15){

                ForEach(genreData, id:\.id){ genre in
                    genrebutton(genreInfo: genre, dramadata: dramaData)
                }

            }

        }
        .navigationTitle("電影喜好設定")
        .toolbar{
            Button("Save"){}
        }
    }
}

struct genrebutton: View {
    
    var genreInfo: MovieGenre
    var dramadata:dramaInfoData
    @State private var choose : Bool = false
    
    var body: some View{
        
        Button(action: {
            print("press!")
            self.choose.toggle()
            dramadata.mydramaInfo.insert(MovieGenre(id: genreInfo.id, name: genreInfo.name), at: 0)
        }) {
            HStack {
                Text(genreInfo.name)
                    .fontWeight(.semibold)
                    .font(.system(size:15))
            }
            .padding()
            .foregroundColor(self.choose == true ? Color.white : Color.black)
            .background(self.choose == true ? Color("CustomRed") : Color.gray)
            .cornerRadius(40)
            
        }
    }
}



