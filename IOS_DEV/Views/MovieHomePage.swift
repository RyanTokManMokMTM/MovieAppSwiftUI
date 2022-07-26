//
//  NavBar.swift
//  IOS_DEV
//
//  Created by Jackson on 17/4/2021.
//

import SwiftUI
let controller = ListController()
let favoriteController = FavoriteController()
//Working Process
//struct NavBar: View {
////    @Binding var selectedIndex:Int
//    @State var index : Int
//    @State var GroupSelect : Bool = false
//    @ObservedObject private var userController = UserController()
//    var body: some View {
//
//        VStack{
//
//            ZStack{
//                if self.index == 0 {
//                    HomePage()
//
//                }
//                if self.index == 1 && GroupSelect == true{
//                    ListView(lists: controller.listData)
//
//                }
//                if self.index == 2 {
//                    AutoScroll_V().preferredColorScheme(.dark)
//
//                }
//                if self.index == 3 {
//                    ProfileView(NowUser: userController.NowUser)
//                }
//
//
//            }
//            NavItemButton(index: self.$index ,GroupSelect: self.$GroupSelect)
//        }.onAppear{
//            self.userController.GetNowUser(UserName: NowUserName)
//        }
//
//
//    }
//}
//
//  NavBar.swift
//  IOS_DEV
//
//  Created by Jackson on 17/4/2021.
//


//Working Process
//struct NavBar: View {
////    @Binding var selectedIndex:Int
//    @State var index : Int
//    @State var GroupSelect : Bool = false
//    @ObservedObject private var userController = UserController()
//    var body: some View {
//
//        VStack{
//
//            ZStack{
//                if self.index == 0 {
//                    HomePage()
//
//                }
//                if self.index == 1 && GroupSelect == true{
//                    ListView(lists: controller.listData)
//
//                }
//                if self.index == 2 {
//                    AutoScroll_V().preferredColorScheme(.dark)
//
//                }
//                if self.index == 3 {
//                    ProfileView(NowUser: userController.NowUser)
//                }
//
//
//            }
//            NavItemButton(index: self.$index ,GroupSelect: self.$GroupSelect)
//        }.onAppear{
//            self.userController.GetNowUser(UserName: NowUserName)
//        }
//
//
//    }
//}

//Working Process


//struct TestData : Codable{
//    let name : String
//    let phone : String
//}
//
//struct APITester : View{
//    private let service = APIService.shared
//    @State private var apiError : MovieError? = nil
//    var body: some View{
//        VStack{
//            Button(action: {
//                self.serviceTest()
//            }){
//                VStack{
//                    Text("Send request")
//                }
//            }
//        }
//    }
//
//    private func serviceTest(){
//        service.fetchAllGenres{ result in
////            guard let self = self else {return}
//            switch result{
//            case .success(let response):
//                print(response.response[1])
//                break
//            case .failure(let err):
//                self.apiError = err
//                break
//            }
//
//        }
//
//    }
//
//    private func sendDirectorRequest(){
//        let uri = "http://127.0.0.1:8080/api/playground/getdirector?page=1"
//        let req = URLRequest(url: URL(string: uri)!)
//        URLSession.shared.dataTask(with: req){(data,res,err) in
//
//            if err != nil {
//                print(err!.localizedDescription)
//                return
//            }
//
//            guard let data = data else {
//                print("No Data")
//                return
//            }
//
//            let decoder = JSONDecoder()
//
//            if let result = try? decoder.decode(PersonInfoResponse.self, from: data){
//                print(result.response[0])
//            }else{
//                print("Uable to parse JSON response")
//            }
//
//        }.resume()
//    }
//
//    private func sendActorRequest(){
//        let url = "http://127.0.0.1:8080/api/playground/getactor?page=1"
//        let req = URLRequest(url: URL(string: url)!)
//
//        URLSession.shared.dataTask(with: req){ (data,res,err) in
//
//            if let apiError = err {
//                print(apiError.localizedDescription)
//                return
//            }
//
//            guard let data = data else{
//                print("No Data from Response")
//                return
//            }
//
//
//            let decoder = JSONDecoder()
//            if let result = try? decoder.decode(PersonInfoResponse.self, from: data){
//                print(result.response[0])
//            }else{
//                print("Unable to parse JSON response")
//            }
//
//        }.resume()
//
//    }
//
//    private func sendGenreAllRequest() {
//        let url = "http://127.0.0.1:8080/api/playground/getallgenres"
//        let req = URLRequest(url: URL(string: url)!)
//
//        URLSession.shared.dataTask(with: req){ (data,res,err) in
//
//            if let apiError = err {
//                print(apiError.localizedDescription)
//                return
//            }
//
//            guard let data = data else{
//                print("No Data from Response")
//                return
//            }
//
//
//            let decoder = JSONDecoder()
//            if let result = try? decoder.decode(GenreInfoResponse.self, from: data){
//                print(result.response)
//            }else{
//                print("Unable to parse JSON response")
//            }
//
//        }.resume()
//    }
//
//    private func sendGenreByidRequest() {
//        let url = "http://127.0.0.1:8080/api/playground/getgenre?id=12"
//        let req = URLRequest(url: URL(string: url)!)
//
//        URLSession.shared.dataTask(with: req){ (data,res,err) in
//
//            if let apiError = err {
//                print(apiError.localizedDescription)
//                return
//            }
//
//            guard let data = data else{
//                print("No Data from Response")
//                return
//            }
//
//
//            let decoder = JSONDecoder()
//            if let result = try? decoder.decode(GenreInfoResponse.self, from: data){
//                print(result.response)
//            }else{
//                print("Unable to parse JSON response")
//            }
//
//        }.resume()
//    }
//
//    private func postDataRequest(){
//        let url = "http://127.0.0.1:8081/api/playground/getpreview"
//        var req = URLRequest(url: URL(string: url)!)
//        req.httpMethod = "POST"
//        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let postDatas : [TestData] = [
//            TestData(name: "Jackson", phone: "12345677889"),
//            TestData(name: "Alice", phone: "0987654321")
//        ]
//
//        let encoder = JSONEncoder()
//        let encodeDatas = try? encoder.encode(postDatas)
//
//        URLSession.shared.uploadTask(with: req, from: encodeDatas){(data,response,error) in
//            guard error == nil else {
//
//                return
//            }
//
//            //reponse cast to httpResponse ? and status code is 2xx?
//            guard let statusCode = response as? HTTPURLResponse,200..<300 ~= statusCode.statusCode else{
//
//                return
//            }
//
//            guard let data = data else{
//
//                return
//            }
//
//            let decoder = JSONDecoder()
//            if let result = try? decoder.decode(String.self, from: data){
//                print(result)
//            }else{
//                print("Unable to parse JSON response")
//            }
//        }
//    }
//
//
//}
//

