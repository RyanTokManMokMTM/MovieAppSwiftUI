//
//  Player.swift
//  IOS_DEV
//
//  Created by Jackson on 8/4/2021.
//

import Foundation
import SwiftUI
import UIKit
import AVKit


//let AVPlayerController to SWiftUI

struct TrailerPlayer:UIViewControllerRepresentable{
    var player:AVPlayer
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let movieTrailerPlayer = AVPlayerViewController()
        movieTrailerPlayer.player = player
//        movieTrailerPlayer.player?.play()
        movieTrailerPlayer.showsPlaybackControls = false
        return movieTrailerPlayer
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        //to update view
        
    }
}




struct Player:UIViewControllerRepresentable{
    var VideoPlayer:AVPlayer
    var videoLayer : AVLayerVideoGravity = .resizeAspect
    func makeCoordinator() -> Coordinator {
        return Player.Coordinator(parent: self)
    }

    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerview = AVPlayerViewController()
        playerview.player = VideoPlayer
        playerview.showsPlaybackControls = false
        playerview.videoGravity = videoLayer
        playerview.delegate = context.coordinator
        

        return playerview
    }
    
    func updateUIViewController(_ controller: AVPlayerViewController, context content: Context) {
        if Appdelegate.orientationLock == .landscape{
            controller.modalPresentationStyle = .fullScreen
        }else{
            controller.modalPresentationStyle = .none
        }
    }
    
    
    class Coordinator:NSObject,AVPlayerViewControllerDelegate{
        var parent : Player
        init(parent : Player){
            self.parent = parent
        }


    }
    
}

struct PlayerScrollView<Content:View>: UIViewRepresentable{
    @EnvironmentObject var TrailerModel  : TrailerVideoVM
    func makeCoordinator() -> Coordinator {
        return PlayerScrollView.Coordinator(parent: self,didRefresh: self.$reload)
    }

//    @Binding var trailerList:[Trailer]
    @Binding var reload:Bool
    @Binding var value:Float
    @Binding var isAnimation:Bool
    @Binding var isUpdateView : Bool

    @Binding var orientation : UIDeviceOrientation
    
    @State private var indexChange : Bool = false
    let pageHegiht:CGFloat
    let content:()->Content

    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        viewSetUp(view)
        view.delegate = context.coordinator
        self.TrailerModel.loadMoreDataDone = false
        return view

    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.isScrollEnabled = !(self.TrailerModel.isSelectedEpisode &&  Appdelegate.orientationLock != .landscape) &&  Appdelegate.orientationLock == .portrait
        
