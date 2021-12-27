//
//  BottomSheet.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI
import UIKit
import MobileCoreServices
import SDWebImageSwiftUI

struct BottomSheet : View{
    @EnvironmentObject var searchStateManager : SeachingViewStateManager
    @EnvironmentObject var dragSearchModel : DragSearchModel //Using previeModle
    @EnvironmentObject var previewModel : PreviewModel //Using previeModle

//    @Binding var isPreview : Bool
    @State private var cardOffset:CGFloat = 0
    var body : some View{
        VStack{
            Spacer()
            VStack(spacing:12){

                Capsule()
                    .fill(Color.gray)
                    .frame(width: 60, height: 4)

                Text("PREVIEW RESULT")
                    .bold()
                    .foregroundColor(.gray)
                
                //the preview result must not empty
                if self.previewModel.fetchPreLoading {
                    HStack{
                        ActivityIndicatorView()
                        VStack{
                            Text("loading")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("Preparing the movie info for you,please wait...")
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                        }
                           
                    }
                    .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 4)
                    .padding(.top,10)
                    .padding(.bottom)
                    .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                } else if self.previewModel.fetchError != nil {
                    VStack{
                        
                        LoadingView(isLoading: self.previewModel.fetchPreLoading, error: self.previewModel.fetchError!){
                            self.previewModel.getMoviePreview(selectedDatas: self.dragSearchModel.selectedPreviewDatas)
                        }
                    }
                    .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 4)
                    .padding(.top,10)
                    .padding(.bottom)
                    .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                }else {
                    if previewModel.previewData != nil{
                        VStack{
                            HStack(){
                                //Movie Image Cover Here
                                HStack(alignment:.top){
                                    WebImage(url: self.previewModel.previewData!.posterURL)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 135)
                                        .cornerRadius(10)
                                        .clipped()
                                    //Movie Deatil
                                    
                                    //OR MORE...
                                    //Name,Genre,Actor,ReleaseDate,Time, Langauge etc
                                    VStack(alignment:.leading,spacing:10){
                                        Text(self.previewModel.previewData!.title)
                                            .bold()
                                            .font(.headline)
                                            .lineLimit(1)
                                        HStack(spacing:0){
                                            //at most show 2 genre!
                                            Text("Genre: ")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            //                                            .lineLimit(1)
                                            
                                            if self.previewModel.previewData!.genres != nil{
                                                HStack(spacing:0){
                                                    Text(self.previewModel.previewData!.genres!.joined(separator: ","))
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                    
                                                    
                                                }
                                                .lineLimit(1)
                                            }else{
                                                Text("n/a")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                        }
                                        
                                        Text("Language: \(self.previewModel.previewData!.original_language!)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                        
                                        HStack(spacing:0){
                                            //at most show 2 genre!
                                            Text("Actor: ")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            //                                            .lineLimit(1)
                                            if self.previewModel.previewData!.casts != nil{
                                                HStack(spacing:0){
                                                    ForEach(0..<self.previewModel.previewData!.casts!.count){i in

                                                        Text(self.previewModel.previewData!.casts![i])
                                                            .font(.system(size: 14))
                                                            .foregroundColor(.gray)

                                                        if i != (self.previewModel.previewData!.casts!.count - 1){
                                                            Text(",")
                                                                .font(.system(size: 14))
                                                                .foregroundColor(.gray)
                                                        }
                                                    }
                                                }
                                                .lineLimit(1)

                                            }else{
                                                Text("n/a")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                        }
                                        
                                        Text("Release: \(self.previewModel.previewData!.release_date ?? "Coming soon...")")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                        Text("Time: \(self.previewModel.previewData!.durationText)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    .padding(.top)
                                    
                                    Spacer()
                                    
                                }.padding(.horizontal)
                                .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 4)
                                
                                
                                //                            Spacer()
                            }
                            //                        .padding(.horizontal)
                            
                            VStack(alignment:.leading){
                                Text("Overview:")
                                    .bold()
                                    .font(.subheadline)
                                    .lineLimit(1)
                                
                                if self.previewModel.previewData!.overview != "" {
                                    HStack(spacing:0){
                                        Text(self.previewModel.previewData!.overview)
                                            
                                            .font(.footnote)
                                            .lineLimit(3)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth:.infinity)
                                }else{
                                    HStack(spacing:0){
                                        Text("Opps! Overview is comming soon...")
                                            .font(.footnote)
                                            .lineLimit(3)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth:.infinity)
                                }
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing:45){
                                
                                SmallRectButton(title: "Detail", icon: "ellipsis.circle"){
                                    withAnimation(){
                                        //it need to toggle preview state too
                                        self.searchStateManager.previewResult.toggle()
                                        self.previewModel.isShowPreview.toggle()
                                    }
                                }
                                
                                SmallRectButton(title: "More", icon: "magnifyingglass", textColor: .white, buttonColor: Color("BluttonBulue2")){
                                    withAnimation(){
                                        self.searchStateManager.previewMoreResult.toggle()
                                        self.previewModel.isShowPreview.toggle()
//                                        self.previewModel.getMorePreviewResults()
                                    }
                                }
                                
                            }
                            .padding(.horizontal)
                        }
                        //                .padding(.horizontal,5)
                        .padding(.top,10)
                        .padding(.bottom)
                        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    }
                    else{
                        VStack{
                            Text("Empty Result!")
                                .foregroundColor(.gray)
                                .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 4)
                        }
                        .padding(.top,10)
                        .padding(.bottom)
                        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    }
                    
                }
            }
            .padding(.top)
            .background(BlurView().clipShape(CustomeConer(width: 20, height: 20,coners: [.topLeft,.topRight])))
            .offset(y:cardOffset)
            .gesture(
                DragGesture()
                    .onChanged(self.onChage(value:))
                    .onEnded(self.onEnded(value:))
            )
            .offset(y:self.previewModel.isShowPreview ? 0 : UIScreen.main.bounds.height)
        }
        .ignoresSafeArea()
        .background(Color
                        .black
                        .opacity(self.previewModel.isShowPreview ? 0.3 : 0)
                        .onTapGesture {
                            
                            withAnimation(){                                self.previewModel.isShowPreview.toggle()
                            }
                        }
                        .ignoresSafeArea().clipShape(CustomeConer(width: 20, height: 20,coners: [.topLeft,.topRight])))

    }

    private func onChage(value : DragGesture.Value){
        print(value.translation.height)
        if value.translation.height > 0 {
            self.cardOffset = value.translation.height
        }
    }

    private func onEnded(value : DragGesture.Value){
        if value.translation.height > 0 {
            withAnimation(){
                let cardHeight = UIScreen.main.bounds.height / 4

                if value.translation.height > cardHeight / 2.8 {
                    self.previewModel.isShowPreview.toggle()
                }
                self.cardOffset = 0
            }
        }
    }

}
