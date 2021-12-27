//
//  HomePage.swift
//  IOS_DEV
//
//  Created by Jackson on 29/3/2021.
//
//120.126.17.213:33865
import SwiftUI
import Foundation
import AVKit
import SDWebImageSwiftUI


class TrailerVideoVM : ObservableObject {
    //
    @Published var TrailerList : [Trailer] = []
    @Published var isNetworkingErr : Error?
    @Published var isLoading : Bool = false
    @Published var currentTrailer : Int = 0
    @Published var isSelectedEpisode : Bool = false
    @Published var isNoResource : Bool = false
    @Published var loadMoreDataDone : Bool = false
    private var page = 1
    

    private var apiService : APIService
    private let resoucesHOST = "http://127.0.0.1:8080/trailer"
    init(apiService : APIService = APIService.shared){
        self.apiService = apiService
        getTrailer()
    }
    
    func getTrailer(){
        if isNoResource{
            return
        }
        self.loadMoreDataDone = false
        self.isNetworkingErr = nil
        self.isLoading = true
        self.apiService.getMovieTrailerList(page:self.page){ [weak self] result in
            guard let self = self else{
                return
            }
            
            switch result{
            case .success(let response):
                if response.count <= 0{
                    self.isNoResource.toggle()
                    break
                }
                print(response)
                self.TrailerList.append(contentsOf:
                                            response.map{Trailer(
                                                id: $0.id,
                                                videoPlayer:AVPlayer(url: self.getResoureceURL(path: $0.video_paths[0])),info: $0)}
                )
                self.page += 1
                self.loadMoreDataDone = true
            case .failure(let error):
                self.isNetworkingErr = error as Error
                
            }
            self.isLoading = false
        }
    }
    
    func getResoureceURL(path: String) -> URL{
       return URL(string: "\(self.resoucesHOST)\(path)")!
    }
    
    func resetTrailerEpideso(){
        self.TrailerList.forEach{ info in
            info.videoPlayer.replaceCurrentItem(with: AVPlayerItem(url: self.getResoureceURL(path: info.info.video_paths[0])))
        }
    }
}

class TrailerStateManager : ObservableObject{
    @Published var isReload = false
    @Published var isAnimation = false
    @Published var isNavBarHidden = true
    @Published var isActive = false
    @Published var isLoading = true
    @Published var NavIndex = 0
    @Published var isShowVideoController : Bool = true
    @Published var pageHeight : CGFloat = 0
    init(){}
}


struct StaticButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct HomePage:View{
    @Binding var showHomePage : Bool
    @Binding var isLogOut : Bool
    @Binding var mainPageHeight : CGFloat

    
    var body:some View{
        NavigationView{
            MovieListView(showHomePage: $showHomePage, isLogOut: self.$isLogOut,mainPageHeight:$mainPageHeight)
        }
        .environment(\.horizontalSizeClass, .compact)

    }
}

struct MovieTrailerDiscoryView : View{
    @EnvironmentObject var TrailerVM : TrailerVideoVM
    @StateObject private var TrailerManager = TrailerStateManager()
    @State private var isLoading : Bool = false
    @State private var orientaion : UIDeviceOrientation = UIDeviceOrientation.unknown
    @Binding var showHomePage : Bool
    @Binding var mainPageHeight : CGFloat
    
    var body : some View{
        ZStack(alignment:.top){
            GeometryReader{ geo in
                ZStack(alignment:.center){
                    HomeTrailerPlayer(showHomePage: $showHomePage, mainPageHeight: $mainPageHeight,pageHeight: geo.frame(in: .global).height)
                }
            }
            
            if !orientaion.isLandscape && (Appdelegate.orientationLock == .portrait){
                HStack{
                    BackHomePageButton(){
                        //jump back to home page
                        self.showHomePage.toggle()
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        //List all current video trailer with name
                        withAnimation(){
//                            self.isSelectTrailer.toggle()
                            
                            self.TrailerVM.isSelectedEpisode.toggle()
                        }
                    }){
                        VStack{
                            Text("RELATED TRAILER")
                                .foregroundColor(.white)
                                .TekoBoldFontFont(size: 15)
                        }
                        .padding()
                        .background(BlurView().clipShape(CustomeConer(coners: .allCorners)))

                    }
                }
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.horizontal,15)
                .opacity(self.TrailerVM.isSelectedEpisode ? 0 : 1)

            }
            
        }
        .onRotate{value in
            orientaion = value
        }
        .environmentObject(TrailerManager)
        .edgesIgnoringSafeArea(.all)
        .onDisappear(){
            self.TrailerVM.resetTrailerEpideso()
        }
        
    }

}

struct HomeTrailerPlayer:View{
    @EnvironmentObject private var TrailerModel : TrailerVideoVM
    @EnvironmentObject private var TrailerManager : TrailerStateManager
    
