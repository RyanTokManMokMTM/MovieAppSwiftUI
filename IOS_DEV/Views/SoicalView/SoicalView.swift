//
//  SoicalView.swift
//  IOS_DEV
//
//  Created by Jackson on 8/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

enum TabItem : String{
    case Explore = "Explore"
    case Follow = "Follow"

}

struct SoicalView: View {
    @EnvironmentObject var postVM : PostVM
    var namespace : Namespace.ID
    var body: some View {
  
            GeometryReader{proxy in
//                ZStack(alignment:.top){
                VStack(spacing:0){
                        NavTabView(index: self.$postVM.index)
                            .frame(maxWidth:.infinity)
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            TabView(selection: self.$postVM.index){
                                CardFlowLayout(namespace: namespace)
                                    .tag(TabItem.Explore)
                                FollowUserPostView()
                                    .tag(TabItem.Follow)
                            }
                            .animation(.easeOut(duration: 0.2), value: self.postVM.index)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(width: proxy.size.width)
                            
                        }.frame(alignment: .top)
//                            .ignoresSafeArea()
                    }
                   
                    

                    //Change to any?????
//                    if self.postVM.isShowMore &&  self.postVM.selectedMoreData != nil{
//                        Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
//
//                        PostBottomSheet(info: self.postVM.selectedMoreData!)
//                            .animation(.easeInOut)
//                            .transition(.move(edge: .bottom))
//                            .environmentObject(postVM)
//                            .zIndex(2)
//
//
//                    }//

                    
                    
//                }
                .environmentObject(postVM)

            }
            .onAppear{
                self.postVM.GetAllUserPost()
                self.postVM.GetFollowUserPost()
            }
    }
}


struct NavTabView : View{
    @EnvironmentObject var postVM : PostVM
    @EnvironmentObject var userVM : UserViewModel
    @Binding var index : TabItem
    @State private var isSelectMovie : Bool = false
    var body: some View {
        HStack{
            NavigationLink(destination:
                            PostMovieSelection(isSelectMovie: $isSelectMovie)
                            .navigationBarTitle("")
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(postVM)
                            .environmentObject(userVM)
                           ,
                           isActive: $isSelectMovie){
                Image(systemName:"plus.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .navigationBarTitle("")
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
            
            Spacer()
            Button(action:{
                
            }){
                Image(systemName:"paperplane")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }.overlay(
            HStack(spacing:20){
                NavTabItem(tab: .Explore, index: $index)
                NavTabItem(tab: .Follow, index: $index)
            }
                .animation(.easeInOut)
//                        .transition(.slide)
                .padding(.horizontal)
        )
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width, height: 40)
            .background(Color("appleDark"))
        

    }
}

struct NavTabItem : View {
    var tab : TabItem
    @Binding var index : TabItem
    var body : some View{
        Button(action:{
            withAnimation{
                self.index = tab
            }
        }){
            Text(tab.rawValue)
                .font(.system(size: 16, weight: self.index == tab ? .bold : .medium ))
                .foregroundColor(Color.white.opacity(self.index == tab ? 0.7 : 0.3))
                .scaleEffect(self.index == tab ? 1.1 : 1)
                .padding(.horizontal,15)
            
        }
    }
}

//class NewsPostModel : ObservableObject {
//    @Published var postManager : [PostInfo]
//    init(){
//        self.postManager = postTemp
//    }
//}

//struct MainNewView : View {
//    @StateObject var postVM : NewsPostModel = NewsPostModel()
//    var body : some View {
//        Color.black.edgesIgnoringSafeArea(.all)
//    }
//}