struct MovieHomePage: View {
    @StateObject var previewModel = PreviewModel()
    @StateObject var StateManager  = SeachingViewStateManager()
    @StateObject var DragAndDropPreview = DragSearchModel()

    @Binding var isLogOut : Bool
    @State var index : Int
    @State private var GroupSelect : Bool = false
    @State private var isPriview = false
    @State private var showHomePage : Bool = false // show it by default
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var isHiddenNav : Bool = false
    @State private var mainPageHeight : CGFloat = 0
    @State private var tabIndex : Int = 0;
    
    
    @ObservedObject private var userController = UserController() //Image Update
    
    var body: some View {
        ZStack(alignment:.top){
            VStack(spacing:0){
                GeometryReader{geo in
                    TabView{
                        TrailerMainPage(showHomePage: $showHomePage, isLogOut: $isLogOut, mainPageHeight: $mainPageHeight)
                            .tabItem{
        
                                    VStack(alignment:.center,spacing:10){
                                        Image(systemName:"film")
                                        Text("Movie")
                                            .frame(width: 50)
                                            .font(.caption)
                                    }
                                    .foregroundColor(.white)
                                
                            }
  
                        SoicalView()
                            .tabItem{
                                    VStack(alignment:.center,spacing:10){
                                        Image(systemName:"network")
                                        Text("News")
                                            .frame(width: 50)
                                            .font(.caption)
                                    }
                                    .foregroundColor(.white)
                                
                            }

                        
//                        Text("New Posts")
//                            .tabItem{
//                                if !menuState.isHidden{
//                                    VStack(alignment:.center,spacing:10){
//                                        Image(systemName:"plus.app.fill")
//                                        Text("Post")
//                                            .frame(width: 50)
//                                            .font(.caption)
//                                    }
//                                }
//                            }
//
                            
                        
                       Text("Search")
                            .tabItem{
                                    VStack(alignment:.center,spacing:10){
                                        Image(systemName:"magnifyingglass")
                                        Text("Search")
                                            .frame(width: 50)
                                            .font(.caption)
                                    }
                                
                            }
               
                        mainPersonView()
                            .tabItem{
                                    VStack(alignment:.center,spacing:10){
                                        Image(systemName:"person")
                                            .font(.body)
                                        Text("Profile")
                                            .frame(width: 50)
                                            .font(.caption)
                                    }
                                    .foregroundColor(.white)
                                
                            }

//                        MessageView()
//                            .tabItem{
//                                if !menuState.isHidden{
//                                    VStack(alignment:.center,spacing:10){
//                                        Image(systemName:"message")
//                                            .font(.body)
//                                        Text("My List")
//                                            .frame(width: 50)
//                                            .font(.caption)
//                                    }
//                                    .foregroundColor(.white)
//                                }
//                            }
//                            .opacity(self.index == 2 ? 1 : 0)
                        //
                        //
//                            .opacity(self.index == 3 ? 1 : 0)
                        //                        ProfileView(MovieData:favoriteController.MovieData, ArticleData: favoriteController.ArticleData)
                        //                            .opacity(self.index == 3 ? 1 : 0)
                        //
                    }
                    .accentColor(.white)
//                    .onAppear(){
//                        self.mainPageHeight = geo.frame(in: .global).height
//                    }
                
                    
//                    ZStack(alignment:.top){
//                        TrailerMainPage(showHomePage: $showHomePage, isLogOut: $isLogOut, mainPageHeight: $mainPageHeight)
//                            .opacity(self.index == 0 ? 1 : 0)
//
////                        CardScrollingView()
////                            .opacity((self.index == 1 && GroupSelect == true) ? 1 : 0)
//                        ListView(lists: controller.listData)
//                            .opacity((self.index == 1 && GroupSelect == true) ? 1 : 0)
////
//
////                        DragAndDropMainView()
////                            .opacity(self.index == 1 ? 1 : 0)
////
//                        MessageView()
//                            .opacity(self.index == 2 ? 1 : 0)
////
////
//                        mainPersonView()
//                            .opacity(self.index == 3 ? 1 : 0)
////                        ProfileView(MovieData:favoriteController.MovieData, ArticleData: favoriteController.ArticleData)
////                            .opacity(self.index == 3 ? 1 : 0)
//                        //
//                    }.onAppear(){
//                        self.mainPageHeight = geo.frame(in: .global).height
//                    }
                }
//                if !isHiddenNav { //Show this when lock portrait
//                    NavItemButton(index: self.$index ,GroupSelect: self.$GroupSelect)
//                }

            }
              
            .edgesIgnoringSafeArea(.all)
            //thse all padding is to adding back the padding of ignoresSafeArea()
            //ignoresSafeArea() just for keyboard
            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding(.leading,UIApplication.shared.windows.first?.safeAreaInsets.left)
            .padding(.trailing,UIApplication.shared.windows.first?.safeAreaInsets.right)
            
            BottomSheet()
                .animation(.spring())

        }
        .onRotate { newOrientation in
            if Appdelegate.orientationLock == .landscape {
                withAnimation(){
                    self.isHiddenNav = true
                }
            }else{
                withAnimation(){
                    self.isHiddenNav = false
                }
            }
            
            orientation = newOrientation
        }
//        .environmentObject(menuState)
        .environmentObject(previewModel)
        .environmentObject(StateManager) //here due to bottomSheet need to use to update some state
        .environmentObject(DragAndDropPreview) //here due to bottomSheet need to use to update some state
        .ignoresSafeArea()

    }
}

