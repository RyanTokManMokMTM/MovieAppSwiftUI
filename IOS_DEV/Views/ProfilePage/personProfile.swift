//
//  personProfile.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 13/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreAudio
import Kingfisher
import Combine //used to add a pulisher to a state variable

struct mainPersonView : View{
    var body: some View{
        NavigationView{
            GeometryReader{proxy in
                let topEdge = proxy.safeAreaInsets.top
                personProfile(topEdge: topEdge)
                    .ignoresSafeArea(.all, edges: .top)
                    .navigationBarTitle("")
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }
        }
    }
}

struct PostCard : Identifiable,Codable{
    var id : String = UUID().uuidString
    let imgURL : String
    let postDesc : String
}
//
let postCardTemp : [PostCard] = [
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/aaczVLsEYSHQzHUYr69bTMRA4CI.jpg", postDesc: "Disney 動畫電影!"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/vFQXJ7BH052XXoJBs03oAZBwCIu.jpg", postDesc: "我最愛的科幻片💗"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/bmLG7qATNsaYVfCWq1NMWpnQy8b.jpg", postDesc: "厲陰宅宇宙"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/clEQH8l0azd1QFEwiOJo4KIjkBY.jpg", postDesc: "恐怖電影系列"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/4p3vfEM17VTweLOKRGBV0XdBHMN.jpg", postDesc: "Marval Universe"),
]

let postCardTemp3 : [PostCard] = [
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/9RKpfJIEM88AaFevGZBm5bRsy7Y.jpg", postDesc: "高校十八禁"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/gWod0mgMkSQBF7kcdmfviD8vrxl.jpg", postDesc: "黃蜂"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/bmLG7qATNsaYVfCWq1NMWpnQy8b.jpg", postDesc: "銀翼殺手：黑蓮花"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/eoF44SOZre7ATLAy5GHPzJ54iyA.jpg", postDesc: "蜘蛛人：無家日"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/tuOu8C02KULf75hehYS6Eowen4a.jpg", postDesc: "霍爾的移動城堡"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/eoF44SOZre7ATLAy5GHPzJ54iyA.jpg", postDesc: "蜘蛛人：無家日"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/6R4RAEFG39l5m40Lyv2XLAq4th6.jpg", postDesc: "永恆族"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/x4IpU9xSyG1TR9kf0w2vyS6zlmr.jpg", postDesc: "尚氣與十環傳奇"),
    PostCard(imgURL: "https://www.themoviedb.org/t/p/original/uD0evJ6OWbEQHZtYdzkp5U29KgQ.jpg", postDesc: "逃出異境"),
]

struct MovieGenreTab : Identifiable ,Codable{
    let id : Int
    let refURL : String
    let genreName : String
    var isSelected : Bool
}

class MoviePrerefencesSettingModel : ObservableObject {
    @Published var prerefencesType : [MovieGenreTab]
    @Published var isSelectedType : [MovieGenreTab] = []
    init(){
        self.prerefencesType = tempGenreTab
    }
    
    func updateSelected(preferencesID : Int){
        print(preferencesID)
        let index = prerefencesType.firstIndex{$0.id == preferencesID}
        guard let index = index else{return}
        
        if self.prerefencesType[index].isSelected{
            self.prerefencesType[index].isSelected.toggle()
            
            //find the index of the items
            let selectedInd = self.isSelectedType.firstIndex(){$0.id == preferencesID}
            self.removeSelected(i: selectedInd!)
            return
        }
        
        if checkIsMaxSelected(){
            print("max")
        }else{
            self.prerefencesType[index].isSelected.toggle()
            self.addSelected(i: index)
        }
    }
    
    private func removeSelected(i : Int){
        //not i
        self.isSelectedType.remove(at: i)
    }
    
    private func addSelected(i : Int){
        self.isSelectedType.append(self.prerefencesType[i])
    }
    
    private func checkIsMaxSelected() -> Bool{
        return isSelectedType.count < 5 ? false : true
    }
    
    
}