    @Binding var showHomePage : Bool
    @Binding var mainPageHeight : CGFloat
    @State private var value : Float = 0
    var pageHeight : CGFloat
    var body:some View{
        PlayerScrollList(value:$value, showHomePage: $showHomePage,mainPageHeight: $mainPageHeight, pageHeight:pageHeight)
            .onAppear(perform: {
                if  TrailerModel.TrailerList.count <= 0{
                    return
                }
                
                TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.play()
                TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.actionAtItemEnd = .none
                
                TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main){_ in
                    self.value = Float(
                        (self.TrailerModel.TrailerList[self.TrailerModel.currentTrailer]
                            .videoPlayer.currentTime().seconds / self.TrailerModel
                                .TrailerList[self.TrailerModel.currentTrailer]
                                .videoPlayer.currentItem!.duration.seconds ))
                }
                
                NotificationCenter.default.addObserver(forName: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                                       object: TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.currentItem, queue: .main){ _ in
                    TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.seek(to: .zero)
                    TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.play()
                }

            })
        
        
    }
}


struct FullScreenTop :View{
    @Binding var isUpdateView : Bool
    @Binding var isFullScreen : Bool
    var movieName : String
    
    var body: some View{
        HStack(alignment:.center){
            Button(action: {
                //Close to full screen
                DispatchQueue.main.async {
                    Appdelegate.orientationLock = UIInterfaceOrientationMask.portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                    withAnimation(){
                        self.isFullScreen.toggle()
                        self.isUpdateView = true
                    }
                }

            }, label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding()
                    
            })

            VStack{
                HStack{
                    Text(movieName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        
                    
                    Spacer()
                }
            }
            .frame(maxWidth:.infinity)
            .padding(.horizontal)
            Spacer()
                
            
        }
        .edgesIgnoringSafeArea(.top)
        .padding(.top,35)
        .padding(.horizontal,50)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct VideoTimeline : View {
//    @Binding var value : Float
    @EnvironmentObject var TrailerModel : TrailerVM

    var maxValue : Double
    @Binding var isPlaying : Bool
    @Binding var trailerInfo : Trailer
    @State private var value : Float = 0
    var body: some View{
        VStack{
            VideoProgressBar(value: $value, player: trailerInfo.videoPlayer, minTintColor: .red, maxTintColor: .gray)
            HStack{
                Button(action: {
                    if isPlaying {
                        trailerInfo.videoPlayer.pause()
                    }else{
                        trailerInfo.videoPlayer.play()
                    }
                    isPlaying.toggle()
                    
                }, label: {
                    HStack{
                        Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .padding(8)
                    }
                    .frame(width: 20, height: 20, alignment: .center)

                })
                
                HStack{
                    Text("\(getTrailerMins(second:trailerInfo.videoPlayer.currentTime().seconds ))/\(self.getTrailerMins(second: maxValue))")
                        .bold()
                        .padding(.horizontal,3)
                }
                Spacer()
            }
           
        }
        .padding(.bottom,20)
        .padding(.horizontal,70)
        .onAppear(){
//            print(maxValue)
            trailerInfo.videoPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main){ _ in
                self.value = Float(trailerInfo.videoPlayer.currentTime().seconds / trailerInfo.videoPlayer.currentItem!.duration.seconds)
                
            }
            
        }
    }
    
    
    private func getTrailerMins(second : Double)-> String{
//        print(trailerInfo.videoPlayer.currentItem!.duration.seconds)
        if second.isNaN {
            return "N/A"
        }

        let (m,s) = (((Int(second) % 3600) / 60), ((Int(second) % 3600) % 60))
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"
        return "\(m_string):\(s_string)"
    }
    
}

struct PlayerScrollList: View {
    @EnvironmentObject  var TrailerModel : TrailerVideoVM
    @EnvironmentObject  var TrailerManager : TrailerStateManager
    
    @State private var isFullScreen : Bool = false
//    @State private var currentVideo : Int = 0
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var counter : Int = 1
    @State private var trailerTime : Double = 0
    @State private var isPlaying : Bool = true
    @State private var isUpdateView : Bool  = false //When toggle to FullScreen View
    @State private var fullScreenSize : CGFloat = 0
    @Binding var value : Float
    @Binding var showHomePage : Bool
    @Binding var mainPageHeight : CGFloat
    @State private var trailerEpisode : Int = 0
    var pageHeight : CGFloat