//struct NavBar_Previews: PreviewProvider {
//    static var previews: some View {
//
//        Group {
//            ZStack{
//                Color.black.ignoresSafeArea(.all)
//                NavBar(index: 0)
//            }
//        }
//
//
//    }
//}

struct NavItemButton:View{
    var unselectColor:Color = Color.gray
    var selectColor:Color = Color.white
    @Binding var index:Int
    @Binding var GroupSelect:Bool
    var body:some View{
        
        HStack{
            
            
            //home
            Button(action:{
                self.index = 0
                
            }){
                VStack(alignment:.center,spacing:10){
                    Image(systemName:"film")
                        .shadow(radius: 10)
                    Text("Home")
                        .frame(width: 50)
                        .font(.caption)
                }
                
            }
            .foregroundColor(self.index == 0 ? selectColor : unselectColor)
            
            Spacer(minLength: 0)
            
            //list
            Button(action:{
                self.index = 1
                controller.GetAllList()
 
            }){
                VStack(alignment:.center,spacing:10){
                    Image(systemName:"list.and.film")
                        .shadow(radius: 10)
                    Text("My List")
                        .frame(width: 50)
                        .font(.caption)
                }
            }
            .foregroundColor(self.index == 1 ? selectColor : unselectColor)
            .simultaneousGesture(TapGesture().onEnded{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.GroupSelect = true
                })
            })
            
            Spacer(minLength: 0)
            
            //search
            Button(action:{
                self.index = 2
            }){
                VStack(alignment:.center,spacing:10){
                    Image(systemName:"magnifyingglass")
                        .shadow(radius: 10)
                    Text("Search")
                        .frame(width: 50)
                        .font(.caption)
                }
            }
            .foregroundColor(self.index == 2 ? selectColor : unselectColor)
            
            Spacer(minLength: 0)
            
            //profile
            Button(action:{
                self.index = 3
            }){
                VStack(alignment:.center,spacing:10){
                    Image(systemName:"person")
                        .shadow(radius: 10)
                    Text("Profile")
                        .frame(width: 50)
                        .font(.caption)
                }
            }
            .foregroundColor(self.index == 3 ? selectColor : unselectColor)
            
            
        }
        .padding(.horizontal,25)
        .padding(.top,10)
        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .background(Color("DarkMode2"))
    }

    
//    var buttonIndex:Int
//    var unselectColor:Color = Color.gray
//    var selectColor:Color = Color.blue
//    var itemIcon:String
//    var itemText:String
//
//    @Binding var isSelectedInt:Int
//
//    var action:()->()
//    var body:some View{
//        Button(action:action){
//            GeometryReader{ proxy in
//                VStack(alignment:.center,spacing:10){
//                    Image(systemName: itemIcon)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                      //  .resizable()
//                    Text(itemText)
//                        .frame(width: 50)
//                        .font(.caption)
//
//                }
//            }
//            .foregroundColor(isSelectedInt == buttonIndex ? selectColor : unselectColor)
//            .font(.system(size: 18))
//
//        }
//    }
    

}