let tempGenreTab : [MovieGenreTab] = [
    MovieGenreTab(id: 28, refURL: "https://www.themoviedb.org/t/p/original/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg", genreName: "動作", isSelected: false),
    MovieGenreTab(id: 12, refURL: "https://www.themoviedb.org/t/p/original/5B22eed7ErxFiYAG4Ksb4eLwKNF.jpg", genreName: "冒險", isSelected: false),
    MovieGenreTab(id: 16, refURL: "https://www.themoviedb.org/t/p/original/86Bxkqz9N6zyHOAAPYETZPYCNaq.jpg", genreName: "動畫", isSelected: false),
    MovieGenreTab(id: 35, refURL: "https://www.themoviedb.org/t/p/original/ezyFE2H7vdFoK3dXK4p4ZUaTukW.jpg", genreName: "戲劇", isSelected: false),
    MovieGenreTab(id: 80, refURL: "https://www.themoviedb.org/t/p/original/54yOImQgj8i85u9hxxnaIQBRUuo.jpg", genreName: "犯罪", isSelected: false),
    MovieGenreTab(id: 99, refURL: "https://www.themoviedb.org/t/p/original/g8dafKwLfaueQ5GK0qjKTkRCBAA.jpg", genreName: "紀錄", isSelected: false),
    MovieGenreTab(id: 18, refURL: "https://www.themoviedb.org/t/p/original/tnofyiwMAQQIhUvGPTiMFcgSy0P.jpg", genreName: "劇情", isSelected: false),
    
    MovieGenreTab(id: 10751, refURL: "https://www.themoviedb.org/t/p/original/ytTQoYkdpsgtfDWrNFCei8Mfbxu.jpg", genreName: "家庭", isSelected: false),
    MovieGenreTab(id: 14, refURL: "https://www.themoviedb.org/t/p/original/mPyiNWS0upEG1mGKOKyCQSoZpnp.jpg", genreName: "奇幻", isSelected: false),
    MovieGenreTab(id: 36, refURL: "https://www.themoviedb.org/t/p/original/8o9SLJzM7dvFeInbOXk5Qnft1mk.jpg", genreName: "歷史", isSelected: false),
    MovieGenreTab(id: 27, refURL: "https://www.themoviedb.org/t/p/original/bNnNlUjf16ahEw0uv39NUeQ35YR.jpg", genreName: "恐怖", isSelected: false),
    MovieGenreTab(id: 10402, refURL: "https://www.themoviedb.org/t/p/original/qqthj8EUL4QKlDBoMcPqeWvi6Ya.jpg", genreName: "音樂", isSelected: false),
    MovieGenreTab(id: 9648, refURL: "https://www.themoviedb.org/t/p/original/amqDACUclaUhGWR2ljVIEPB2k2w.jpg", genreName: "懸疑", isSelected: false),
    MovieGenreTab(id: 10749, refURL: "https://www.themoviedb.org/t/p/original/2eMIpBLnk7QFdCyA3M4ZcP7llDt.jpg", genreName: "愛情", isSelected: false),
    MovieGenreTab(id: 878, refURL: "https://www.themoviedb.org/t/p/original/jQdjGWPXXCAxVJc0EXtBiyG3K4g.jpg", genreName: "科幻", isSelected: false),
    MovieGenreTab(id: 53, refURL: "https://www.themoviedb.org/t/p/original/wjQXZTlFM3PVEUmKf1sUajjygqT.jpg", genreName: "驚悚", isSelected: false),
    MovieGenreTab(id: 10752, refURL: "https://www.themoviedb.org/t/p/original/50VD6QU0NX0aRB6ftKCVWun80bm.jpg", genreName: "戰爭", isSelected: false),
    MovieGenreTab(id: 37, refURL: "https://www.themoviedb.org/t/p/original/hwkhL81vsCSjf3ARs6DGpMIZe8n.jpg", genreName: "西部", isSelected: false),
    
    MovieGenreTab(id: 10770, refURL: "https://www.themoviedb.org/t/p/original/kJ2srEZSlmGfAqLKGVMPhBDdr1G.jpg", genreName: "电视电影", isSelected: false)
]

