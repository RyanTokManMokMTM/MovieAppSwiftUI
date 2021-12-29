//
//  WelcomePage.swift
//  new
//
//  Created by Jackson on 23/2/2021.
//

import SwiftUI
import AVKit
struct WelcomePage: View {
    let screen = UIScreen.main.bounds
//    @ObservedObject var networkConnectionService = NetworkConnectionService()
    @State private var ServerInternalError : Bool = false
    @State private var isSignUp : Bool = false
    @State private var isSignIn : Bool = false
    @State private var animateImagge:Bool = false

    //Auto login is Token is not null
    @AppStorage("userToken") private var userToken : String = ""
    @State private var isLoggedIn : Bool = false
    @State private var isLoading : Bool = false
    @ObservedObject private var networkingService = NetworkingService.shared
    var body: some View {
        
        ZStack(){
            Group{
                Image("HomeBG")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                    .offset(x:animateImagge ? 0 : -100)
                    .animation(.easeInOut(duration: 20).repeatForever())
                    .frame(width:screen.width)
                    .zIndex(-1)
                    .overlay(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all).blur(radius: 10))
                
                VStack(spacing:20){
                    Spacer()
                    HStack(spacing:10) {
                        Text("Adam's apple")
                            .foregroundColor(Color.white)
                            .CourgetteRegularFont(size: 50)
                            .offset(x:animateImagge ? 0 : -350)
                            .animation(.easeInOut(duration: 1.5))
                    }
                    .frame(width:screen.width - 50)
                    .padding(.horizontal,5)
                    .padding(.bottom,50)
                    
                    Spacer()
                    //2button here
                    VStack{
                        LargeButton(text: "Sign In", textColor: .black, button: .white){
                            withAnimation(){
                                isSignIn.toggle()
                            }
                        }
                        .fullScreenCover(isPresented: $isSignIn, content: {
                            SignIn(isSignIn: $isSignIn, isLoggedIn: $isLoggedIn)
                        })
                        
                        LargeButton(text: "Sign Up", textColor: .black, button:Color.red.opacity(0.75)){
                            withAnimation(){
                                isSignUp.toggle()
                            }
                        }
                        .fullScreenCover(isPresented: $isSignUp, content: {
                            SignUp(isSignUp: $isSignUp, isSignIn: self.$isSignIn)
                        })
                    }
                    .offset(y:animateImagge ? 0 : 400)
                    .animation(.easeInOut(duration: 1.5))

                }
            }
            .zIndex(0)
            
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all)
                    .zIndex(1)
            }

        }
        .onAppear{
            APIService.shared.serverConnection(){ result in
                self.isLoading = true
                switch result{
                case .success(let response):
                    print(response)
                    autoLogin()
                case .failure(let error):
                    DispatchQueue.main.async{
                        self.ServerInternalError.toggle()
                    }
                   
                }
                self.isLoading = false
                
                
            }
            animateImagge = true
          
        }
        .fullScreenCover(isPresented: self.$isLoggedIn, content: {
            NavBar(isLogOut: self.$isLoggedIn,index: 0)
        })
//        .alert(isPresented: self.$networkConnectionService.isConnected){
//            return Alert(title: Text("Networking Error"), message: Text("WIFI is disconnected..."), dismissButton: .default(Text("OK"),action: {
//                exit(0)
//            }))
//        }
        //Movie to root page -> when ever server is unable to connect
        .alert(isPresented: self.$ServerInternalError){
            return Alert(title: Text("Networking Error"), message: Text("Server's unable to connect...try again later."), dismissButton: .default(Text("OK"),action: {
                exit(0)
            }))
        }

        
    }
    
    
    func autoLogin(){
        
        if !userToken.isEmpty{
            print("???")
            networkingService.AuthUser(token: self.userToken){ result in
                switch result{
                case.success(let data):
                    NowUserName = data.UserName
                    NowUserID = data.id
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
                    //
                }
                
            }
        }
    }

}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
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


struct ContentViewTest: View {
    @EnvironmentObject var playerState : PlayerState
    @State private var vURL = URL(string: "http://127.0.0.1:8080/trailer/trailer.mp4")

    @State private var showVideoPlayer = false

    var body: some View {
        Button(action: { self.showVideoPlayer = true }) {
            Text("Start video")
        }
        .fullScreenCover(isPresented: $showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause() }){
            AVPlayerView(videoURL: self.$vURL)
                .edgesIgnoringSafeArea(.all)
                .environmentObject(self.playerState)
        }

    }
}
//
//struct HomeTest : View{
//    @State var test : Bool = false
//    var body: some View{
//        VStack{
//            Text("Toggle")
//                .onTapGesture(){
//                    self.test.toggle()
//                }
//        }
//        .fullScreenCover(isPresented: $test){
//            Player(VideoPlayer: VideoList[0].videoPlayer, videoLayer: .resizeAspect, isLandScape: self.$test)
//                .edgesIgnoringSafeArea(.all)
////                .onAppear(perform: {
////
////
////                    Appdelegate.orientationLock = UIInterfaceOrientationMask.all
////
////                      UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
////
////                      UINavigationController.attemptRotationToDeviceOrientation()
////
////                    })
////                .onDisappear(perform: {
////
////
////
////                          Appdelegate.orientationLock = UIInterfaceOrientationMask.portrait
////
////                        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
////
////                        UINavigationController.attemptRotationToDeviceOrientation()
////
////
////
////                    })
//        }
//    }
//}


struct AVPlayerView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return AVPlayerView.Coordinator(parent: self)
    }

    @EnvironmentObject var playerState : PlayerState
    @Binding var videoURL: URL?

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = playerState.player(for: videoURL!)
        playerController.player?.play()
        playerController.delegate = context.coordinator
        return playerController
    }
    
    class Coordinator:NSObject,AVPlayerViewControllerDelegate{
        var parent : AVPlayerView
        init(parent : AVPlayerView){
            self.parent = parent
        }
        
        
    }
}
