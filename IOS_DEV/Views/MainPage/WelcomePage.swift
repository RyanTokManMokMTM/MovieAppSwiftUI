//
//  WelcomePage.swift
//  new
//
//  Created by Jackson on 23/2/2021.
//

import SwiftUI
import AVKit

struct HomePage: View {
    @State private var ServerInternalError : Bool = false //for checking server connected
    @ObservedObject private var networkingService = NetworkingService.shared
    @AppStorage("userToken") private var userToken : String = ""
    @State private var isLoggedIn : Bool = false
    @State private var isLoading : Bool = false
    
    @StateObject private var UserVM : UserViewModel = UserViewModel()
    @State private var currentBG = 0
    @State private var isStarted = false

    private let screen  = UIScreen.main.bounds
    init(){
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        
        ZStack{
            if !isLoggedIn {
                BackGroundView()
                HomeInfo()
                
            }else {
                MovieHomePage(isLogOut: $isLoggedIn)
                    .environmentObject(UserVM)
                    .onAppear(perform: {
                        UIScrollView.appearance().bounces = true
                    })
                    .onDisappear(perform: {
                        UIScrollView.appearance().bounces = false
                    })
                    .environment(\.colorScheme, .dark)
            }
        }
        .fullScreenCover(isPresented: $isStarted){
            SignInView(backToHome: $isStarted,isLoggedIn: $isLoggedIn)
                .environmentObject(UserVM)
        }
//        .environmentObject(UserVM)
//        .edgesIgnoringSafeArea(.all)
//        .padding(.top,25)
//        .padding(.horizontal,20)
//        .padding(.bottom,5)
//        .ignoresSafeArea(.keyboard)
        .onAppear{
            APIService.shared.serverConnection(){ result in
                self.isLoading = true
                switch result{
                case .success(let response):
                    print(response)
                    autoLogin()
                case .failure( _):
                    DispatchQueue.main.async{
                        self.ServerInternalError.toggle()
                    }
                    
                }
                self.isLoading = false
                
                
            }
            
        }

        

    }
    
    @ViewBuilder
    func BackGroundView() -> some View{
        ScrollView{
            TabView(selection: $currentBG){
                ForEach(0..<5){i in
                    Image("movie\(i+1)")
                        .resizable()
                        .imageScale(.small)
                        .aspectRatio(contentMode: .fill)
                        .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height,alignment: .center )
                        .clipped()
                        .overlay(
                            Color.black.opacity(0.65).edgesIgnoringSafeArea(.all)
                        )
                        .edgesIgnoringSafeArea(.all)

                }
                .ignoresSafeArea()
            }
            .frame(width: screen.width, height: screen.height, alignment: .center)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    @ViewBuilder
    func HomeInfo() -> some View{
        VStack(){
            Spacer()
            VStack(){
                
                VStack(alignment:.leading,spacing: 12){
                    Text("WELCOME TO MOVIE APP")
                        .foregroundColor(.white)
                        .TekoBold(size: 40)
//                            .padding(.horizontal,20)
                    
                    Text("Enjoy your life time.\nAnd share with your friends!")
                        .lineSpacing(8)
                        .foregroundColor(.white)
                        .PadaukRegular(size: 18)
//                            .padding(.horizontal,20)
                    
                    
                    HStack{
                        ForEach(0..<5){i in

                            Rectangle()
                                .fill(i == currentBG ? Color.red : Color.white)
                                .foregroundColor(.white)
                                .scaleEffect(i  == currentBG ? 1.2 : 1)
                                .frame(width: 5, height: 5)
                                .animation(.spring(), value: i == currentBG)
//                                    .id(currentBG)
                               

                        }

                        Spacer()
                    }
                    .padding(.top,20)
//                        .padding(20)
    //
                    
                }
                .padding(.bottom,screen.height / 6)

                Button(action:{
                    withAnimation(){
                        self.isStarted.toggle()
                    }
                }){
                    Text("GET STARTED")
                        .bold()
                        .OswaldSemiBold()
                        .foregroundColor(.pink)
                        .frame(maxWidth:.infinity,maxHeight: 50)
                        .background(Color.white.cornerRadius(8))
                }
            }
            .padding(.horizontal,30)
            .padding(.bottom,80)
//                .background(Color.white.padding(.horizontal,20))
        }
        .frame(width: screen.width, height: screen.height)

        
    }
    
    func autoLogin(){
        if !userToken.isEmpty{
            print("token exist")
            APIService.shared.GetUserProfile(token: userToken){ (result) in
                switch result{
                case .success(let data):
                    self.UserVM.setUserInfo(info: data)
                    self.isLoggedIn.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                        self.isLoading = false
                    }
                case .failure(let err):
                    DispatchQueue.main.async{
//                        if err.localizedDescription == NetworkingError.badUrl.localizedDescription{
//                            self.ServerInternalError.toggle()
//                        }else{
                            self.isLoading = false
//                        }
                    }
                    print("Error is : \(err.localizedDescription)")
                }
            }
        }
    }
}

class PlayerState: ObservableObject {

    public var currentPlayer: AVPlayer?
    private var videoUrl : URL?

    public func player(for url: URL) -> AVPlayer {
        if let player = currentPlayer, url == videoUrl {
            return player
        }
        currentPlayer = AVPlayer(url: url)
        videoUrl = url
        return currentPlayer!
    }
}

//
//struct ContentViewTest: View {
//    @EnvironmentObject var playerState : PlayerState
//    @State private var vURL = URL(string: "http://127.0.0.1:8080/trailer/trailer.mp4")
//
//    @State private var showVideoPlayer = false
//
//    var body: some View {
//        Button(action: { self.showVideoPlayer = true }) {
//            Text("Start video")
//        }
//        .fullScreenCover(isPresented: $showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause() }){
//            AVPlayerView(videoURL: self.$vURL)
//                .edgesIgnoringSafeArea(.all)
//                .environmentObject(self.playerState)
//        }
//
//    }
//}
//
//struct AVPlayerView: UIViewControllerRepresentable {
//    func makeCoordinator() -> Coordinator {
//        return AVPlayerView.Coordinator(parent: self)
//    }
//
//    @EnvironmentObject var playerState : PlayerState
//    @Binding var videoURL: URL?
//
//    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
//    }
//
//    func makeUIViewController(context: Context) -> AVPlayerViewController {
//        let playerController = AVPlayerViewController()
//        playerController.modalPresentationStyle = .fullScreen
//        playerController.player = playerState.player(for: videoURL!)
//        playerController.player?.play()
//        playerController.delegate = context.coordinator
//        return playerController
//    }
//
//    class Coordinator:NSObject,AVPlayerViewControllerDelegate{
//        var parent : AVPlayerView
//        init(parent : AVPlayerView){
//            self.parent = parent
//        }
//
//
//    }
//}