        if isUpdateView{
            viewSetUp(uiView)
            viewUpdated()
        }else if  TrailerModel.loadMoreDataDone{
            viewSetUp(uiView) // Portrait mode
            self.TrailerModel.loadMoreDataDone = false
        }
        uiView.delegate = context.coordinator
    }

    private func viewSetUp(_ view: UIScrollView){
        let rootView = UIHostingController(rootView: self.content())
        rootView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pageHegiht * CGFloat(TrailerModel.TrailerList.count))
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1.0)
        view.contentSize = CGSize(width: UIScreen.main.bounds.width, height:  pageHegiht * CGFloat(TrailerModel.TrailerList.count))
        view.subviews.last?.removeFromSuperview()
        view.addSubview(rootView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled =  true
        view.alwaysBounceVertical = false
        view.bounces = false
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled  = true
        view.contentOffset.y =  CGFloat(self.TrailerModel.currentTrailer) * pageHegiht
//        view.delegate = context.coordinator
        
    }

    private func viewUpdated(){
        DispatchQueue.main.async {
            self.isUpdateView = false
        }
    }

    class Coordinator:NSObject,UIScrollViewDelegate{

        var parentView:PlayerScrollView
        var index = 0 //default index
        var loadMore :Binding<Bool>

        init(parent:PlayerScrollView,didRefresh:Binding<Bool>){
            parentView = parent
            loadMore = didRefresh

        }
        //is Scroll ened?
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            let currentIndex = Int(scrollView.contentOffset.y / parentView.pageHegiht)
            if currentIndex != self.parentView.TrailerModel.currentTrailer {
                self.parentView.value = 0
            }
            self.parentView.TrailerModel.currentTrailer = currentIndex
            
            if index != currentIndex{
                index = currentIndex

                for i in 0..<parentView.TrailerModel.TrailerList.count{
                    parentView.TrailerModel.TrailerList[i].videoPlayer.seek(to: .zero) //video time line to 0
                    parentView.TrailerModel.TrailerList[i].videoPlayer.pause() //pause the video
                    parentView.isAnimation = false
                }

                parentView.TrailerModel.TrailerList[index].videoPlayer.play() //play the video
                parentView.TrailerModel.TrailerList[index].videoPlayer.actionAtItemEnd = .none
                
                parentView.isAnimation = true
                
                
                //add Observer to player timeer
                parentView.TrailerModel.TrailerList[index].videoPlayer.addPeriodicTimeObserver(forInterval: .init(seconds: 1.0, preferredTimescale: 1), queue: .main){ _ in
                    self.parentView.value =  Float(self.parentView.TrailerModel.TrailerList[self.index].videoPlayer.currentTime().seconds  / (self.parentView.TrailerModel.TrailerList[self.index].videoPlayer.currentItem?.duration.seconds ?? 0))
  
                }
                
                
                NotificationCenter.default.addObserver(forName: Notification.Name.AVPlayerItemDidPlayToEndTime, object: parentView.TrailerModel.TrailerList[index].videoPlayer.currentItem, queue: .main){ (_) in
                    self.parentView.TrailerModel.TrailerList[self.index].videoPlayer.seek(to: .zero)
                    self.parentView.TrailerModel.TrailerList[self.index].videoPlayer.play()
                    print("end")
                }
            }
            
            if currentIndex == self.parentView.TrailerModel.TrailerList.count - 1 {
                self.parentView.TrailerModel.getTrailer()
            }
        }
    }
}

struct VideoProgressBar : UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return VideoProgressBar.Coordinator(parent: self)
    }
    
    @Binding var value:Float
    var player:AVPlayer
    var minTintColor : UIColor = .white
    var maxTintColor : UIColor = .clear
    var setThumbImage : Bool = false
    func makeUIView(context: Context) -> UISlider {
        let silder = UISlider()
        silder.minimumTrackTintColor = minTintColor
        silder.maximumTrackTintColor = maxTintColor
        silder.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        silder.tintColor = .white
        silder.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
//        silder.thumbTintColor = .white
        silder.value = value
//        silder.
        silder.addTarget(context.coordinator, action: #selector(context.coordinator.videoTimeProgress(silder:)), for: .valueChanged)
        return silder
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
       // print(value)
        uiView.value = value
    }
    
    class Coordinator:NSObject{
        var parentView:VideoProgressBar
        
        init(parent:VideoProgressBar){
            parentView = parent
        }
        
        @objc func videoTimeProgress(silder:UISlider){

            if silder.isTracking{
                // when user moving slider bar
                //silder target will call that function
                
                //pause the video
                self.parentView.player.pause()
                
                //getting total video time * silder.value
                //max silder value is 1
                let trackingSec = Double(silder.value * Float(parentView.player.currentItem!.duration.seconds))
                
                //set current video time seek to silder value * total duration
                self.parentView.player.seek(to: .init(seconds: trackingSec, preferredTimescale: 1))
                
            }
            else{

                let trackingSec = Double(silder.value * Float(parentView.player.currentItem!.duration.seconds)) //is total second is 10 and tracking is 5s
                self.parentView.player.seek(to: .init(seconds: trackingSec, preferredTimescale: 1))
                self.parentView.player.play()
            }
        }
    }
}
