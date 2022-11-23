//
//  NavBar.swift
//  IOS_DEV
//
//  Created by Jackson on 17/4/2021.
//

import SwiftUI

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

class MovieDetailManager : ObservableObject {
    @Published var isShowCustomList = false
    @Published  var isAddToUserList = false
    @Published  var movidId = -1
    init(){}
}


struct MovieHomePage: View {
    @State var isLogOut : Bool = false
    
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var HubState : BenHubState = BenHubState.shared
    @StateObject var StateManager  = SeachingViewStateManager()
    @StateObject var postVM = PostVM()

//    @Binding var isLogOut : Bool
    @State private var showHomePage : Bool = false // show it by default
//    @State private var orientation = UIDeviceOrientation.unknown
    @State private var mainPageHeight : CGFloat = 0
    @State private var tabIndex : Int = 0
    @State private var message : String = ""
    @FocusState private var isFocus : Bool
    @Namespace var namespace
    
    @State private var isShowSideMenu : Bool = false
    var body: some View {
//        NavigationView{
            ZStack{
                GeometryReader {geo in
                    VStack(spacing:0){
             
                            TabView(selection: $tabIndex ){
                                MovieListView(showHomePage: $showHomePage,mainPageHeight:$mainPageHeight)
                                    .navigationTitle("")
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .tabItem{
                                        VStack(alignment:.center,spacing:10){
                                            Image(systemName:"film")
                                                .imageScale(.medium)
                                            Text("電影")
                                                .frame(width: 50)
                                                .font(.caption)
                                        }
                                        .foregroundColor(.white)
                                        
                                    }
                                    .tag(0)
                                
                                SoicalView(namespace: namespace)
                                    .navigationTitle("")
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .ignoresSafeArea(.keyboard)
                                    .tabItem{
                                        VStack(alignment:.center,spacing:10){
                                            Image(systemName:"flame")
                                                .imageScale(.medium)
                                            Text("文章")
                                                .frame(width: 50)
                                                .font(.caption)
                                        }
                                        .foregroundColor(.white)
                                        
                                    }
                                    .tag(1)
                                                    
                                MessageView()
                                    .navigationTitle("")
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .tabItem{
                                        VStack(alignment:.center,spacing:10){
                                            Image(systemName:"bell.fill")
                                                .imageScale(.medium)
                                            Text("通知")
                                                .frame(width: 50)
                                                .font(.caption)
                                        }
                                        
                                    }
                                    .tag(2)
                                    .badge(userVM.profile?.totol_notification ?? 0)
                                
                                PersonProfileView(isShowMenu: $isShowSideMenu)
                                    .navigationTitle("")
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .tabItem{
                                        VStack(alignment:.center,spacing:10){
                                            Image(systemName:"person")
                                                .imageScale(.medium)
                                                .font(.body)
                                            Text("我")
                                                .frame(width: 50)
                                                .font(.caption)
                                        }
                                        .foregroundColor(.white)
                                        
                                    }
                                    .tag(3)
                            }
                            .accentColor(.white)
                            .background(Color("DarkMode2"))
           
        
        
                        //                if !isHiddenNav { //Show this when lock portrait
                        //                    NavItemButton(index: self.$index ,GroupSelect: self.$GroupSelect)
                        //                }
                        
                    }
                    
                    .edgesIgnoringSafeArea(.all)
//                    .environmentObject(previewModel)
//                    .environmentObject(StateManager) //here due to bottomSheet need to use to update some state
//                    .environmentObject(DragAndDropPreview) //here due to bottomSheet need to use to update some state
                    .environmentObject(postVM)
                    .environmentObject(userVM)
                    .background(
                        NavigationLink(destination:
                                        PostDetailView(postForm: postVM.selectedPostFrom, isFromProfile: false,postInfo: self.$postVM.selectedPostInfo)
                            .environmentObject(postVM)
                            .environmentObject(userVM)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                                       , isActive: self.$postVM.isShowPostDetail){
                                           EmptyView()
                                           
                                           
                                       }
                        
                    )
//                    .environmentObject(HubState)
                    

                }
//                .ignoresSafeArea(.keyboard, edges: .bottom)
                if self.postVM.isSharePost && self.postVM.sharedData != nil{
                    SharingView(postInfo: self.postVM.sharedData!)
                        .environmentObject(postVM)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                        .onDisappear(){
                            self.postVM.sharedData = nil
                        }
                }
//
                if isShowSideMenu {
                    SideMenu(isShow: $isShowSideMenu,isLogout: $isLogOut)
                        .zIndex(5)
                        .environmentObject(userVM)
                }
                
            }
            .animation(.linear,value: isShowSideMenu)
            .background(Color("DarkMode2").edgesIgnoringSafeArea(.all))
            .onAppear {                    UITabBar.appearance().isTranslucent = false
                    UITabBar.appearance().backgroundColor = UIColor(named:"DarkMode2")
             }
            .alert(isPresented: self.$isLogOut){
                withAnimation(){
                    Alert(title: Text("用戶登出"), message: Text("確定要登出當前帳戶?"),
                          primaryButton: .default(Text("取消")){
                            //
                          },
                          secondaryButton: .default(Text("確定")){
//                            withAnimation{
                                self.userVM.isLogIn = false
//                            }
                          })
                }
                
            }
            
        }
//            .onRotate { newOrientation in
//                if Appdelegate.orientationLock == .landscape {
//                    withAnimation(){
//                        self.isHiddenNav = true
//                    }
//                }else{
//                    withAnimation(){
//                        self.isHiddenNav = false
//                    }
//                }
//
//                orientation = newOrientation
//            }

        

//    }
}


