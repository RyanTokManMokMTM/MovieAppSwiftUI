//
//  IOS_DEVApp.swift
//  IOS_DEV
//
//  Created by Jackson on 28/3/2021.
//

import Foundation
import SwiftUI
import AVFoundation
import SDWebImageSwiftUI

@main
struct IOS_DEVApp: App {
    @UIApplicationDelegateAdaptor(Appdelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            NavBar(isLogOut: .constant(false), index: 0)
//                .ignoresSafeArea()
//            WelcomePage2()
            ChattingView()
        }
    }
}


struct imagePickerTestView : View{
    @State private var isShowPicker : Bool = false
    @State private var image : UIImage = UIImage(named: "image")!
    var body : some View{
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150, alignment: .center)
                .clipShape(Circle())
                .padding()
                .onTapGesture {
                    withAnimation(){
                        self.isShowPicker.toggle()
                    }
                }
        }.fullScreenCover(isPresented: $isShowPicker){
            EditableImagePickerView(sourceType: .photoLibrary, selectedImage: $image)
        }
    }
}

//struct TestContent: View {
//    var originalImage = UIImage(named: "image")
//    @State var croppedImage:UIImage?
//    @State var cropperShown = false
//
//    var body: some View {
//        VStack{
//            Spacer()
//            Text("Original")
//            Image(uiImage: originalImage!)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//            Spacer()
//            if croppedImage != nil {
//                Text("Cropped")
//                Image(uiImage: croppedImage!)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                Spacer()
//            }
//
//            Button(action: {cropperShown = true}){
//                Text("Go to cropper")
//            }
//
//            Spacer()
//        }
//        .fullScreenCover(isPresented: $cropperShown){
//            ImageCropVIew(isCropping: $cropperShown, image: originalImage!, croppedImage: $croppedImage)
//        }
//
//    }
//
//}


extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
      formatter.allowedUnits = [.hour,.minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}


struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}