struct UserSetting : View {
    @Binding var isSetting : Bool
    var body : some View{
        GeometryReader{proxy in
            let top = proxy.safeAreaInsets.top
            VStack(spacing : 0){
                ZStack(){
                    Text("Edit Profiles")
                        .bold()
                        .font(.system(size: 14))
                        .padding(.bottom)

                    HStack(alignment: .bottom){
                        Button(action:{
                            withAnimation(){
                                self.isSetting.toggle()
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                                .imageScale(.small)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        Spacer()
                    }
                }
                .padding(.top,top + 10)
                .ignoresSafeArea(.all, edges: .top)

                List(){
                    Section(header:Text("")){
                        
                            fieldCellButton(fieldName: "Help Center", fieldData: "",action: {
                                
                            })
                        
                        fieldCellButton(fieldName: "About App", fieldData: "",action: {
                            
                        })
                    }
                    
                    Section(header:Text("")){
                        Button(action:{
                            
                        }){
                            HStack{
                                Spacer()
                                Text("登出")
                                Spacer()
                            }
                            .foregroundColor(.white)
                        }

                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .navigationTitle("")
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
        .onAppear { UITableView.appearance().isScrollEnabled = false }
        .onDisappear{ UITableView.appearance().isScrollEnabled = true }
    }
    
    @ViewBuilder
    private func fieldCellButton(fieldName : String,fieldData : String,dataFieldColor : Color = .white,isImageType:Bool = false,action : @escaping ()->()) -> some View{
        Group{
            Button(action:action){
                HStack(alignment:.center,spacing:0){
                    Text(fieldName)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing,20)
                    Spacer()
                    
                    if isImageType{
                        Image(fieldData)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(10)
                            .clipped()
                    }else{
                        Text(fieldData)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(dataFieldColor)
                        
                    }
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .padding(.horizontal,5)
                }
                .frame(maxWidth:.infinity)
                .font(.system(size: 15))
                .padding(.vertical,8)
                .padding(.horizontal,0)
            }
            .foregroundColor(.gray)

        }

//        .background(Color("appleDark"))
    }
}

//struct EditTextAreaView : View {
//    var settingHeader : String = "設定"
//    @Binding var editText : String
//    @Binding var isCancel : Bool
//    @State private var isSave : Bool = false
//    var body : some View{
//
//        GeometryReader{proxy in
//            VStack(alignment:.leading){
//                VStack{
//                    HStack(){
//                        Button(action:{
//                            withAnimation(){
//                                self.isCancel.toggle()
//                            }
//                        }){
//                            Text("取消")
//                                .foregroundColor(.white)
//                                .font(.system(size: 14))
//                        }
//                        Spacer()
//                        Text(settingHeader)
//                            .font(.system(size: 14))
//                        Spacer()
//
//                        Button(action:{
//                            withAnimation(){
//                                self.isSave.toggle()
//                                self.isCancel.toggle()
//                            }
//                        }){
//                            Text("完成")
//                                .foregroundColor(.white)
//                                .font(.system(size: 14))
//                        }
//                    }
//                    .font(.system(size: 15))
//                    .padding(.horizontal,5)
//                    .padding(.bottom,10)
//                }
//                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
//                Divider()
//                    .background(Color.white.opacity(0.25))
//
//                HStack{
//                    TextEditor(text: $editText)
//                        .font(.system(size: 13))
//                        .frame(height: 100, alignment: .center)
//                        .background(Color("appleDark"))
//                        .onReceive(Just(editText)){_ in limitText(50)}
//
//
//                }
//                .padding(5)
//                .background(Color("appleDark"))
//                .cornerRadius(10)
//                .overlay(
//                    VStack{
//                        Spacer()
//                        HStack{
//                            Spacer()
//                            Text("\(editText.count)/50")
//                                .foregroundColor(.gray)
//                                .font(.footnote)
//                                .font(.system(size: 13))
//                        }
//                    }
//                    .padding()
//                )
//                .padding(.horizontal)
//
//
//
//            }
//            .onAppear {
//                UITextView.appearance().backgroundColor = .clear
//                UITextView.appearance().tintColor = .gray
//            }
//            .edgesIgnoringSafeArea(.all)
//
//        }
//
//    }
//
//    func limitText(_ upper: Int) {
//        if editText.count > upper {
//            editText = String(editText.prefix(upper))
//        }
//    }
//}

//currently just allow user to edit the name
enum EditType {
    case Name
}

struct EditTextView : View {
    @EnvironmentObject var userVM : UserViewModel
    var editType : EditType
    var settingHeader : String = "設定"
    var placeHolder : String = "Enter the text"
    var maxSize : Int
    var warningMessage : String = ""
    var defaultValue : String
    @Binding var isCancel : Bool
    @State private var isSave : Bool = false
    @State private var typingLength : Int = 0
    @State private var isFocus : [Bool] = [false,true]
    @State private var tempEditStr : String = ""
    var body : some View{
        
        GeometryReader{proxy in
            VStack(alignment:.leading){
                VStack{
                    HStack(){
                        Button(action:{
                            withAnimation(){
                                self.isCancel.toggle()
                            }
                        }){
                            Text("取消")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        Spacer()
                        Text(settingHeader)
                            .font(.system(size: 14))
                        Spacer()
                        
                        Button(action:{
                            withAnimation(){
                                self.isSave.toggle()
                                updateValue()
                                self.isCancel.toggle()
                                //send
                            }
                        }){
                            Text("完成")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                
                        }
                        .opacity(self.tempEditStr != self.defaultValue && !self.checkIsEmpty() ? 1 : 0 )
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal,10)
                    .padding(.bottom,10)
                }
                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                Divider()
                
                HStack{
                    CustomTextView(focuse:$isFocus,text: $tempEditStr, maxSize: maxSize,placeholder: placeHolder, keybooardType: .default, returnKeytype: .default, tag: 1)
                        .frame(height: 20)
                     
                    Spacer()
                    Text("\(updateTextCount())/\(maxSize)")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
                .padding()
                .background(Color("appleDark"))
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    self.isFocus = [false,true]
                }
                
                Text(warningMessage)
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.horizontal,15)
                    .padding(.top,5)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear(){
                self.tempEditStr = defaultValue
            }
        }
        
    }
    
    func checkIsEmpty() -> Bool{
        return self.tempEditStr.isEmpty
    }
    
    func updateTextCount() -> Int{
        
        return self.tempEditStr.count
    }
    
    func updateValue(){
        switch editType{
        case .Name:
            self.userVM.profile!.name = tempEditStr
        default:
            break
        }
    }
    
}
//TODO - TO UPDATE USER MoviePreferences
struct MoviePreferenceSetting : View {
    @EnvironmentObject var userVM : UserViewModel
    @State private var offset : CGFloat = 0.0
    @StateObject var preferencesMv : MoviePrerefencesSettingModel = MoviePrerefencesSettingModel()
    @Binding var isPreferences : Bool

    var body : some View{
        GeometryReader{proxy in
            VStack(spacing:0){
                VStack{
                    HStack(){
                        Button(action:{
                            withAnimation(){
                                self.isPreferences.toggle()
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .imageScale(.medium)
                        }
                        Spacer()
                        Text("專屬設定")
                        Spacer()
                        
                        Button(action:{
                            withAnimation(){
//                              self.userInfo.UserGenrePrerences.append(contentsOf: self.preferencesMv.isSelectedType.map{$0})
          
                                self.isPreferences.toggle()
                            }
                        }){
                            Text("完成")
                                .foregroundColor(.white)
                                .imageScale(.medium)
                            
                        }
                    }
                    .font(.system(size:15))
                    .padding(.horizontal,5)
                    .padding(.bottom,10)
                }
                .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)

              
            
                Divider()
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment:.leading){
                        Text("嗨,\(self.userVM.profile!.name)")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size:15))
                        
                        Text("填寫電影喜好項目,推薦將更符合你的喜好.")
                            .foregroundColor(.gray)
                            .font(.system(size:13))
                            .padding(.bottom,30)
                        
                        
                        HStack{
                            Text("你喜歡的電影類型")
                                .font(.system(size:16))
                                .bold()
                                .foregroundColor(.white)
                            Text("(最多選擇5個類型)")
                                .font(.system(size:13))
                                .foregroundColor(.gray)
                        }
                        
                        SelectionView(genreInfo: $preferencesMv.prerefencesType)
                        Spacer()
                    }

                    .padding(.horizontal,5)
                    .font(.system(size:16))
                    .padding(.top)
                    
                }

                .onAppear(perform:{UIScrollView.appearance().bounces = false})
                .onDisappear(perform: {  UIScrollView.appearance().bounces = true})
                
            }
            .edgesIgnoringSafeArea(.all)
            .environmentObject(preferencesMv)
        }
        
    }
    
}

struct SelectionView : View {
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @Binding var genreInfo : [MovieGenreTab]
    @EnvironmentObject var vm : MoviePrerefencesSettingModel
    var body : some View{
        LazyVGrid(columns: gridItem){
            ForEach(0..<self.genreInfo.count){i in
                userMoviePreferenceTab(info: self.$genreInfo[i])
                    .padding(5)
            }
        }
        
    }
}

struct userMoviePreferenceTab : View {
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @Binding var info : MovieGenreTab
    @EnvironmentObject var vm : MoviePrerefencesSettingModel
    var body : some View{
        HStack{
            WebImage(url: URL(string:info.refURL)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
            
            Text(info.genreName)
                .font(.footnote)
                .foregroundColor(info.isSelected ? Color.red : Color.gray)
                
            Spacer()
                
        }
        .padding(.horizontal,10)
        .frame(width: 175, height: 70)
        .background(Color("appleDark"))
        .cornerRadius(50)
        .overlay(RoundedRectangle(cornerRadius: 50).stroke(lineWidth: 1).fill(info.isSelected ? Color.red.opacity(0.5) : Color.white.opacity(0.25)))
        .onTapGesture {
            withAnimation(){
                self.vm.updateSelected(preferencesID: info.id)
            }
        }
    }
}

struct profileCardCell : View {
    var post : Post
    @EnvironmentObject var userVM : UserViewModel
    var body: some View{
        VStack(alignment:.center){
            WebImage(url: post.post_movie_info.PosterURL)
                .placeholder(Image(systemName: "photo")) //
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(height:230)
                .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))

            Group{
    
                HStack{
                    Text(post.post_title)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.vertical,5)
                .font(.system(size: 15))
//                .frame(width:150,alignment: .center)
                
                HStack{
                    HStack(spacing:5){
                        WebImage(url: self.userVM.profile!.UserPhotoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25, alignment: .center)
                            .clipShape(Circle())
                            
                        VStack(alignment:.leading){
                            Text(userVM.profile!.name).bold()
                                .font(.caption)
                                .foregroundColor(Color("subTextGray"))
                            
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing:5){
                        Image(systemName: "heart")
                            .imageScale(.small)
                        
                        Text(post.post_like_desc)
                            .foregroundColor(Color("subTextGray"))
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal,8)
            
        }
        .padding(.bottom,5)
        .background(Color("MoviePostColor").cornerRadius(5))
        .padding(.horizontal,2)
    }
}

struct PersonPostCardGridView : View{
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    @EnvironmentObject var userVM : UserViewModel
    var body: some View{
        if userVM.profile!.UserCollection == nil {
            if self.userVM.IsPostLoading {
                LoadingView(isLoading: self.userVM.IsPostLoading, error: self.userVM.PostError as NSError?){
                    self.userVM.getUserPosts()
                }
            }
        } else if userVM.profile!.UserCollection!.isEmpty{
            VStack{
                Spacer()
                Text("Not Post yet")
                    .font(.system(size:15))
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(height:UIScreen.main.bounds.height / 2)
            
        }else{
            LazyVGrid(columns: gridItem){
                ForEach(userVM.profile!.UserCollection!,id:\.id){post in
                    profileCardCell(post: post)
                }
            }
        }
    }
        
}

//is liked by user
struct LikedMovieCard : Identifiable ,Codable{
    let id : Int
    let movie_name : String
    let genres : [MovieGenre]
    let movie_poster : String
    let vote_average: Double
    
    var posterPath : URL {
        return URL(string: "https://www.themoviedb.org/t/p/original\(movie_poster)")!
    }

}

struct LikedPostCardGridView : View{
    @EnvironmentObject var userVM : UserViewModel
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        VStack{
            if userVM.IsLikedMovieLoading || userVM.LikedError != nil{
                LoadingView(isLoading: userVM.IsLikedMovieLoading, error: userVM.ListError as NSError?){
                    self.userVM.getUserLikedMovie()
                }
            } else if userVM.profile!.UserLikedMovies != nil{
                if userVM.profile!.UserLikedMovies!.isEmpty{
                    VStack{
                        Spacer()
                        Text("You have't liked any movies yet!")
                            .font(.system(size:15))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(height:UIScreen.main.bounds.height / 2)

                }else{
                    LazyVGrid(columns: gridItem){
                        ForEach(userVM.profile!.UserLikedMovies!,id:\.id){info in
                            
                            NavigationLink(destination: Text("Testing detail")){
                                LikedCardCell(movieInfo: info)
                            }
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarHidden(true)
                        }
                        
                    }
                }
            }
        }
    }
}

struct LikedCardCell : View {
    var movieInfo : LikedMovieCard

    var body: some View{
        VStack(alignment:.center){
            ZStack(alignment:.top){
                WebImage(url:  movieInfo.posterPath)
                    .placeholder(Image(systemName: "photo")) //
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fill)
                    .frame(height:230)
                    .clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners]))
                    .overlay(Color.black.opacity(0.5))
                    .zIndex(0)
                
                VStack(alignment:.leading){
                    HStack(spacing:5){
                        ForEach(0..<movieInfo.genres.count ){i in
                            Text(movieInfo.genres[i].name)
                                .foregroundColor(Color.white)
                                .font(.footnote)
                                .padding(5)
                                .background(Color("appleDark").opacity(0.7).cornerRadius(8))
                            
                        }

                        Spacer()
                    }
                    
                    Spacer()
                    
                    
                    VStack(alignment:.leading){
                        //Movie Full Name
                        Text(movieInfo.movie_name)
                            .foregroundColor(.white)
                            .font(.system(size:18))
                            .bold()
                            .padding(.bottom,5)
                        
                        HStack(spacing:5){
                            ForEach(0..<5){i in
                                Image(systemName:"star.fill" )
                                    .imageScale(.small)
                                    .foregroundColor(i < Int(movieInfo.vote_average / 2) ? Color.yellow : Color.gray)
                                    .font(.system(size:12))
                            }
                        }
                    
                    }

                }
                .padding(8)
            }
            
        }
        .background(Color("MoviePostColor").cornerRadius(5))

    }
}

struct CreateNewListView : View {
    @State private var listTitle : String = ""
    @Binding var isAddingList : Bool
    @EnvironmentObject var userModel : UserViewModel
    @State private var isLoading = false
    @State private var err : Error?
    var body : some View {
        ZStack{
            VStack(alignment:.leading){
                Text("Create a new list")
                    .bold()
                    .font(.system(size:35))
                    .padding(.leading)
                    
                
                List(){
                    Section("LIST INFORMATION"){
                        HStack{
                            Text("Title:")
                            TextField("List Title", text: $listTitle)
                        }
                    }
                    
                    Button(action:{
                        //Create a list
                        CreateNewList()
                    }){
                        Text("Create")
                    }
                    
                    Button(action:{
                        //do nothing and back to the page
                        withAnimation{
                            self.isAddingList = false
                        }
                    }){
                        Text("Cancel")
                    }
                    
                }
            }
            .padding(.top,30)
            
            if isLoading || self.err != nil {
                LoadingView(isLoading: isLoading, error: err as NSError?){
                    CreateNewList()
                }
                .background(BlurView().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            }

        }
    }
    
    func CreateNewList() {
        if listTitle.isEmpty{
            return
        }
        
        let newList = CreateNewCustomListReq(title: listTitle)
        self.isLoading = true
        APIService.shared.CreateCustomList(req: newList){ (result) in
            self.isLoading = false
            switch result{
            case .success(let data):
                let listInfo = CustomListInfo(id: data.id, title: data.title, movie_list: [])
                userModel.profile!.UserCustomList!.append(listInfo)
                self.err = nil
                withAnimation(){
                    self.isAddingList = false
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.err = err
            }
        }
    }
}

struct CustomListView : View{
    @Binding var addList : Bool
    @EnvironmentObject var userVM : UserViewModel
//    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        VStack(){
            Button(action:{
                //Create Own List
                withAnimation(){
                    self.addList.toggle()
                }
            }){
                HStack(spacing:5){
                    Group{
                        Text("Create A New List")
                            .bold()
                            .font(.body)
                        Spacer()
                        Image(systemName: "plus")
                    }
                    .padding(.horizontal,5)
                }
                .frame(height: 50)
                .background(Color("Gray"))
                .cornerRadius(10)
            }.buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(.gray)
            
            
            //If there is not any list data
            //If data is loding
            if userVM.IsListLoading || userVM.ListError != nil{
                LoadingView(isLoading: userVM.IsListLoading, error: userVM.ListError as NSError?){
                    userVM.getUserLikedMovie()
                }
            }else if self.userVM.profile!.UserCustomList != nil{
                ForEach(self.userVM.profile!.UserCustomList!,id:\.id){ info in
                    Button(action:{
                        //Open the list view
                    }){
                        HStack{
//                                Image("defaultAvatar")
//                                    .resizable()
//                                    .frame(width: 25, height: 25)
//                                    .cornerRadius(5)
//                                    .padding(.leading,10)
                  
                            VStack(alignment:.leading){
                                Text(info.title)
                                    .foregroundColor(.white)
                                if info.movie_list == nil{
                                    Text("Empty")
                                        .italic()
                                        .font(.caption)
                                }else {
                                    HStack(spacing:5){
                                        ForEach(0..<(info.movie_list!.count)){ i in
                                            WebImage(url: info.movie_list![i].posterURL)
                                                .resizable()
                                                .indicator(.activity)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                
                            }
                            .foregroundColor(.gray)
                            .padding(5)
                            
                            

                            Spacer()
                            
                                Image(systemName: "chevron.right")
                                    .padding(.horizontal,10)
                        }
                        .frame(height: info.movie_list == nil ? 50 : 100)
                        .background(Color("MoviePostColor"))
                        .cornerRadius(10)
                    }
                }
            }

            
        }
        .padding(5)
    }
}

struct EditProfile : View{
    @EnvironmentObject var userVM : UserViewModel
    @Binding var isEditProfile : Bool
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var userIcon : UIImage = UIImage(named: "image")!
//    @State private var BackGoundImg : UIImage = UIImage(named: "bg")!
    
    @State private var userIconPicker : Bool = false
    @State private var BackGoundImgPicker : Bool = false
    
    @State private var isPreference : Bool = false
    @State private var isEditName : Bool = false
    @State private var isEditeID : Bool = false
//    @State private var isEditeBIO : Bool = false
    

    var body : some View{
        GeometryReader{proxy in
            let top = proxy.safeAreaInsets.top
            VStack(spacing : 0){
                ZStack(){
                    Text("Edit Profiles")
                        .bold()
                        .font(.system(size: 14))
                        .padding(.bottom)

                    HStack(alignment: .bottom){
                        Button(action:{
                            withAnimation(){
                                self.isEditProfile.toggle()
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                                .imageScale(.small)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        Spacer()
                    }
                }
                .padding(.top,top + 10)
                .ignoresSafeArea(.all, edges: .top)
//                .background(Color.red)

                List(){
                    HStack{
                        Spacer()
                        WebImage(url: self.userVM.profile!.UserPhotoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.white)
                            )
                            .overlay(
                                HStack{
                                    Image(systemName: "camera")
                                        .imageScale(.small)
                                        .foregroundColor(.black)
                                }
                                    .frame(width: 25, height: 25)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                ,alignment: .bottomTrailing
                            )
                            .onTapGesture {
                                //TO CHANGE PHOTO
                                print("Change")
                                withAnimation(){
                                    self.userIconPicker.toggle()
                                }
                            }
                        Spacer()
                    }
                    .padding(.vertical)

                    fieldCellButton(fieldName: "名字", fieldData: userVM.profile!.name,action: {
                        withAnimation(){
                            self.isEditName.toggle()
                        }
                    })
                    
                    fieldCellButton(fieldName: "背景圖片",  fieldData: self.userVM.profile!.UserBackGroundURL,isImageType: true,action:{
                        withAnimation(){
                            self.BackGoundImgPicker.toggle()
                        }
                    })
                    
                    fieldCellButton(fieldName: "電影喜好", fieldData: "",action:{
                        withAnimation(){
                            self.isPreference.toggle()
                        }
                    })
    
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .navigationTitle("")
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.all)

        }
        .onAppear { UITableView.appearance().isScrollEnabled = false }
        .onDisappear{ UITableView.appearance().isScrollEnabled = true }
        .fullScreenCover(isPresented: $isEditName){
            EditTextView(
                editType: .Name,
                settingHeader: "設置名字",
                placeHolder: "Enter your name",
                maxSize: 20,
                warningMessage: "設置長度為2-24個字符，不包含非法字符",
                defaultValue: self.userVM.profile!.name,
                isCancel: self.$isEditName)
        }
        .fullScreenCover(isPresented: $userIconPicker){
            EditableImagePickerView(sourceType: .photoLibrary)
                .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $BackGoundImgPicker){

            EditableImagePickerView(sourceType: .photoLibrary)
                .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isPreference){
            MoviePreferenceSetting(isPreferences: $isPreference)
        }
    }
    
    @ViewBuilder
    private func fieldCellButton(fieldName : String,fieldData : Any,dataFieldColor : Color = .white,isImageType:Bool = false,action : @escaping ()->()) -> some View{
        Group{
            Button(action:action){
                HStack(alignment:.center,spacing:0){
                    Text(fieldName)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing,20)
                    Spacer()
                    
                    if isImageType{
                        WebImage(url: fieldData as? URL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(10)
                            .clipped()
                    }else{
                        Text(fieldData as! String)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(dataFieldColor)
                        
                    }
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .padding(.horizontal,5)
                }
                .frame(maxWidth:.infinity)
                .font(.system(size: 15))
                .padding(.vertical,8)
                .padding(.horizontal,0)
            }
            .foregroundColor(.gray)

        }

//        .background(Color("appleDark"))
    }
}




enum ProfileTab : String {
    case Posts = "Posts"
    case Likes = "Likes"
    case MyLists = "Lists"
}

struct ProfileViewTab : Identifiable{
    let id : Int
    let tabName : ProfileTab
    let sysImg : String
}

let tabsInfo : [ProfileViewTab] = [
    ProfileViewTab(id: 0, tabName: .Posts,sysImg: "square.filled.on.square"),
    ProfileViewTab(id: 1, tabName: .Likes,sysImg: "heart.fill"),
    ProfileViewTab(id: 2, tabName: .MyLists,sysImg: "list.and.film"),
]


struct PersonPostTabBar : View{
    @Namespace var namespace
    @Binding var tabIndex : Int
    var body : some View{
        HStack(spacing:10){
            ForEach(tabsInfo,id:\.id){ tab in
                VStack(spacing:12){
                    HStack{
                        Image(systemName:tab.sysImg)
                            .imageScale(.medium)
                        Text(tab.tabName.rawValue)
                            .font(.system(size:14,weight:.semibold))
                         
                    }
                    .foregroundColor(tabIndex == tab.id ? .white : .gray)
                    
                    ZStack{
                        if tabIndex == tab.id {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.orange)
                                .matchedGeometryEffect(id: "TAB", in: namespace)
                        } else {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.clear)
                        }
                    }
                    .padding(.horizontal,8)
                    .frame(height: 4)
                }
//                .animation(.easeInOut)
//                        .transition(.slide)
                .contentShape(Rectangle())
                .onTapGesture(){
                    withAnimation(.easeInOut){
                        tabIndex = tab.id
                    }
                }
            }
        }
        
        .frame(height:50,alignment: .bottom)
        .background(Color("PersonCellColor"))
    }

}

struct personProfile: View {
    @EnvironmentObject var userVM : UserViewModel
    @State private var isEditProfile : Bool = false
    @State private var isSetting : Bool = false
    @State private var isAddingList : Bool = false
    
    private let max = UIScreen.main.bounds.height / 2.5
    var topEdge : CGFloat
    @State private var offset:CGFloat = 0.0
    @State private var menuOffset:CGFloat = 0.0
    @State private var isShowIcon : Bool = false
    @State private var tabBarOffset = UIScreen.main.bounds.width
    @State private var tabOffset : CGFloat = 0.0
    @State private var tabIndex : Int = 0
    

    var body: some View {
        ZStack(alignment:.top){
            ZStack{
//                it may add in the Future
                HStack{
                    Button(action:{}){
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: topEdge)
                .padding(.top,30)
                .zIndex(1)
                
                VStack(alignment:.center){
                    Spacer()
                    HStack{
                        WebImage(url: userVM.profile!.UserPhotoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: .center)
                            .clipShape(Circle())
                        
                        Text(userVM.profile!.name)
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .transition(.move(edge: .bottom))
                .offset(y:self.isShowIcon ? 0 : 40)
                .padding(.trailing,20)
                .frame(width:UIScreen.main.bounds.width ,height: topEdge)
                .padding(.top,30)
                .zIndex(10)
                .clipped()
            }
            .background(Color("ResultCardBlack").opacity(getOpacity()))
            .zIndex(1)
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false){
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]){
                        GeometryReader{ proxy  in
                            ZStack(alignment:.top){
                                WebImage(url: userVM.profile!.UserBackGroundURL)
                                    .resizable()
                                    .aspectRatio( contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
                                    .overlay(
                                        LinearGradient(colors: [
                                            Color("PersonCellColor").opacity(0.3),
                                            Color("PersonCellColor").opacity(0.6),
                                            Color("PersonCellColor").opacity(0.8),
                                            Color("PersonCellColor"),
                                            Color.black
                                        ], startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
                                    )
                                    .zIndex(0)
                                
                                
                                profile()
                                    .frame(maxWidth:.infinity)
                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
                                    .zIndex(1)
                                
                            }
                        }
                        .frame(height:max)
                        .offset(y:-offset)
                        
                        Section {
                            TabView(selection:$tabIndex){
                                VStack{
                                    
                                    PersonPostCardGridView()
                                        .padding(.vertical,3)
                                            .environmentObject(userVM)

                                    Spacer()
                                }
                                .tag(0)
      

                                VStack{
                                    LikedPostCardGridView()
                                        .environmentObject(userVM)
                                        .padding(.vertical,3)
                                        .onAppear{
                                            if userVM.profile!.UserLikedMovies == nil{
                                                userVM.getUserLikedMovie()
                                            }
                                        }

                                    Spacer()
                                }
                                .tag(1)

                                VStack{
                                    CustomListView(addList: $isAddingList)
                                        .environmentObject(userVM)
                                        .padding(.vertical,3)
                                        .onAppear{
                                            if userVM.profile!.UserCustomList == nil{
                                                userVM.getUserList()
                                            }
                                        }
                                    Spacer()
                                }
                                    .tag(2)
                                
                            }
                            .animation(.default)
                            .transition(.slide)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height:proxy.size.height, alignment: .top)
            
                        } header: {
                            VStack(spacing:0){
                                //
                                PersonPostTabBar(tabIndex: $tabIndex)
                                Divider()
                            }
                            .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
                            .overlay(
                                GeometryReader{proxy -> Color in
                                    let minY = proxy.frame(in: .global).minY
                                    
                                    DispatchQueue.main.async {
                                        self.menuOffset = minY
                                    }
                                    return Color.clear
                                }
                            )
                        }
                        
                        
                        
                    }
                    .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
                    .frame(alignment:.top)
                }
                .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
                .zIndex(0)
                .onAppear{
                    self.userVM.getUserPosts()
                    
                }
            }
            
        }
        .sheet(isPresented: self.$isAddingList) {
            CreateNewListView(isAddingList: $isAddingList)
                .environmentObject(userVM)
        }
        
    }
    
    @ViewBuilder
    func profile() -> some View{
        VStack(alignment:.leading){
            Spacer()
            HStack(alignment:.center){
                WebImage(url: userVM.profile!.UserPhotoURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
//                    .overlay(
//                        HStack{
//                            Image(systemName: "plus")
//                                .imageScale(.small)
//                        }
//                            .frame(width: 20, height: 20)
//                            .background(Color.orange)
//                            .clipShape(Circle())
//                            ,alignment: .bottomTrailing
//                    )

                VStack(alignment:.leading){
                    Text(userVM.profile!.name).bold()
                        .font(.title2)
//                    HStack(spacing:2){
//                        Text("MID:")
//                        Text(userVM.user.MID)
//                    }
//                    .font(.caption)
//                    .foregroundColor(Color.white.opacity(0.8))
                    
                }
                
                Spacer()
            }
                .padding(.bottom)
            
            VStack(alignment:.leading,spacing: 8){
                Text("個人喜好電影🎬")
                    .font(.footnote)
                    .bold()
                
                if self.userVM.profile!.UserGenrePrerences!.isEmpty{
                    Text("使用者沒有特定喜好的電影項目~")
                        .font(.footnote)
                }else{
                    
                    HStack{
                        ForEach(0..<userVM.profile!.UserGenrePrerences!.count){i in
                                Text(userVM.profile!.UserGenrePrerences![i].genreName)
                                    .font(.caption)
                                    .padding(8)
                                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
               

                        }
                    }
                    .padding(.top,5)
                }
            }
            
            
            HStack{
//                VStack{
//                    Text("\(userVM.user.Following)")
//                        .bold()
//                    Text("Following")
//                }
//
//                VStack{
//                    Text("\(userVM.user.Followers)")
//                        .bold()
//                    Text("Followers")
//                }

                
                VStack{
                    Text("0")
                        .bold()
                    Text("Likes")
                }

                Spacer()
                
                Button(action:{
                    //TODO : Edite data
                    withAnimation(){
                        self.isEditProfile.toggle()
                    }
                }){
                    NavigationLink(destination:
                                    EditProfile(isEditProfile: $isEditProfile)
                                   , isActive: $isEditProfile){
                        Text("Edit Profile")
                            .navigationBarBackButtonHidden(true)
                            .padding(8)
                            .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                    }
                }
                .buttonStyle(StaticButtonStyle())
                .foregroundColor(.white)

                Button(action:{
                    //TODO : Edite data
                }){
                    NavigationLink(destination: UserSetting(isSetting: $isSetting), isActive: $isSetting){
                        Image(systemName: "gearshape")
                            .padding(.horizontal,5)
                            .padding(8)
                            .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                    }
                }
                .foregroundColor(.white)

            }
            .font(.footnote)
            .padding(.vertical)
        
        }
        .padding(.horizontal)
       
    }

    
    private func getHeaderHigth() -> CGFloat{
        //setting the height of the header
        
        let top = max + offset
        //constrain is set to 80 now
        // < 60 + topEdge not at the top yet
        return top > (40 + topEdge) ? top : 40 + topEdge
    }
    
    private func getOpacity() -> CGFloat{
        let progress = -(offset + 40 ) / 70
        return -offset > 40  ?  progress : 0
    }

}

