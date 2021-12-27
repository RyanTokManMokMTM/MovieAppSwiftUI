//
//  MorePreviewResultView.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI
import UIKit
import MobileCoreServices
import SDWebImageSwiftUI

struct MorePreviewResultView : View{
    
    @State private var currentIndex : Int = 0
    @EnvironmentObject  var StateManager : SeachingViewStateManager
//    @EnvironmentObject var DragAndDropPreview : DragSearchModel
    @EnvironmentObject var previewModel : PreviewModel
    var isNavLink : Bool = true
    var backPageName : String = "Search"
    @Binding var isActive : Bool
    @State private var isShowResult : Bool = false
    @State private var selectedId : Int?
//
//    var movieList : [MoviePreviewInfo]
//
    var body: some View{
        ZStack(alignment:.top){
            //Show Movie detail
            if selectedId != nil{
                NavigationLink(destination: MovieDetailView(movieId:self.selectedId!, navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true)), isActive: self.$isShowResult){EmptyView()}
            }
            
            ZStack{
                if !self.previewModel.previewDataList.isEmpty{
                    ZStack{
                        //background iamge using a tab View with page style
                        TabView(selection:$currentIndex){
                            ForEach(self.previewModel.previewDataList.indices,id:\.self){ i in
                                GeometryReader{proxy in
                                    WebImage(url: self.previewModel.previewDataList[i].posterURL)
                                        .resizable()
                                        .placeholder{
                                            Text(self.previewModel.previewDataList[i].title)
                                        }
                                        .indicator(.activity) // Activity Indicator
                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                        .aspectRatio(contentMode:.fill)
                                        .frame(width:proxy.size.width,height:proxy.size.height)
                                        .cornerRadius(1)
                                }
    
                                .ignoresSafeArea()
                                .offset(y:-100)
                            }
//                            .onChange(of: currentIndex){ value in
//                                print(value)
//                                if value == self.previewModel.previewDataList.count - 5 {
//                                    if !self.previewModel.isFetchingPreviewList{
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
//                                            self.previewModel.getMorePreviewResults()
//                                        }
//                                    }
//                                }
//                            }
    
                        }
                        .edgesIgnoringSafeArea(.top)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .ignoresSafeArea()
                        //            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
                        .animation(.easeOut(duration: 0.25))
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [
                                Color.clear,
                                Color.black.opacity(0.2),
                                Color.black.opacity(0.4),
                                Color.black,
                                Color.black,
                                Color.black,
    
                            ]), startPoint: .top, endPoint: .bottom)
                        )
                        //
                        ListSilder(trailingSpace:150,index: self.$currentIndex, items: self.previewModel.previewDataList){ movie in
                            PreviewView(card: movie)
    
                        }
                        .offset(y:UIScreen.main.bounds.height / 4)
    
                        .edgesIgnoringSafeArea(.all)
                    }

                
                }
                else{
                    VStack{
                        Spacer()
                        Text("Empty Reuslt...")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .bold()
                        Spacer()
                    }
                }
                
                if  (self.previewModel.isFetchingPreviewList || self.previewModel.fetchingPreviewListErr != nil){ //no data yet
                    //Loaing view
                    VStack{
                        LoadingView(isLoading: self.previewModel.isFetchingPreviewList, error: self.previewModel.fetchingPreviewListErr ){
//                            self.previewModel.getMorePreviewResults()
                        }
                        .frame(width: 225, height: 100)
                        .background(BlurView())
                        .cornerRadius(25)

                
                    }
                    .background(
                        EmptyView()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .background(Color.black.opacity(0.45))
                    )
                }
                
            }


            
            if isNavLink{
                HStack(spacing:2){
                    Button(action:{
                        withAnimation(){
                            self.isActive.toggle()
                            self.previewModel.previewDataList.removeAll()
                        }
                    }){
                        HStack(spacing:2){
                            Image(systemName: "chevron.backward")
                            Text(backPageName)
                        }
                        .padding(10)
                        .background(BlurView().cornerRadius(25))
                        
                    }
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal,5)
                .offset(y:60)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle(self.isShowResult ? "Preview" : "")
        .navigationBarTitle(self.isShowResult ? "Preview" : "")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
    
    @ViewBuilder
    private func PreviewView(card : MoviePreviewInfo) -> some View{
        VStack(spacing:10){
            GeometryReader{proxy in
//                Image(card.image)
                WebImage(url: card.posterURL)
                    .resizable()
                    .placeholder{
                        Text(card.title)
                    }
                    .indicator(.activity) // Activity Indicator
                    .aspectRatio(contentMode:.fill)
                    .frame(width:proxy.size.width,height:proxy.size.height)
                    .cornerRadius(25)
                    
            }
            .padding(20)
            .background(BlurView(sytle: .systemUltraThinMaterialDark))
            .cornerRadius(25)
            .frame(height:UIScreen.main.bounds.height / 2.5)
            .padding(.bottom,15)
            
            //the movie data here
            Text(card.title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            //movie rate
            HStack(spacing:3){
                if card.vote_average != nil{
                    ForEach(1...5,id:\.self){index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index <= Int(card.vote_average!)/2 ? .yellow: .gray)
                    }
                    
                    Text("(\(Int(card.vote_average!)/2).0)")
                        .foregroundColor(.gray)
                }
            }
            .font(.caption)
            
            Text(card.overview)
                .font(.callout)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.top,8)
                .padding(.horizontal)
                .foregroundColor(.white)
            
            
        }
        .onTapGesture {
            withAnimation(){
                self.isShowResult.toggle()
                self.selectedId = card.id
            }
        }
        
    }
}