let testList  : [MovieRule] = [
    MovieRule(name: "Action", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ppiL13JJx2LkyoNb8JM0h7nxYmk.jpg"),
    MovieRule(name: "Adventure", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/9dKCd55IuTT5QRs989m9Qlb7d2B.jpg"),
    MovieRule(name: "Comedy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg"),
    MovieRule(name: "Crime", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ky8Fua6PD7FyyOA7JACh3GDETli.jpg"),
    MovieRule(name: "Fantasy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/dkokENeY5Ka30BFgWAqk14mbnGs.jpg"),
    MovieRule(name: "Horror", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/bShgiEQoPnWdw4LBrYT5u18JF34.jpg"),
    MovieRule(name: "Science Fiction", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/78wC6ZWhTlqaCNL0rS7jl7dAV85.jpg"),
    MovieRule(name: "Comedy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg"),
    MovieRule(name: "Crime", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ky8Fua6PD7FyyOA7JACh3GDETli.jpg"),
    MovieRule(name: "Fantasy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/dkokENeY5Ka30BFgWAqk14mbnGs.jpg"),
    MovieRule(name: "Horror", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/bShgiEQoPnWdw4LBrYT5u18JF34.jpg"),
    MovieRule(name: "Science Fiction", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/78wC6ZWhTlqaCNL0rS7jl7dAV85.jpg"),
    MovieRule(name: "Comedy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg"),
    MovieRule(name: "Crime", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ky8Fua6PD7FyyOA7JACh3GDETli.jpg"),
    MovieRule(name: "Fantasy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/dkokENeY5Ka30BFgWAqk14mbnGs.jpg"),
    MovieRule(name: "Horror", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/bShgiEQoPnWdw4LBrYT5u18JF34.jpg"),
    MovieRule(name: "Science Fiction", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/78wC6ZWhTlqaCNL0rS7jl7dAV85.jpg"),
    MovieRule(name: "Comedy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg"),
    MovieRule(name: "Crime", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ky8Fua6PD7FyyOA7JACh3GDETli.jpg"),
    MovieRule(name: "Fantasy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/dkokENeY5Ka30BFgWAqk14mbnGs.jpg"),
    MovieRule(name: "Horror", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/bShgiEQoPnWdw4LBrYT5u18JF34.jpg"),
    MovieRule(name: "Science Fiction", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/78wC6ZWhTlqaCNL0rS7jl7dAV85.jpg"),
    MovieRule(name: "Comedy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg"),
    MovieRule(name: "Crime", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ky8Fua6PD7FyyOA7JACh3GDETli.jpg"),
    MovieRule(name: "Fantasy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/dkokENeY5Ka30BFgWAqk14mbnGs.jpg"),
    MovieRule(name: "Horror", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/bShgiEQoPnWdw4LBrYT5u18JF34.jpg"),
    MovieRule(name: "Science Fiction", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/78wC6ZWhTlqaCNL0rS7jl7dAV85.jpg")
]



struct DetectResultCell : View{
    let url : String
    var body: some View{
        VStack(alignment:.center){
            WebImage(url: URL(string: url)!)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fit)
                .frame(height:230)
                .cornerRadius(15)
            
            VStack(alignment:.center){
                Text("The Exorcism of Carmen Farias")
                    .bold()
            }
            .font(.system(size: 15))
            .frame(width:150,height:50,alignment: .center)
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(Color("DetechingColor").cornerRadius(10).padding(5))
    }
}

struct DetectResult : View{
    @State private var offset : CGFloat = 0
    @State private var preOffset : CGFloat = 0
    @GestureState var gestureoffset : CGFloat = 0
    @Binding var show :Bool
    @State private var isDone : Bool = false
//    @Binding var reDetech : Bool
    
    @Binding var isStopDeting : Bool //toggle back
    var detechingData : UIImage
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 10.0), count: 2)
    var body : some View{
        
        ZStack{
            GeometryReader{ imageProxy in
                Image(uiImage: self.detechingData)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageProxy.frame(in: .global).width, height:imageProxy.frame(in: .global).height)
                    
                
            }
            .blur(radius: self.blurLevel())
            .ignoresSafeArea()
            
            GeometryReader{sheetPorxy -> AnyView in
                return AnyView(
                    ZStack{
                        BlurView()
                            .clipShape(CustomeConer(width: 25, height: 25, coners: [.topLeft,.topRight]))
                        
                        VStack{
                            Capsule()
                                .fill(Color.gray)
                                .frame(width: 60, height: 4)
                                .padding(.top)
                            HStack{
                                Button(action:{
                                    //Close the result
                                }){
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.white)
                                }
                                
                                Text("Detecting keyword")
                                    .bold()
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                Image("post4")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill) //??
                                    .edgesIgnoringSafeArea(.all)
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.horizontal)
                            .padding(.vertical,5)
                            
                            ScrollView(.vertical, showsIndicators: false){
                                LazyVGrid(columns: gridItem){
                                    ForEach(testList,id:\.self){ i in
                                        VStack{
                                            DetectResultCell(url: i.postURL)
                                        }
                                    }
                                }
                                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxHeight:.infinity,alignment: .top)
                    }
                    .offset(y: (sheetPorxy.frame(in: .global).height) - 100)
                    .offset(y: -offset > 0 ? -offset <= (sheetPorxy.frame(in: .global).height) - 100 ? offset : -(sheetPorxy.frame(in: .global).height - 100) : 0)
                    .gesture(DragGesture().updating(self.$gestureoffset,body:{
                        value,out,_ in
                        out = value.translation.height
                        print(out)
                        onChage()
                    }).onEnded({value in
                        withAnimation(){
                            //+y is negative
                            //-y is positive
                            //-offset = if current is +y = -(-num)
                            
                            //this case is +y > 100 ? and +y < half screen
                            if -offset > 100 && -offset < (sheetPorxy.frame(in: .global).height / 2)  {
                                    offset = -(sheetPorxy.frame(in: .global).height / 3)
                            }else if -offset > (sheetPorxy.frame(in: .global).height) / 2{
                                // +y > half screen
                                offset = -sheetPorxy.frame(in: .global).height
                            }else {
                                offset = 0
                            }
                            preOffset = offset
                        }
                    }))
                )
                
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        
    }
        
    
    private func onChage(){
        DispatchQueue.main.async{
            self.offset = self.gestureoffset + self.preOffset
        }
    }
    
    private func blurLevel() -> CGFloat {
        return (-offset / UIScreen.main.bounds.height / 2) * 30
    }

}

struct Detecting : View{
    @State private var percentage : Float = 0
    @Binding  var isDone : Bool
    @Binding var isStopDeteching : Bool
    
    @State private var offset : CGFloat = UIScreen.main.bounds.height / 3
    @State private var preOffset : CGFloat = 0
    @GestureState private var gestureoffset : CGFloat = 0

    var detechingData : UIImage
    
    private let gridItem = Array(repeating: GridItem(.flexible(),spacing: 10.0), count: 2)
    private let timer = Timer.publish(every: 0.5, on: .main,in: .common).autoconnect()
    var body: some View {
        ZStack(alignment:.bottom){
            GeometryReader{ imageProxy in
                Image(uiImage: self.detechingData)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageProxy.frame(in: .global).width, height:imageProxy.frame(in: .global).height)
            }
            .blur(radius: self.blurLevel())
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                VStack(spacing:10){
                    Text("Deteching the image.....")
                        .font(.title3)
                        .bold()
                    Text("Please wait until its done!")
                        .font(.body)
                }
                .padding(.vertical,50)
                ZStack{
                    Plusation()
                    BaseProgressCircle()
                    DetectingView(detectImage: detechingData)
                        .frame(width: 225, height: 225)
                        .blur(radius: 2)
                    if isDone{
                        Text("Done")
                            .foregroundColor(.white)
                            .font(.system(size:65))
                            .bold()
                            .transition(.opacity)
                    }else{
                        DetectLabel(percentage: percentage)
                    }
                    DetectProgressBar(percentage: percentage)
                    
                }
                
                Button(action:{
                    withAnimation(){
                        self.isStopDeteching.toggle()
                    }
                }){
                    VStack{
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 60, height: 60)
                    .background(Color("DarkMode"))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 1.0)
                            .foregroundColor(Color.black.opacity(0.35))
                    )
                    
                }
                .padding(.vertical,50)
                
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(BlurView()
                            .edgesIgnoringSafeArea(.all))
            .onReceive(timer){ time in
                if percentage < 0.99{
                    if percentage * 100 > 30 &&  percentage * 100 < 75{
                        self.percentage += 0.08
                    }else{
                        self.percentage += 0.01
                    }
                    
                }else{
                    withAnimation(){
                        self.isDone.toggle()
                    }
                    self.timer.upstream.connect().cancel()
                }
                
            }
            .opacity(self.isDone ? 0 : 1.0)
            
            GeometryReader{sheetPorxy -> AnyView in
                return AnyView(
                    ZStack{
                        BlurView()
                            .clipShape(CustomeConer(width: 25, height: 25, coners: [.topLeft,.topRight]))
                        
                        VStack{
                            Capsule()
                                .fill(Color.gray)
                                .frame(width: 60, height: 4)
                                .padding(.top)
                            HStack{
                                
                                Button(action:{
                                    //Close the result
                                    withAnimation{
                                        self.isStopDeteching.toggle()
                                    }
                                }){
                                    HStack{
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 23, height: 23)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 50)
                                }
                                
                                Text("Detecting keyword")
                                    .bold()
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                Image("post4")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.horizontal)
                            .padding(.vertical,5)
                            
                            ScrollView(.vertical, showsIndicators: false){
                                LazyVGrid(columns: gridItem){
                                    ForEach(testList,id:\.self){ i in
                                        VStack{
                                            DetectResultCell(url: i.postURL)
                                        }
                                    }
                                }
                                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxHeight:.infinity,alignment: .top)
                    }
                    .offset(y: (sheetPorxy.frame(in: .global).height)  / 3)
                    .offset(y: -offset > 0 ? -offset <=  (sheetPorxy.frame(in: .global).height)  / 3 ? offset : -(sheetPorxy.frame(in: .global).height  / 3) : 0)
                    .gesture(DragGesture().updating(self.$gestureoffset,body:{
                        value,out,_ in
                        out = value.translation.height
                        print(out)
                        onChage()
                    }).onEnded({value in
                        withAnimation(){
                            if -offset < (sheetPorxy.frame(in: .global).height) / 2{
                                // +y > half screen
                                offset = -sheetPorxy.frame(in: .global).height
                            }else{
                                offset = 0
                            }
                            preOffset = offset
                        }
                    }))
                    .offset(y : self.isDone ? 0 : UIScreen.main.bounds.height)
                )
                
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .animation(.easeIn(duration: 0.3))
        }
        .animation(.spring())
        .onDisappear(){
            self.timer.upstream.connect().cancel()
            self.isDone = false
        }
    }
    
    
    private func onChage(){
        DispatchQueue.main.async{
            self.offset = self.gestureoffset + self.preOffset
        }
    }
    
    private func blurLevel() -> CGFloat {
        return (-offset / UIScreen.main.bounds.height / 2) * 30
    }
}

struct DetectLabel : View{
    var percentage :Float
    var body: some View{
        let formatter = NumberFormatter()
        let numberObject = NSNumber(value: percentage)
        formatter.numberStyle = .percent
        return ZStack{
            Text("\(numberObject,formatter: formatter)")
                .foregroundColor(.white)
                .font(.system(size:50))
                .bold()
                
        }
    }
}

struct DetectProgressBar : View{
    var percentage : Float
    var body :some View{
        ZStack{
            Circle() //a base circle
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(
                    Circle()
                        .trim(from: 0, to: CGFloat(percentage)) //from 0 to 1 ,0.01 *100 = 1
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .fill(AngularGradient(gradient: .init(colors: [Color("ProgressColor")]), center: .center,startAngle: .zero,endAngle: .init(degrees: 360)))
                ).animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0)).rotationEffect(Angle(degrees: -90))
        }
    }
}

struct Plusation : View{
    @State private var isRunning = false
    var body: some View{
        ZStack{
            Circle()
                .fill(Color("Plusa").opacity(0.5))
                .frame(width: 245, height: 245)
                .scaleEffect(self.isRunning ? 1.3 : 1.1)
                .animation(Animation.easeInOut(duration:1.1).repeatForever())
        }.onAppear{self.isRunning.toggle()}
    }
}

struct BaseProgressCircle : View{
    var body: some View{
        ZStack{
            Circle() //a base circle
                .fill(Color.black)
                .frame(width: 250, height: 250)
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 20))
                        .fill(AngularGradient(gradient: .init(colors: [Color("DetechingColor")]), center: .center))
                )
        }
    }
    
}

struct DetectingView : View {
    var detectImage : UIImage
    var body: some View{
        Image(uiImage: detectImage)
            .resizable()
            .aspectRatio(contentMode: .fill) //??
            .edgesIgnoringSafeArea(.all)
            .background(Color.black)
            .clipShape(Circle())
            .opacity(0.75)
        
    }
}

struct CameraView : View {
    @ObservedObject private var cameraModel = CameraViewModel()
    @Binding var closeCamera : Bool
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedPhoto:UIImage? // it may remove and instead with custom view
    @State private var isImagePickerDisplay : Bool = false
    @State private var deteching = false
    @State private var isDone:Bool = false
    

    
    @State private var reTake:Bool = false
    var body: some View {
        ZStack(alignment:.bottom){
            ZStack(alignment:.bottom){
                DetechCameraView(camera: cameraModel)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Button(action:{
                            //back to previous page
                            withAnimation(){
                                self.closeCamera.toggle()
                            }
                        }){
                            VStack{
                                Image(systemName: "arrow.backward")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                            }
                            .frame(width: 50)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        HStack{
                            Button(action:{
                                withAnimation(){
                                    self.cameraModel.flashMode.toggle()
                                }
                            }){
                                VStack{
                                    Image(systemName: self.cameraModel.flashMode ? "bolt.slash.circle" : "bolt.circle")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25)
                                }
                                .frame(width: 50)
                            }
                            
                            Button(action:{
                                self.cameraModel.chagneCapture()
                            }){
                                VStack{
                                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25)
                                }
                                .frame(width: 50)
                            }

                        }
                        .padding(.horizontal,5)
                        
                    }
                    .padding(.top,5)
                    
                    Spacer()
                    
                    HStack{
                        Button(action:{
                            withAnimation(){
                                self.isImagePickerDisplay.toggle()
                            }
                            //                        self.cameraModel.chagneCapture()
                        }){
                            VStack{
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                            }
                            .frame(width: 50)
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        Button(action: {
                            self.cameraModel.takenPicture()
                        }){
                            ZStack{
                                Circle()
                                    .foregroundColor(.white)
                                    .opacity(0.2)
                                    .frame(width: 70, height: 70)
                                
                                Circle()
                                    .foregroundColor(.orange)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "camera")
                                    .foregroundColor(.white)
                            }
                        }
                        
                    }
                    .padding(.trailing,UIScreen.main.bounds.width / 2.5)
                    .padding(.horizontal,5)
                }
                
                //just test here
                if !self.cameraModel.photoData.isEmpty && self.cameraModel.phototTaken{
                    //                NavigationLink(destination: Deteching(isStopDeteching: self.$cameraModel.phototTaken, detechingData: UIImage(data: self.cameraModel.photoData)!), isActive: self.$cameraModel.phototTaken){
                    //                    EmptyView()
                    //                }
                    Detecting(isDone: self.$isDone, isStopDeteching: self.$cameraModel.phototTaken, detechingData: UIImage(data: self.cameraModel.photoData)!)
                        .onAppear(){
                            self.cameraModel.captureSession.stopRunning()
                        }
                        .onDisappear(){
                            self.cameraModel.captureSession.startRunning()
                        }
                        .transition(.identity)
                } else if self.selectedPhoto != nil &&  self.deteching {
                    //                NavigationLink(destination:  Deteching(isStopDeteching: self.$deteching, detechingData: self.selectedPhoto!), isActive: self.$deteching){
                    //                    EmptyView()
                    //                }
                    Detecting(isDone: self.$isDone, isStopDeteching: self.$deteching, detechingData: self.selectedPhoto!)
                        .onAppear(){
                            self.cameraModel.captureSession.stopRunning()
                        }
                        .onDisappear(){
                            self.cameraModel.captureSession.startRunning()
                        }
                        .transition(.identity)
                }
            
            }
        }
        .fullScreenCover(isPresented: self.$isImagePickerDisplay){
            //show the phone or phone lib as sheet
            CameraImagePickerView(selectedImage: self.$selectedPhoto, sourceType: self.sourceType,selected:self.$deteching)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear{
            //check the permission
            self.cameraModel.cameraPremissionCheck()
           
        }
    }
}


//this cameara can not zoom yet
class CameraViewModel : NSObject, ObservableObject,AVCapturePhotoCaptureDelegate {
    @Published var phototTaken : Bool = false
    @Published var captureSession =  AVCaptureSession() //a data flow channel for capture input and output
    @Published var alert : Bool = false
    @Published var output = AVCapturePhotoOutput() //read from photo lib©
    @Published var cameraPreview : AVCaptureVideoPreviewLayer!
    @Published var photoData : Data = Data(count: 0)
    @Published var flashMode : Bool = false
    private var camera : AVCaptureDevice?
    
    func cameraPremissionCheck(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //if auth then set up the session
            captureSetUp()
            return
        case .notDetermined:
            //request the pression
            AVCaptureDevice.requestAccess(for: .video){ status in
                print(status)
                if status { //if not deniend and setup
                    self.captureSetUp()
                }
            }
        case .denied:
            //pression denied
            self.alert.toggle()
            return
        default:
            //todo
            return
        }
    }
    
    func captureSetUp(){
        do {
            //set up our sessopm
            //start Configuration
            print("setting up")
            self.captureSession.beginConfiguration()
            
//            let devices = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) //for our back camera only

            //check decvies is suppost this type of capture
            guard let suppostedDevice =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                return
            }
            
            
            self.camera = suppostedDevice
            let input = try AVCaptureDeviceInput(device: suppostedDevice)
            
            //check input
            if self.captureSession.canAddInput(input){
                self.captureSession.addInput(input) //for camera
            }
            
            if self.captureSession.canAddOutput(output){
                self.captureSession.addOutput(output) //for photolib
            }
            
            //finished Configuration
            self.captureSession.commitConfiguration()
        } catch {
            //if setup occur some error ,print it out
            print(error.localizedDescription)
        }
    }
    
    func chagneCapture(){
        //get the firstInput
        guard let currentCameraInut = self.captureSession.inputs.first else {
            return
        }
        self.captureSession.beginConfiguration()
        
        //remove first input
        self.captureSession.removeInput(currentCameraInut)
        
        //get the new camera input
        var newCam : AVCaptureDevice! = nil
        if let input = currentCameraInut as? AVCaptureDeviceInput{
            if input.device.position == .back{
                newCam = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            } else{
                newCam = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            }
        }
        
        //get the new input to device
        self.camera = newCam
        var newVideoInput : AVCaptureDeviceInput!
        var err : Error?
        do{
            newVideoInput = try AVCaptureDeviceInput(device: newCam)
        }catch let inputErr as NSError{
            err = inputErr
            newVideoInput = nil
        }
        
        if newVideoInput == nil || err != nil{
            print("camera setting error : \(String(describing: err?.localizedDescription))")
        }else{
            //if no any error there
            self.captureSession.addInput(newVideoInput)
        }
        
        self.captureSession.commitConfiguration()
        
    }
    
    func getSetting(camera:AVCaptureDevice,flashMode :AVCaptureDevice.FlashMode) -> AVCapturePhotoSettings{
        let setting = AVCapturePhotoSettings()
        if camera.hasTorch{
            setting.flashMode = flashMode
        }
        return setting
    }
    
    func takenPicture(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: self.getSetting(camera: self.camera!, flashMode: self.flashMode ? .on : .off), delegate: self)

        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("abc")
        if error != nil{
            return
        }
        guard let imgData = photo.fileDataRepresentation() else {
            return
        }
        
        self.photoData = imgData
   //     UIImageWriteToSavedPhotosAlbum(UIImage(data: self.photoData)!,nil,nil,nil)
        
        self.captureSession.stopRunning()
        DispatchQueue.main.async {
            withAnimation(){
                self.phototTaken.toggle()
            }
        }

    }
    
}

struct DetechCameraView : UIViewRepresentable{
    @ObservedObject var camera : CameraViewModel
    func makeUIView(context: Context) ->  UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.cameraPreview = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        camera.cameraPreview.frame = view.frame
        
        camera.cameraPreview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(camera.cameraPreview)
        
        camera.captureSession.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //TO Update
        //reset the camera state
        //        uiView.layer.addSublayer(camera.cameraPreview)
        //        camera.captureSession.startRunning()
        //        print("tesing")
    }
}
////
//struct Post : Identifiable{
//    var id = UUID().uuidString
//    var image : String
//}
//
//struct homeTemp:View{
//    @State private var currentIndex = 0
//    @State private var posts : [Post] = []
//    var body : some View{
//        VStack{
//            Text("HomeCard temp")
//                .foregroundColor(.red)
//            Silder(index: self.$currentIndex, items: posts){
//                post in
//                GeometryReader{ proxy in
//                    Image(post.image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width:proxy.size.width)
//                        .cornerRadius(12)
//                }
//            }
//            .padding(.vertical,120)
//
////            HStack(spacing:10){
////                //some issue need to fix????????
////                ForEach(posts.indices,id:\.self){ indx in
////                    if indx < currentIndex - 3{
////                        EmptyView()
////                    }
////                    else if indx  > currentIndex + 3{
////                        EmptyView()
////                    }
////                    else{
////                        Circle()
////                            .fill(Color.white.opacity(currentIndex == indx ? 1.0 : 0.1))
////                            .frame(width:10,height:10)
////                            .scaleEffect(currentIndex == indx ? 1.4 : 1.0)
////                            .animation(.spring(),value:currentIndex == indx)
////                    }
////                }
////            }
//        }
//        .frame(maxWidth:.infinity,alignment: .top)
//        .onAppear{
//            for i in 0...9{
//                posts.append(Post(image: "post\(i)"))
//                posts.append(Post(image: "post\(9-i)"))
//            }
//        }
//    }
//
//}
//
//struct Silder<Content:View, T:Identifiable> : View{
//    var content : (T) -> Content
//    var list :[T]
//
//    var spacing :CGFloat
//    var trailingSpace : CGFloat
//    @Binding var index : Int
//
//    init(spacing:CGFloat = 15.0,trailingSpace:CGFloat = 100,index : Binding<Int>,items:[T],@ViewBuilder content : @escaping (T)->Content){
//        self.list = items
//        self.spacing = spacing
//        self.trailingSpace = trailingSpace
//        self._index = index
//        self.content = content
//    }
//
//    @GestureState private var offestCard : CGFloat = 0.0
//    @State private var currentIndex : Int = 0
//
//    var body : some View{
//        GeometryReader{proxy in
//            let currentWidth = proxy.size.width - (self.trailingSpace - self.spacing)
//            let adjWidth = (self.trailingSpace / 2) - spacing //only affect none 0th
//            HStack(spacing:self.spacing){
//                ForEach(list){post in
//                    content(post)
//                        .frame(width:proxy.size.width - trailingSpace)
//                        .offset(y:getOffset(item : post,width : currentWidth))
//                }
//
//            }
//            //padding horizontal
//            .padding(.horizontal,spacing)
//            .offset(x: (CGFloat(currentIndex) * -currentWidth) + (self.currentIndex != 0 ? adjWidth : 0) + offestCard) //offset the card + index *total width for each card
//            .scaleEffect()
//            .gesture(
//                DragGesture()
//                    .updating($offestCard, body: {(value,out,_) in
//                        out = value.translation.width
//
//                    })
//                    .onEnded({value in
//                        //calculating the offset
//                        let offsetX = value.translation.width
//                    //    print(offsetX)
//                        //value of offset of the total width and round 0 to 1
//                        let totalOffset = -offsetX / currentWidth
//
//                        //get the index
//                        let roundInt = totalOffset.rounded()
//                    //    print(roundInt)
//                        //add to currentIndx
//                        //lmit the bounds of index 0- list-1
//                        currentIndex = max(min(Int(currentIndex) + Int(roundInt),list.count - 1),0)
//
//                        currentIndex = index
//                    })
//                    .onChanged{value in
//                        //calculating the offset
//                        let offsetX = value.translation.width
//                    //    print(offsetX)
//                        //value of offset of the total width and round 0 to 1
//                        let totalOffset = -offsetX / currentWidth
//
//                        //get the index
//                        let roundInt = totalOffset.rounded()
//                    //    print(roundInt)
//                        //add to currentIndx
//                        //lmit the bounds of index 0- list-1
//                        index = max(min(Int(currentIndex) + Int(roundInt),list.count - 1),0)
//
//                    }
//            )
//
//        }
//        .animation(.easeInOut,value: offestCard == 0)
//    }
//
//    private func getOffset(item : T,width:CGFloat) -> CGFloat{
//        //current Index item offset up tp 60
//        // current Index value times 60
//        let currentProgress = ((self.offestCard < 0 ? offestCard : -offestCard) / width) * 60
//
//        //let currentProgress to positive
//
//        //if top offset is less than  60 -> currentProgress else -currentProgress
//        let topOffset = -currentProgress < 60 ? currentProgress : -(currentProgress + 120)
//
//        let previous = getIndex(item: item) - 1 == currentIndex ? (self.offestCard < 0 ? topOffset : -topOffset)  : 0
//        let next = getIndex(item: item) + 1 == currentIndex ? (self.offestCard < 0 ? -topOffset : topOffset) : 0
//
//        //if current index between 0 and count-1
//        let check = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next): 0
////        print("pre :\(previous)")
////        print("next :\(next)")
////        print("check :\(check)")
//        return getIndex(item: item) == currentIndex ? -60 - topOffset : check
//    }
//
//    private func getIndex(item : T) -> Int{
//        let index = list.firstIndex{ currenItem in
//            return currenItem.id == item.id
//        } ?? 0
//        return index
//    }
//}


////
////  AutoScroll.swift
////  IOS_DEV
////
////  Created by 張馨予 on 2021/5/18.
////
//
//import SwiftUI
//import UIKit
//import MobileCoreServices
//import SDWebImageSwiftUI
//import CoreHaptics
//
//struct AutoScroll_V: View {
//    @AppStorage("seachHistory") private var history : [String] =  []
//    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var selectedPhoto:UIImage?
//    @State private var isImagePickerDisplay : Bool = false
//    @State private var isShowActionSheet :Bool = false
//    @State private var isSeaching : Bool = false
//    @State private var searchingText :String = ""
//    @State private var isRemove : Bool = false
//    @State private var focused: [Bool] = [false, true]
//    @State private var isEditing:Bool = false
//  //  @State private var isPriview = false
//
//
//    init(){
//        UIScrollView.appearance().keyboardDismissMode = .onDrag
////        UIImageView.appearance().isOpaque = false
//    }
//    var body: some View {
//        return
//            ZStack(alignment:.bottom){
//                VStack{
//                    SearchingBar(isSeaching: self.$isSeaching,searchingText: self.$searchingText, isEditing: self.$isEditing,isShowActionSheet: self.$isShowActionSheet,focus:self.$focused)
//
//
//                    if self.isSeaching && !self.isEditing{
//                        searchingField(history: self.history,searchText: self.$searchingText,isSearching: self.$isSeaching, isRemove: self.$isRemove,focus:self.$focused)
//                            .transition(.identity)
//
//                    } else if(self.isEditing){
//                        searchingResultList(seachingText: self.searchingText)
//                    }else{
//                        SeachDragingView()
//                    }
//
//
//                }
//                .edgesIgnoringSafeArea(.all)
//                .fullScreenCover(isPresented: self.$isImagePickerDisplay){
//                    //show the phone or phone lib as sheet
//                    CameraImagePickerView(selectedImage: self.$selectedPhoto, sourceType: self.sourceType)
//                        .edgesIgnoringSafeArea(.all)
//                }
//                .actionSheet(isPresented: self.$isShowActionSheet){
//                    ActionSheet(title: Text("Upload the cover"), message: Text("Upload with your photo library or take the photo"), buttons: [
//                        .default(Text("Camera")){
//                            self.sourceType = .camera
//                            self.isImagePickerDisplay.toggle()
//                        },
//                        .default(Text("PhotoLibary")){
//                            self.sourceType = .photoLibrary
//                            self.isImagePickerDisplay.toggle()
//                        },
//                        .cancel()
//                    ])
//                }
//                .alert(isPresented: self.$isRemove){
//                    withAnimation(){
//                        Alert(title: Text("Delete All Searching History"), message: Text("Are you sure?"),
//                              primaryButton: .default(Text("Cancel")){
//                                self.focused = [false,true]
//                              },
//                              secondaryButton: .default(Text("Delete")){
//                                withAnimation{
//                                    UserDefaults.standard.set([],forKey: "seachHistory")
//                                    self.focused = [false,true]
//                                }
//                              })
//                    }
//
//                }
//
//
//            }
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct searchingResultList :View{
//
//    var seachingText:String
//    private let items : [SeachItem] = movieDB
//    var body: some View{
//        List(self.items.filter{$0.itemName.lowercased().contains(self.seachingText.lowercased())},id:\.self.id){ name in
//            Button(action: {
//                print(name.itemName)
//            }){
//                HStack{
//                    Image(systemName: "film")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(name.itemName)
//                        .bold()
//    //
//                    Spacer()
//
//                    Image(systemName: "arrowshape.turn.up.forward")
//                }
//            }
//        }
//
//    }
//}
//
//struct searchingField : View{
//    var history : [String]
//    @Binding var searchText : String
//    @Binding var isSearching : Bool
//    @Binding var isRemove : Bool
//    @Binding var focus : [Bool]
//    var body :some View{
//        return ScrollView(.vertical, showsIndicators: false){
//            //before user typing seaching thing
//            //show user seaching history and recommand keyword
//            HStack{
//                Text("Recent:")
//                    .fontWeight(.bold)
//                    .font(.body)
//                Spacer()
//
//                Button(action:{
//                    //to remove all
////                    UserDefaults.standard.set([],forKey: "seachHistory")
//                    withAnimation(){
//                        self.isRemove.toggle()
//                        self.focus = [false,false]
//                    }
//                }){
//                    Image(systemName: "trash")
//                        .foregroundColor(.white)
//                }
//
//            }
//
//            if !history.isEmpty{
//                HStackLayout(list: self.history, searchText: self.$searchText, isSearching: $isSearching)
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal)
//        .frame(width:UIScreen.main.bounds.width)
//    }
//}
//
//struct HStackLayout: View {
//    var list : [String]
//    @Binding var searchText : String
//    @Binding var isSearching : Bool
//    var body: some View {
//        VStack{
//            GeometryReader { geometry in
//                self.generateContent(in: geometry)
//            }
//        }
//    }
//
//    private func generateContent(in g: GeometryProxy) -> some View {
//        var width = CGFloat.zero
//        var height = CGFloat.zero
//
//        return ZStack(alignment: .topLeading) {
//            ForEach(self.list, id: \.self) { item in
//                searchFieldButton(searchingText: item){
//                    withAnimation{
//                        self.isSearching = false
//                        self.searchText = item
//
//                    }
//                }
//                .padding([.horizontal, .vertical], 4)
//                .alignmentGuide(.leading, computeValue: { d in
//                    if (abs(width - d.width) > g.size.width)
//                    {
//                        width = 0
//                        height -= d.height
//                    }
//                    let result = width
//                    if item == self.list.last! {
//                        width = 0 //last item
//                    } else {
//                        width -= d.width
//                    }
//                    return result
//                })
//                .alignmentGuide(.top, computeValue: {d in
//                    let result = height
//                    if item == self.list.last! {
//                        height = 0 // last item
//                    }
//                    return result
//                })
//            }
//        }
//    }
//
//}
//
//struct searchFieldButton : View {
//
//    var searchingText:String
//    var action : ()->()
//    var body: some View{
//        return VStack{
//            Button(action:action){
//                Text(searchingText)
//                    .font(.system(size: 15))
//                    .foregroundColor(Color.black)
//            }
//            .frame(width:getStrWidth(searchingText),height:30)
//            .padding(.horizontal,5)
//            .background(Color.white)
//            .cornerRadius(8)
//            .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 0)
//        }
//    }
//
//    func getStrWidth(_ str:String)->CGFloat{
//        //get current string size
//        return str.widthOfStr(Font: .systemFont(ofSize: 15,weight: .bold))
//    }
//}
//
//struct SearchingMode: View {
//    @Binding var searchingText : String
//    @Binding var isEditing : Bool
//    @Binding var isSeaching:Bool
//    @Binding var focused: [Bool]
//    @State private var isDelete:Bool = false
//    var body: some View {
//        HStack{
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.black)
//                .padding(.horizontal,8)
//
//            //IssuePoint:Keyboard Hiddend Issue
//            //Need to be fixed the KeyBoard
//            //KeyBoard hidden only when the seaching button is clicked
//            //Finding the solution...........
//            //tag use for forcus
//            UITextFieldView(keybooardType: .default, returnKeytype: .search, tag: 1, placeholder:"Movie Name,Actor...", text: self.$searchingText,isFocus: self.$focused,isEditing: self.$isEditing)
//                .frame(height:22)
//                .onChange(of: self.searchingText, perform: { value in
//                    self.isEditing = value == "" ? false : true
//                })
//
//            if self.isEditing {
//                Button(action:{
//                    withAnimation{
//                        self.searchingText = ""
//                    }
//                }){
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//                .transition(.move(edge: .trailing))
//            }
//
//
//            Button(action: {
//                withAnimation(.easeInOut){
//                    self.searchingText = ""
//                    self.isEditing = false
//                    self.focused = [false,false]
//                    self.isSeaching.toggle()
//                }
//
//            }) {
//                Text("Cancel")
//            }
//            .padding(.trailing, 2)
//            .transition(.move(edge: .trailing))
//            .animation(.default)
//        }
//        .padding(self.isSeaching ? 10 : 0)
//        .background(Color("DarkMode"))
//        .cornerRadius(20)
//
//    }
//}
//
//struct SeachingButton: View {
//    @Binding var isSeaching:Bool
//    @Binding var isShowImageActionSheet : Bool
//    @Binding var focus : [Bool]
//    var body: some View {
//        HStack(spacing:0){
//            Button(action:{
//                //TO EXPAND THE SEACHING BAR
//                withAnimation(){
//                    self.isSeaching.toggle()
//                    self.focus = [false,true]
//                    print(focus)
//                }
//            }){
//                Image(systemName: "magnifyingglass")
//                    .padding(10)
//                    .foregroundColor(.black)
//            }
//            .background(Color.white.clipShape(CustomeConer(coners: [.topLeft,.bottomLeft])))
//
//            Button(action:{
//                withAnimation{
//                    self.isShowImageActionSheet.toggle()
//                }
//            }){
//                Image(systemName: "camera")
//                    .padding(10)
//                    .foregroundColor(.white)
//            }
//            .background(Color("DropBoxColor").clipShape(CustomeConer(coners: [.topRight,.bottomRight])))
//        }
//    }
//}
//
//struct SearchingBar: View {
//    @Binding var isSeaching :Bool
//    @Binding var searchingText :String
//    @Binding  var isEditing : Bool
//    @Binding var isShowActionSheet :Bool
//    @Binding var focus:[Bool]
//    var body: some View {
//        HStack(spacing:0){
//            if !self.isSeaching {
//                Text("Seach Playground")
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(.white)
//
//                Spacer()
//            }
//
//            HStack{
//                if self.isSeaching {
//                    SearchingMode(searchingText: self.$searchingText, isEditing: self.$isEditing,isSeaching: self.$isSeaching, focused: self.$focus)
//
//                }
//                else {
//                    SeachingButton(isSeaching: self.$isSeaching,isShowImageActionSheet: self.$isShowActionSheet, focus: self.$focus)
//
//                }
//            }
//            .padding(self.isSeaching ? 8 : 0)
//            .cornerRadius(25)
//        }
//        .padding(.top, 50 )
//        .padding(.horizontal)
//        .padding(.bottom,10)
//
//    }
//}
//
//struct SeachItem : Identifiable,Hashable{
//    let id :String = UUID().uuidString
//    let itemName : String
//}
//
//let movieDB : [SeachItem] = [
//    SeachItem(itemName: "Sholay (1975)"),
//    SeachItem(itemName: "Mughal-e-Azam (1960)"),
//    SeachItem(itemName: "Mother India (1957)"),
//    SeachItem(itemName: "Dilwale Dulhania Le Jayenee (1995)"),
//    SeachItem(itemName: "Guide (1965)"),
//    SeachItem(itemName: "Deewaar (1975)"),
//    SeachItem(itemName: "Pakeezah (1972)"),
//    SeachItem(itemName: "Shree 420 (1955)"),
//    SeachItem(itemName: "Barfi! (2012)"),
//    SeachItem(itemName: "Umrao Jaan (1981)"),
//    SeachItem(itemName: "Bobby (1973)"),
//    SeachItem(itemName: "Mr India (1987)"),
//    SeachItem(itemName: "Jab We Met (2007)"),
//    SeachItem(itemName: "Ankur (1974)"),
//    SeachItem(itemName: "GolMaal (1979)"),
//    SeachItem(itemName: "Chak De! India (2007)"),
//    SeachItem(itemName: "Ek Tha Tiger (2012)"),
//    SeachItem(itemName: "Swades (2004)"),
//    SeachItem(itemName: "Hera Pheri (2000)"),
//    SeachItem(itemName: "Mujhse Dosti Karoge! (2002)"),
//    SeachItem(itemName: "Veer-Zaara (2004)"),
//    SeachItem(itemName: "Iron man"),
//    SeachItem(itemName: "Iron man 2"),
//    SeachItem(itemName: "Iron man 3")
//]
//
//
//struct AutoScroll_V_Previews: PreviewProvider
//{
//    static var previews: some View{
//
////        previewSeaching()
//           // .preferredColorScheme(.dark)
//        BottonSheet()
//         //   .preferredColorScheme(.dark)
//    }
//}
//
//
//struct SeachDragingView : View{
//    @StateObject var cardProvider  = CardProvider()
//    @EnvironmentObject var previewModle : PreviewModle //Using previeModle
//    var body : some View{
//        return
//            VStack(spacing:0){
//                //   ScrollableCardList(title:"Genre:",list: self.cardProvider.genreList)
//                CustomePicker(selectedTabs: $cardProvider.selectedTab)
//
//                switch(cardProvider.selectedTab){
//                case "Genre":
//                    ScrollableCardGrid(list: self.cardProvider.genreList)
//                case "Actor":
//                    ScrollableCardGrid(list: self.cardProvider.actorList)
//                case "Director":
//                    ScrollableCardGrid(list: self.cardProvider.directorList)
//
//                default :
//                    EmptyView()
//                }
//
//                Spacer()
//                //Drop area
//                //Make a drop area as a box for dropping any cardItem user is wanted
//                VStack(alignment:.trailing){
//                    if !cardProvider.selecedData.isEmpty{
//                        HStack{
//                            Button(action:{
//                                withAnimation(){
//                                    self.cardProvider.selecedData.removeAll()
//                                 //   self.previewModle.isShowPreview.toggle() //using envronment object
//                                    //                                self.isPreView.toggle()
//                                }
//                            }){
//                                HStack{
//                                    Text("Trash All")
//                                        .foregroundColor(.red)
//                                        .font(.body)
//
//                                    Image(systemName: "trash.circle")
//                                        .foregroundColor(.white)
//
//
//
//                                }
//                            }
//
//                            Spacer()
//
//                            Button(action:{
//                                withAnimation(){
//                                    self.previewModle.isShowPreview.toggle() //using envronment object
//                                    //                                self.isPreView.toggle()
//                                }
//                            }){
//                                HStack{
//                                    Image(systemName: "arrow.up.circle")
//                                        .foregroundColor(.white)
//
//                                    Text("Preview")
//
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//
//                    }
//
//                    ZStack{
//                        //If not card is dropped
//                        if cardProvider.selecedData.isEmpty{
//                            Text("Drop image here")
//                                .fontWeight(.bold)
//                                .foregroundColor(.black)
//                                .transition(.identity)
//                        }
//
//                        ScrollView(.horizontal, showsIndicators: false){
//                            HStack{
//                                ForEach(cardProvider.selecedData,id:\.id){card in
////                                    ZStack(alignment: .topTrailing){
//                                    VStack(spacing:3){
//                                        WebImage(url: URL(string: card.postURL))
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fill)
//                                            .frame(width:60,height:85)
//                                            .cornerRadius(10)
//                                            .clipped()
//                                            .onTapGesture(count: 2){
//                                                withAnimation(.default){
//                                                    self.cardProvider.selecedData.removeAll{ (checking) in
//                                                        return checking.id == card.id
//                                                    }}
//                                            }
//                                            .padding(.top,3)
//
//                                        Text(card.name)
//                                            .font(.caption)
//                                            .frame(width:55,height:8)
//                                            .lineLimit(1)
//                                    }
//
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                    .frame(height: self.cardProvider.selecedData.isEmpty ? 50 : 100)
//                    .padding(.bottom,10)
//                    .padding(.top,10)
//                    .background(self.cardProvider.selecedData.isEmpty ? Color("OrangeColor") : Color("DropBoxColor"))
//                    .cornerRadius(25)
//                    .edgesIgnoringSafeArea(.all)
//                    .shadow(color: Color.black.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 1.0, y: 1.0 )
//                    .padding(.horizontal)
//                    .onDrop(of: [String(kUTTypeURL)], delegate: cardProvider)
//
//                    if !cardProvider.selecedData.isEmpty{
//                        Text("Double tab to remove!")
//                            .font(.caption)
//                            .foregroundColor(.red)
//                            .bold()
//                            .padding(.horizontal)
//                    }
//                }
//                .padding(.vertical)
//                .background(BlurView())
//                .cornerRadius(25)
//                .padding(.horizontal)
//
//            }
//            .edgesIgnoringSafeArea(.all)
//
//
//
//
//    }
//}
//
//struct BottonSheet : View{
//    @EnvironmentObject var previewModle : PreviewModle
////    @Binding var isPreview : Bool
//    @State private var cardOffset:CGFloat = 0
//    var body : some View{
//        VStack{
//            Spacer()
//            VStack(spacing:12){
//
//                Capsule()
//                    .fill(Color.gray)
//                    .frame(width: 60, height: 4)
//
//                Text("PREVIEW RESULT")
//                    .bold()
//                    .foregroundColor(.gray)
//                VStack{
//                    HStack(){
//                        //Movie Image Cover Here
//                        HStack(alignment:.top){
//                            WebImage(url: URL(string: "https://www.themoviedb.org/t/p/original/4q2hz2m8hubgvijz8Ez0T2Os2Yv.jpg"))
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 135)
//                                .cornerRadius(10)
//                                .clipped()
//                            //Movie Deatil
//
//                            //OR MORE...
//                            //Name,Genre,Actor,ReleaseDate,Time, Langauge etc
//                            VStack(alignment:.leading,spacing:10){
//                                Text("Name:A Quiet Place Part II")
//                                    .bold()
//                                    .font(.headline)
//                                    .lineLimit(1)
//                                Text("Genre:Science Fiction, Thriller")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                    .lineLimit(1)
//                                Text("Actor:Evelyn Abbott,Cillian Murphy")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                    .lineLimit(1)
//                                Text("Release:05/28/2021")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                    .lineLimit(1)
//                                Text("Time:1h37m")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                    .lineLimit(1)
//                            }
//                            .padding(.top)
//
//
//                        }
//                        .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 4)
//                    }
//                    VStack(alignment:.leading){
//                        Text("Overview:")
//                            .bold()
//                            .font(.subheadline)
//                            .lineLimit(1)
//
//                        Text("Following the events at home, the Abbott family now face the terrors of the outside world. Forced to venture into the unknown, they realize that the creatures that hunt by sound are not the only threats that lurk beyond the sand path.")
//                            .font(.footnote)
//                            .lineLimit(3)
//
//                    }
//                    .padding(.horizontal)
//                    HStack(spacing:45){
//
//                        SmallRectButton(title: "Detail", icon: "ellipsis.circle"){
//                            withAnimation(){
//                                self.previewModle.isShowPreview.toggle()
//                            }
//                        }
//
//                        SmallRectButton(title: "More", icon: "magnifyingglass", textColor: .white, buttonColor: Color("BluttonBulue2")){
//                            withAnimation(){
//                                self.previewModle.isShowPreview.toggle()
//                            }
//                        }
//
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.horizontal,5)
//                .padding(.top,10)
//                .padding(.bottom)
//                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//                //The preview result here
//            }
//            .padding(.top)
//            .background(BlurView().clipShape(CustomeConer(coners: [.topLeft,.topRight])))
//            .offset(y:cardOffset)
//            .gesture(
//                DragGesture()
//                    .onChanged(self.onChage(value:))
//                    .onEnded(self.onEnded(value:))
//            )
//            .offset(y:self.previewModle.isShowPreview ? 0 : UIScreen.main.bounds.height)
//        }
//        .ignoresSafeArea()
//        .background(Color
//                        .black
//                        .opacity(self.previewModle.isShowPreview ? 0.3 : 0)
//                        .onTapGesture {
//                            withAnimation(){
//                                self.previewModle.isShowPreview.toggle()
//                            }
//                        }
//                        .ignoresSafeArea().clipShape(CustomeConer(coners: [.topLeft,.topRight])))
//
//    }
//
//    private func onChage(value : DragGesture.Value){
//        print(value.translation.height)
//        if value.translation.height > 0 {
//            self.cardOffset = value.translation.height
//        }
//    }
//
//    private func onEnded(value : DragGesture.Value){
//        if value.translation.height > 0 {
//            withAnimation(){
//                let cardHeight = UIScreen.main.bounds.height / 4
//
//                if value.translation.height > cardHeight / 2.8 {
//                    self.previewModle.isShowPreview.toggle()
//                }
//                self.cardOffset = 0
//            }
//        }
//    }
//
//}
//
//struct CustomeConer : Shape {
//
//    var coners : UIRectCorner
//
//    func path(in rect: CGRect) -> Path {
//        //set coner and coner radius
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: coners, cornerRadii: CGSize(width: 40, height: 40))
//        return Path(path.cgPath)
//    }
//}
////
////struct ScrollableCardList : View{
////    var title : String
////    var list : [MovieRule]
////    var body: some View {
////        VStack(alignment:.leading){
////            Text(title)
////                .bold()
////                .font(.title3)
////                .padding(.horizontal,3)
////            ScrollView(.horizontal, showsIndicators: false){
////                HStack{
////                    ForEach(self.list.shuffled()){ data in
////                        if data.postURL != ""{
////                            //redner the cell
////                            //Some Drag issue here
////                            VStack{
////                                Image(data.postURL)
////                                    .resizable()
////                                    .frame(width:80,height:80)
////                                    .cornerRadius(5)
////                                    .onDrag{ return NSItemProvider(contentsOf: URL(string: data.id))! }
////
////                                Text(data.name)
////                                    .frame(width:80,height:40)
////                                    .lineLimit(2)
////
////
////                            }
////
////
////                        }
////                    }
////
////                }
////                .padding(5)
////            }
////
////
////        }
////    }
////}
//
//struct CustomePicker : View {
//    @Binding var selectedTabs:String
//    @Namespace var animateTab
//    var body: some View {
//        VStack{
//            HStack{
//                Image(systemName: "globe")
//                    .font(.system(size: 22,weight:.bold))
//                    .foregroundColor(self.selectedTabs == "Genre" ? .black : .white)
//                    .frame(width: 70, height: 35)
//                    .background(
//                        ZStack{
//                            if self.selectedTabs != "Genre" {
//                                Color.clear
//                            }else{
//                                Color.white.matchedGeometryEffect(id: "Tab", in: animateTab)
//                            }
//
//                        }
//                    )
//                    .cornerRadius(10)
//                    .onTapGesture {
//                        withAnimation{
//                            self.selectedTabs = "Genre"
//                        }
//                    }
//
//                Image(systemName: "signature")
//                    .font(.system(size: 22,weight:.bold))
//                    .foregroundColor(self.selectedTabs == "Actor" ? .black : .white)
//                    .frame(width: 70, height: 35)
//                    .background(
//                        ZStack{
//                            if self.selectedTabs != "Actor" {
//                                Color.clear
//                            }else{
//                                Color.white.matchedGeometryEffect(id: "Tab", in: animateTab)
//                            }
//
//                        }
//                    )
//                    .cornerRadius(10)
//                    .onTapGesture {
//                        withAnimation{
//                            self.selectedTabs = "Actor"
//                        }
//                    }
//
//                Image(systemName: "squareshape.controlhandles.on.squareshape.controlhandles")
//                    .font(.system(size: 22,weight:.bold))
//                    .foregroundColor(self.selectedTabs == "Director" ? .black : .white)
//                    .frame(width: 70, height: 35)
//                    .background(
//                        ZStack{
//                            if self.selectedTabs != "Director" {
//                                Color.clear
//                            }else{
//                                Color.white.matchedGeometryEffect(id: "Tab", in: animateTab)
//                            }
//
//                        }
//                    )
//                    .cornerRadius(10)
//                    .onTapGesture {
//                        withAnimation{
//                            self.selectedTabs = "Director"
//                        }
//                    }
//            }
//            .background(Color.white.opacity(0.15))
//            .cornerRadius(15)
//
//            Text(self.selectedTabs)
//                .bold()
//                .font(.title3)
//                .padding(.vertical,5)
//           // Spacer()
//        }
//        .edgesIgnoringSafeArea(.all)
//        .padding(.top,10)
//
//    }
//
//}
//
//struct ScrollableCardGrid : View{
//    @State private var coreHaptics : CHHapticEngine?
//    let comlums = Array(repeating: GridItem(.flexible(),spacing: 10), count: 2)
//    var list : [MovieRule]
//    var body : some View{
//        ScrollView(.vertical, showsIndicators: false){
//            LazyVGrid(columns: comlums){
//                ForEach(self.list){ data in
//                    if data.postURL != ""{
//                        //redner the cell
//                        //Some Drag issue here
//                        VStack(spacing:3){
//                            WebImage(url: URL(string: data.postURL))
//                                .resizable()
//                                .indicator(.activity)
//                                .transition(.fade(duration: 0.5))
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height:200)
//                                .cornerRadius(25)
//                                .onDrag{
//                                    EngineSuccess()
//                                    return NSItemProvider(contentsOf: URL(string: data.id))! }
//                            //
//                            Text(data.name)
//                                .frame(width:120,height:50,alignment:.center)
//                                .lineLimit(2)
//                        }
//                        .padding(.top)
//
//
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .onAppear(perform: initEngine)
//    }
//
////    func simpleSuccess(){
////        let generator = UINotificationFeedbackGenerator()
////        generator.notificationOccurred(.success)
////    }
//
//    private func initEngine(){
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
//            return
//        }
//
//        do {
//            self.coreHaptics = try CHHapticEngine()
//            try coreHaptics?.start()
//        }catch {
//            print("Engine Start Error:\(error.localizedDescription)")
//        }
//    }
//
//    private func EngineSuccess(){
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
//            return
//        }
//
//        var engineEvent = [CHHapticEvent]()
//
//        let intensitySetting = CHHapticEventParameter(parameterID: .hapticIntensity, value: 100)
//        let sharpnessSetting = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
//
//        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensitySetting,sharpnessSetting], relativeTime: 0)
//
//        engineEvent.append(event)
//
//        do{
//            let pattern = try CHHapticPattern(events: engineEvent, parameters: [])
//            let player = try self.coreHaptics?.makePlayer(with: pattern)
//            try player?.start(atTime: 0)
//        }catch{
//            print("Failed to player pattern")
//        }
//    }
//}
//
//class CardProvider : ObservableObject,DropDelegate {
//    @Published var selecedData : [MovieRule] = []
//    @Published var selectedTab : String = "Actor"
//    @Published var actorList : [MovieRule] = [
//        MovieRule(name: "Margot Robbie", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/euDPyqLnuwaWMHajcU3oZ9uZezR.jpg"),
//        MovieRule(name: "Kasumi Arimura", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/irMWWtJQu3kWEOB9JUflKBuhh8H.jpg"),
//        MovieRule(name: "Alexandra Daddario", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/lh5zibQXYH1MNqkuX8TmxyNYHhK.jpg"),
//        MovieRule(name: "Scarlett Johansson", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/6NsMbJXRlDZuDzatN2akFdGuTvx.jpg"),
//        MovieRule(name: "Kate Beckinsale", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/1mdRhTJGqFwo9Xuul7XO6oXpzhb.jpg"),
//        MovieRule(name: "Miles Wei", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/fT4v4LTDXGEFGHe7ZAaRTtqBFYM.jpg"),
//        MovieRule(name: "Jet Li", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/7d4hgOzFW7CWPcE92eTSEFRSObC.jpg"),
//        MovieRule(name: "Walaipech Link Khunthira", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/al32bKQdLGyCljkkIVfpAEQJiWC.jpg"),
//        MovieRule(name: "Chloë Grace Moretz", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/yq4rYmaTRC5degaOYmJQFpaiho1.jpg"),
//        MovieRule(name: "Hermione Corfield", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/spFBpwGFWgPhAS0cJjMDtZklquu.jpg"),
//        MovieRule(name: "Milena Radulović", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/36p6fWs1pMVSUA0KUrvcZeMspvG.jpg"),
//        MovieRule(name: "Tom Holland", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/2qhIDp44cAqP2clOgt2afQI07X8.jpg"),
//        MovieRule(name: "Thomasin McKenzie", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/WOpnEFG5Q8LWxP81MtUrskmVox.jpg"),
//        MovieRule(name: "Ji Eun-seo", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/rz8VO7PIZVcTUJ2hfl4bUIQ50mJ.jpg"),
//        MovieRule(name: "Emma Stone", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/2hwXbPW2ffnXUe1Um0WXHG0cTwb.jpg"),
//        MovieRule(name: "Seung Ha", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/8dCFK8FDFQbYFZvzAE9IIeaDMKo.jpg"),
//        MovieRule(name: "Zendaya", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/r3A7ev7QkjOGocVn3kQrJ0eOouk.jpg"),
//
//        MovieRule(name: "Daisy Ridley", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/n8kBnNOi9VmELHJy3FdZjrSN9zT.jpg"),
//        MovieRule(name: "Leonardo DiCaprio", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg"),
//        MovieRule(name: "Erin Moriarty", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/oioBLC6lD6CfYGjDrs8iO6iH4gS.jpg"),
//        MovieRule(name: "Mackenyu Arata", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/amnbjSvI19ZfxkZNj8WOa9tr7yu.jpg"),
//        MovieRule(name: "Emma Roberts", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/gn5rf7Nh0X0855n07XkuEn27n0n.jpg"),
//        MovieRule(name: "Chris Pratt", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/gXKyT1YU5RWWPaE1je3ht58eUZr.jpg"),
//        MovieRule(name: "Donnie Yen", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/hTlhrrZMj8hZVvD17j4KyAFWBHc.jpg"),
//        MovieRule(name: "Robert Downey Jr.", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/5qHNjhtjMD4YWH3UP0rm4tKwxCL.jpg"),
//        MovieRule(name: "Tang Yan", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/jtn4oAeZr6srS0H0oxEZTAragCZ.jpg"),
//        MovieRule(name: "Kim Tae-hyung", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/jPCklfz8cAXfvRptmeNeYBa9Myf.jpg"),
//        MovieRule(name: "Seo Ye-ji", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/7g8md7KfgVfP6gAFB2mqt2cnUNY.jpg"),
//
//        MovieRule(name: "Lili Reinhart", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/6rVAlJse9u5paRddZXA2zRAXidh.jpg"),
//        MovieRule(name: "Freddie Highmore", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/4haqYYQJFhFe9Poqb26Xpuj1VJk.jpg"),
//        MovieRule(name: "Elle Fanning", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/e8CUyxQSE99y5IOfzSLtHC0B0Ch.jpg"),
//        MovieRule(name: "Xiao Zhan", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/ut3pJVWuQ0rZ1KNstA8Hg6Z4nVi.jpg"),
//        MovieRule(name: "Josephine Langford", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/rxQIrvUN1NGHkqSKHug1hoHTUNi.jpg"),
//        MovieRule(name: "Jin Chen", rule: .Actor, postURL: "https://www.themoviedb.org/t/p/original/rcC9P3YX3UpPazZUnLdiQn5xKf8.jpg")
//
//
//    ]
//    @Published var directorList : [MovieRule] = [
//        MovieRule(name: "Jim Barr", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/myLNBZXXESp1YzDkBoKQX8g4Yup.jpg"),
//        MovieRule(name: "Charles Wood", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/lxhuwWMdbvuPzher5TSdGFsel1S.jpg"),
//        MovieRule(name: "Michaela McAllister", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/ys7TRFyl7RpBziYZ7JVadSfawWT.jpg"),
//        MovieRule(name: "Adam Collins", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/iuKuZT6xWpzdVhAouEZllgLEwgB.jpg"),
//        MovieRule(name: "Carl Anthony Nespoli", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/b0ZxuVSl46shI2YNq9SUyUm2wHH.jpg"),
//        MovieRule(name: "Holly Dowell", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/zwnrOAdqZOHvmcCSOTMJ3rifAjM.jpg"),
//        MovieRule(name: "Brian A. Miller", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/8uc10NUQVOdFFgf4gymL3UeDhos.jpg"),
//        MovieRule(name: "Randall Emmett", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/wlFuKcM85H1TeNjSshBSpjdsEVg.jpg"),
//        MovieRule(name: "David Barber", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/hlzzHtGS8RqZXAh0vSEZiPHLfgN.jpg"),
//        MovieRule(name: "Wayne Marc Godfrey", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/yk64CnMjULyWIIo5NKUYWwREPyV.jpg"),
//        MovieRule(name: "Lorne Balfe", rule: .Director, postURL: "https://www.themoviedb.org/t/p/original/6PzSv56I9mRe7QKuAsGU9JjlIu2.jpg"),
//    ]
//
//    @Published var genreList : [MovieRule] = [
//        MovieRule(name: "Actor", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg"),
//        MovieRule(name: "Adventure", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/9dKCd55IuTT5QRs989m9Qlb7d2B.jpg"),
//        MovieRule(name: "Comedy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/cycDz68DtTjJrDJ1fV8EBq2Xdpb.jpg"),
//        MovieRule(name: "Crime", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/ky8Fua6PD7FyyOA7JACh3GDETli.jpg"),
//        MovieRule(name: "Fantasy", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/dkokENeY5Ka30BFgWAqk14mbnGs.jpg"),
//        MovieRule(name: "Horror", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/bShgiEQoPnWdw4LBrYT5u18JF34.jpg"),
//        MovieRule(name: "Science Fiction", rule: .Genre, postURL: "https://www.themoviedb.org/t/p/original/78wC6ZWhTlqaCNL0rS7jl7dAV85.jpg"),
//    ]
//    //    @Published var genraList = [
//    //
//    //    ]
//
////    func getSearchResult(){
//////        let url = "http://127.0.0.1/api/seaching/getseachcardresult"
//////        let req = URLRequest.init(url: URL(string: url))
//////        URLSession.shared.dataTask(with: req)
////    }
////
//
//    func getListWithFilter(tab : String){
//        //TODO ?
//    }
//
//    func performDrop(info: DropInfo) -> Bool {
//        // just allow to drop at most 10 Card
//
//        for imgProvider in info.itemProviders(for: [String(kUTTypeURL)]){
//            if imgProvider.canLoadObject(ofClass: URL.self){
//                print("URL loaded")
//
//                //for each drop item if can load and it will provide a CardID
//                //And Seching from the list
//
//                let _ = imgProvider.loadObject(ofClass: URL.self){ (CardId,err) in
//
//                    print(CardId!)
//                    //check current selected list is exist or not
//                    let checkState = self.selecedData.contains{ (exist) -> Bool in
//                        return exist.id == "\(CardId!)"
//                    }
//
//                    //Get the item is exist in current list or not
//                    //If not exist append to current list
//                    if !checkState {
//                        //We need to find the current data in provider lsit first
//                        //and we can get is Actor? Director? Genre
//                        //But we don't know the card in which list
//                        // we need to figure our first
//                        let actor = self.actorList.filter{(item) -> Bool in
//                            return item.id == "\(CardId!)"
//                        }
//
//                        let director = self.directorList.filter{(item) -> Bool in
//                            return item.id == "\(CardId!)"
//                        }
//
//                        let genre = self.genreList.filter{(item) -> Bool in
//                            return item.id == "\(CardId!)"
//                        }
//
//                        //Either one is not empty
//                        if !actor.isEmpty {
//                            //Because we are using Uquie ID ,won't have same id
//                            //There is one item only
//                            //Append to the list
//                            DispatchQueue.main.async {
//                                withAnimation(.default){
//                                    self.selecedData.insert(actor.first!, at: 0) //we have already check is not empty
//                                }
//                            }
//                        }else if !director.isEmpty {
//                            //Because we are using Uquie ID ,won't have same id
//                            //There is one item only
//                            DispatchQueue.main.async {
//                                withAnimation(.default){
//                                    self.selecedData.insert(director.first!, at: 0) //we have already check is not empty
//                                }
//                            }
//
//                        }
//                        else if !genre.isEmpty {
//                            DispatchQueue.main.async {
//                                withAnimation(.default){
//                                    self.selecedData.insert(genre.first!, at: 0) //we have already check is not empty
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            else {
//                print("URL can't load")
//            }
//
//
//        }
//        return true
//    }
//
//    func dropEntered(info: DropInfo) {
//        //TODO something when item enter
//    }
//
//    func dropUpdated(info: DropInfo) -> DropProposal? {
//        print("test")
//        return DropProposal.init(operation: .move)
//    }
//
//}
//
//struct MovieRule : Identifiable,Hashable{
//    let id :String = UUID().uuidString //for now just dummy id
//    let name : String
//    let rule : CharacterRule
//    let postURL : String
//}
//
//enum CharacterRule : String{
//    case Actor = "Actor"
//    case Director = "Director"
//    case Genre = "Genre"
//}
//
////Preview modele and observe object
//
//struct PreviewMovie : Identifiable,Codable{
//    var id = UUID().uuidString
//    let name : String
//    let genre : [String]
//    let actor : [String]
//    let release : String
//    let time : String
//    let overview : String
//    let posterURL : String
//}
//
//class PreviewModle : ObservableObject {
//    @Published var isShowPreview : Bool = false
//    @Published var previewData : PreviewMovie?
//
//    func getPreviewMovie(){
//        //TO send request and get movie
//    }
//}