//struct NavItemButton:View{
//    var unselectColor:Color = Color.gray
//    var selectColor:Color = Color.white
//    @Binding var index:Int
//    @Binding var GroupSelect:Bool
//    var body:some View{
//
//        HStack{
//
//
//            //home
//            Button(action:{
//                self.index = 0
//
//            }){
//                VStack(alignment:.center,spacing:10){
//                    Image(systemName:"film")
//                        .shadow(radius: 10)
//                    Text("Home")
//                        .frame(width: 50)
//                        .font(.caption)
//                }
//
//            }
//            .foregroundColor(self.index == 0 ? selectColor : unselectColor)
//
//            Spacer(minLength: 0)
//
//            //list
//            Button(action:{
//                self.index = 1
//                controller.GetAllList()
//
//            }){
//                VStack(alignment:.center,spacing:10){
//                    Image(systemName:"list.and.film")
//                        .shadow(radius: 10)
//                    Text("My List")
//                        .frame(width: 50)
//                        .font(.caption)
//                }
//            }
//            .foregroundColor(self.index == 1 ? selectColor : unselectColor)
//            .simultaneousGesture(TapGesture().onEnded{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                    self.GroupSelect = true
//                })
//            })
//
//            Spacer(minLength: 0)
//
//            //search
//            Button(action:{
//                self.index = 2
//            }){
//                VStack(alignment:.center,spacing:10){
//                    Image(systemName:"magnifyingglass")
//                        .shadow(radius: 10)
//                    Text("Search")
//                        .frame(width: 50)
//                        .font(.caption)
//                }
//            }
//            .foregroundColor(self.index == 2 ? selectColor : unselectColor)
//
//            Spacer(minLength: 0)
//
//            //profile
//            Button(action:{
//                self.index = 3
//            }){
//                VStack(alignment:.center,spacing:10){
//                    Image(systemName:"person")
//                        .shadow(radius: 10)
//                    Text("Profile")
//                        .frame(width: 50)
//                        .font(.caption)
//                }
//            }
//            .foregroundColor(self.index == 3 ? selectColor : unselectColor)
//
//
//        }
//        .padding(.horizontal,25)
//        .padding(.top,10)
//        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//        .background(Color("DarkMode2"))
//    }
//
//
////    var buttonIndex:Int
////    var unselectColor:Color = Color.gray
////    var selectColor:Color = Color.blue
////    var itemIcon:String
////    var itemText:String
////
////    @Binding var isSelectedInt:Int
////
////    var action:()->()
////    var body:some View{
////        Button(action:action){
////            GeometryReader{ proxy in
////                VStack(alignment:.center,spacing:10){
////                    Image(systemName: itemIcon)
////                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
////                      //  .resizable()
////                    Text(itemText)
////                        .frame(width: 50)
////                        .font(.caption)
////
////                }
////            }
////            .foregroundColor(isSelectedInt == buttonIndex ? selectColor : unselectColor)
////            .font(.system(size: 18))
////
////        }
////    }
//
//
//}