    var body: some View {
        Group{
            PlayerScrollView(reload: $TrailerManager.isReload, value:$value, isAnimation: $TrailerManager.isAnimation , isUpdateView: $isUpdateView,orientation:$orientation ,pageHegiht: Appdelegate.orientationLock == .landscape ? UIScreen.main.bounds.height  : self.mainPageHeight){
                LazyVStack(spacing:0){
                    ForEach(0..<TrailerModel.TrailerList.count){ i in
                        ZStack{
                            if isFullScreen && i != self.TrailerModel.currentTrailer{
                                EmptyView()
                            }else{
                                TrailerCell(pageHeight: pageHeight,mainPageHeight:$mainPageHeight, trailerInfo: $TrailerModel.TrailerList[i], isFullScreen: $isFullScreen, isUpdateView: $isUpdateView, value: $value ,isPlaying:$isPlaying, trailerIndex:i)
                            }
                            
                        }
                        
                        .frame(width:UIScreen.main.bounds.width,height: Appdelegate.orientationLock == .landscape ? UIScreen.main.bounds.height  : self.mainPageHeight)
                        
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .onDisappear(perform: {
                TrailerModel.TrailerList[self.TrailerModel.currentTrailer].videoPlayer.pause()
            })
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        

    }
    
}

struct TrailerCell : View{
    @EnvironmentObject  var TrailerModel : TrailerVideoVM
    @EnvironmentObject  var TrailerManager : TrailerStateManager
    
    var pageHeight : CGFloat
    @Binding var mainPageHeight : CGFloat
//    @Binding var currentVideo : Int
    @Binding var trailerInfo : Trailer
    @Binding var isFullScreen : Bool
    @Binding var isUpdateView : Bool
    @Binding var value : Float
    @Binding var isPlaying : Bool
    @State private var isShowController : Bool = true
    @State private var counter : Int = 0
    @State private var trailerEpisode : Int = 0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var trailerIndex : Int
    var body : some View {

        ZStack(alignment:.center){

            Player(VideoPlayer: trailerInfo.videoPlayer,videoLayer:.resizeAspect)
                .frame(width:UIScreen.main.bounds.width,height: Appdelegate.orientationLock == .landscape ? UIScreen.main.bounds.height : self.mainPageHeight)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture{
                    //Testing
                   
                    if isFullScreen{
                        counter = 0
                        withAnimation(.easeOut(duration: 0.2)){
                            isShowController.toggle()
                        }
                    }else{
                        if isPlaying{
                            self.trailerInfo.videoPlayer.pause()
                        }
                        else{
                            self.trailerInfo.videoPlayer.play()
                        }
                    }

                }
                .zIndex(0)
                .padding(.top,Appdelegate.orientationLock == .landscape ? 21 : 0)
            
            if !isFullScreen && !isPlaying{
                
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .font(.system(size:85))
                    .opacity(0.65)
                    .onTapGesture(){
                        self.trailerInfo.videoPlayer.play()
                    }

                
            }

        
            if Appdelegate.orientationLock == .portrait{
                Group{
                    MovieIntrol(trailer: $trailerInfo, tailerIndex: trailerIndex, isFullScreen: self.$isFullScreen, isUpdateView: $isUpdateView)
                    VStack{
                        Spacer()
                        VideoProgressBar(value: trailerIndex ==  self.TrailerModel.currentTrailer ? $value : .constant(0), player: TrailerModel.TrailerList[trailerIndex].videoPlayer)
                    }
                }
            } else   if isShowController{
                VStack{
                    Group{
                        FullScreenTop(isUpdateView: $isUpdateView, isFullScreen: $isFullScreen, movieName: trailerInfo.info.title)
                        Spacer()
                        VideoTimeline(maxValue: trailerInfo.videoPlayer.currentItem?.duration.seconds ?? 0, isPlaying: $isPlaying, trailerInfo: $trailerInfo)
                    }
                    
                }
                .background(Color.black.opacity(0.5).onTapGesture{
                    counter = 0
                    withAnimation(.easeOut(duration: 0.2)){
                        isShowController.toggle()
                    }
                })
                .frame(height:  Appdelegate.orientationLock == .landscape ? UIScreen.main.bounds.height : self.mainPageHeight)
                .zIndex(2)
            }
            
            

            if self.TrailerModel.isSelectedEpisode{
                VStack{
                    Spacer()
                    ForEach(0..<self.TrailerModel.TrailerList[TrailerModel.currentTrailer].info.video_paths.count){ i in
                        HStack{
                            Text(self.TrailerModel.TrailerList[TrailerModel.currentTrailer].info.video_titles[i])
                                .TekoBoldFontFont(size:self.trailerEpisode == i ? 20 : 16)
                                .multilineTextAlignment(.center)
                                .foregroundColor(self.trailerEpisode == i ? .white : .gray)
//                                .scaleEffect(self.trailerEpisode == i ? 1.1 : 1.0)
                                .transition(.slide)
//                                .frame(width: UIScreen.main.bounds.width)
//                                .padding(.horizontal)
                                
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding()
                        .onTapGesture(){
                            if self.trailerEpisode == i {
                                return
                            }
                            
                        
                            withAnimation(.easeInOut){
                                self.trailerEpisode = i
                                self.TrailerModel.isSelectedEpisode.toggle()
                            }
                            
                            DispatchQueue.main.async {
                                let url = self.TrailerModel.getResoureceURL(path: self.TrailerModel.TrailerList[TrailerModel.currentTrailer].info.video_paths[i])
                                self.TrailerModel.TrailerList[TrailerModel.currentTrailer].videoPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
                            }
                        }

                    }
                    
                    Spacer()
                    
                    Button(action:{
                        withAnimation(){
                            self.TrailerModel.isSelectedEpisode.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName:"xmark")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                        
                        
                    }
                    .padding(.bottom)

                }
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: mainPageHeight)
                .background(BlurView())
                .transition(.opacity)
                .zIndex(10)
            }
            
        }
        .onReceive(timer){_ in
            if counter < 3 && isShowController{
                counter += 1
            }else{
                counter = 1
                withAnimation(){
                    self.isShowController = false
                }
            }
        }
        .onChange(of: trailerInfo.videoPlayer.timeControlStatus){v in
            if v == AVPlayer.TimeControlStatus.playing{
                self.isPlaying = true
                
            }else if v == AVPlayer.TimeControlStatus.paused{
                self.isPlaying = false
            }else{
                self.isPlaying = false
            }
            print(self.isPlaying)
        }

        .onDisappear(){
            timer.upstream.connect().cancel()
        }
    }
    
}

struct MovieIntrol: View {
    @EnvironmentObject  var TrailerModel : TrailerVideoVM
    @EnvironmentObject  var TrailerManager : TrailerStateManager
    
    @Binding var trailer:Trailer
    var tailerIndex : Int
    @Binding var isFullScreen : Bool
    @Binding var isUpdateView : Bool
    var body: some View {
        VStack{
            Spacer()
            HStack(alignment:.bottom){
                VStack(alignment:.leading,spacing:10){
                    Button(action: {
                            DispatchQueue.main.async {
                                Appdelegate.orientationLock = UIInterfaceOrientationMask.landscape
                                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                                UINavigationController.attemptRotationToDeviceOrientation()
                                self.isFullScreen.toggle()
                                self.TrailerModel.currentTrailer = tailerIndex
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(){
                                        self.isUpdateView = true
                                    }
                                }

                                
                            }
     
                    }, label: {
                        HStack{
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                            Text("Full Screen")
                                .font(.subheadline)
                               
                        }
                        .padding(5)
                        .background(BlurView().clipShape(CustomeConer(width: 5, height: 5, coners: [.allCorners])))
                    })
                    
                    HStack{
                        Text(trailer.info.title)
                            .TekoBoldFontFont(size: 25)
                        
                    }
                    
                    HStack{
                        ForEach(trailer.info.genres,id: \.self ){ type in
                            Text(type)
                                .font(.system(size: 14))
                                .bold()
                                .foregroundColor(Color.white)
                                .padding(.horizontal,8)
                                .padding(.vertical,5)
                                .background(BlurView().clipShape(CustomeConer(coners: [.allCorners])))
                                .cornerRadius(5)
                        }
                    }

                    
                }
                .font(.body)
                Spacer()
                
//                if previewMovieId != nil{
//                    NavigationLink(destination: MovieDetailView(movieId:self.previewMovieId!, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true)), isActive: self.$isMovieDetail){
//                        EmptyView()
//                    }
//                }
                
                VStack{
                    NavigationLink(destination: MovieDetailView(movieId:trailer.id,navBarHidden: $TrailerManager.isNavBarHidden,isAction: $TrailerManager.isActive,isLoading: $TrailerManager.isLoading)){
                        SmallCoverIcon(posterPath: trailer.info.poster)
                            .navigationBarTitle(TrailerManager.isActive ? "Back" : "")

                    }
                    .navigationTitle( "")
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .buttonStyle(StaticButtonStyle())
                    

                }
                .padding(.horizontal,5)
            }
        }
        .padding(.horizontal,5)
        .foregroundColor(.white)
        .padding(.vertical,15)
        .padding(.bottom,5)
//        .navigationTitle("")
//        .navigationBarTitle("")
//        .navigationBarHidden(true)

    }
}

struct BackHomePageButton:View{
    var action:()->()
    var body: some View{
        Button(action:action, label: {
            ZStack{
                Circle()
                    .foregroundColor(Color.init("ThemeSubColor").opacity(0.8))
                    .frame(width: 30, height: 50)
                
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .opacity(0.85)
            }
        })

        
        
    }
}

