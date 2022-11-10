//
//  WelcomePage.swift
//  new
//
//  Created by Jackson on 23/2/2021.
//

import SwiftUI
import AVKit

struct HomePage: View {
    @StateObject private var HubState : BenHubState = BenHubState.shared
    @State private var ServerInternalError : Bool = false //for checking server connected
    @ObservedObject private var networkingService = NetworkingService.shared
    @AppStorage("userToken") private var userToken : String = ""
    @State private var isLoggedIn : Bool = false
    @State private var isLoading : Bool = false
    
    @StateObject private var UserVM : UserViewModel = UserViewModel()
    @State private var currentBG = 0
    @State private var isStarted = false

    init(){
        UIActivityIndicatorView.appearance().style = .medium
    }
    
    var body: some View {
        
        NavigationView(){
            ZStack{
                
                SignInView()
                    .environmentObject(UserVM)
                    .environmentObject(HubState)
                    .zIndex(0)
                
                if UserVM.isLogIn{
                    MovieHomePage(isLogOut: $isLoggedIn)
                        .environmentObject(UserVM)
                        .environmentObject(HubState)
                        .environment(\.colorScheme, .dark)
                        .zIndex(1)
                        .onAppear(){
                            //get chat room info and connected to ws
                            MessageViewModel.shared.GetUserRooms()
                            WebsocketManager.shared.connect()
                        }

                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .accentColor(.white)
            .onAppear(){
                WebsocketManager.shared.userVM = UserVM
            }
        }
        .navigationViewStyle(.stack)
//        .onAppear{
//            APIService.shared.serverConnection(){ result in
//                self.isLoading = true
//                switch result{
//                case .success(let response):
//                    print(response)
//                    autoLogin()
//                case .failure( _):
//                    DispatchQueue.main.async{
//                        self.ServerInternalError.toggle()
//                    }
//
//                }
//                self.isLoading = false
//
//
//            }
//
//        }

        

    }
    
    func autoLogin(){
//        if !userToken.isEmpty{
//            print("token exist")
//            APIService.shared.GetUserProfile(token: userToken){ (result) in
//                switch result{
//                case .success(let data):
//                    self.UserVM.setUserInfo(info: data)
//                    self.isLoggedIn.toggle()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
//                        self.isLoading = false
//                    }
//                case .failure(let err):
//                    DispatchQueue.main.async{
////                        if err.localizedDescription == NetworkingError.badUrl.localizedDescription{
////                            self.ServerInternalError.toggle()
////                        }else{
//                            self.isLoading = false
////                        }
//                    }
//                    print("Error is : \(err.localizedDescription)")
//                }
//            }
//        }
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
