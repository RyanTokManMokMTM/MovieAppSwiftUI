//
//  SeachDragingView.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI
import UIKit
import UIKit
import MobileCoreServices
import SDWebImageSwiftUI

struct SeachDragingView : View{
    @State private var offset : CGFloat = 0.0
    @EnvironmentObject var dragSearchModel : DragSearchModel //Using previeModle
    @EnvironmentObject var previewModel : PreviewModel
    @State private var isEndFetching : Bool = false
    var body : some View{
        return
            ZStack(alignment:.bottom){
                ZStack(alignment:.top){
                    Group{
                        VStack(spacing:0){
                            Text(dragSearchModel.selectedTab.rawValue)
                                .bold()
                                .font(.subheadline)
                                .padding(.vertical,1)
                                .padding(.top,3)
                            CustomePicker(selectedTabs: $dragSearchModel.selectedTab)
                        }
                        .frame(width:UIScreen.main.bounds.width-5)
                    }
                    .background(BlurView(sytle: .regular).clipShape(CustomeConer(width:24,height:24,coners: [.topLeft,.topRight,.bottomRight,.bottomLeft])))
                    .zIndex(5)
                    
                    Group{
                        if dragSearchModel.dragGenre.isEmpty{
                            VStack{
                                Spacer()
                                LoadingView(isLoading: dragSearchModel.isGenreLoading, error: dragSearchModel.genreHTTPErr){
                                    dragSearchModel.getGenreList()
                                }
                                Spacer()
                            }
                            .opacity(dragSearchModel.selectedTab == .Genre ? 1 : 0)
                            .padding(.vertical)
                        }else{
                            ScrollableCardGrid(list: self.$dragSearchModel.dragGenre,cardType:.Genre,isShow:dragSearchModel.selectedPreviewDatas.isEmpty ? false : true,beAbleToUpdate: false,isOffsetting: true,offsetVal: 75)
                                .opacity(dragSearchModel.selectedTab == .Genre ? 1 : 0)
                        }

                        if dragSearchModel.dragActor.isEmpty{
                            VStack{
                                Spacer()
                                if dragSearchModel.actorHTTPErr != nil{
                                    LoadingView(isLoading: dragSearchModel.isActorLoading, error: dragSearchModel.actorHTTPErr){
                                        dragSearchModel.getActorsList(succeed: {
                                            print("Data re-fetching succeed")
                                        }, failed: {
                                            print("Data re-fetching failed")
                                        })

                                    }
                                }else{
                                    Text("No Date Here")
                                        .bold().foregroundColor(.secondary)
                                    Button(action:{
                                        dragSearchModel.getActorsList(succeed: {
                                            print("Data re-fetching succeed")
                                        }, failed: {
                                            print("Data re-fetching failed")
                                        })
                                    }){
                                        Text("Fetch again")
                                            .foregroundColor(.white)
                                    }
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                                }
                                Spacer()
                            }
                            .opacity(dragSearchModel.selectedTab == .Actor ? 1 : 0)
                            .padding(.vertical)
                        }else{
                            ScrollableCardGrid(list: self.$dragSearchModel.dragActor,cardType:.Actor,isShow:dragSearchModel.selectedPreviewDatas.isEmpty ? false : true,isOffsetting: true,offsetVal: 75)
                            .opacity(dragSearchModel.selectedTab == .Actor ? 1 : 0)
                        }

                        if dragSearchModel.dragDirector.isEmpty{
                            VStack{
                                Spacer()
                                LoadingView(isLoading: dragSearchModel.isDirectorLoading, error: dragSearchModel.directorHTTPErr){
                                    dragSearchModel.getDirectorList(succeed: {
                                        print("Data re-fetching succeed")
                                    }, failed: {
                                        print("Data re-fetching failed")
                                    })
                                }
                                Spacer()
                            }
                            .opacity(dragSearchModel.selectedTab == .Director ? 1 : 0)
                            .padding(.vertical)
                        }else{
                            ScrollableCardGrid(list: self.$dragSearchModel.dragDirector,cardType:.Director,isShow:dragSearchModel.selectedPreviewDatas.isEmpty ? false : true,isOffsetting: true,offsetVal: 75)
                                .opacity(dragSearchModel.selectedTab == .Director ? 1 : 0)
                        }
                    }
                    
                }

                //Drop area
                //Make a drop area as a box for dropping any cardItem user is wanted
                VStack(alignment:.trailing){
                    if !dragSearchModel.selectedPreviewDatas.isEmpty{
                        HStack{
                            Button(action:{
                                withAnimation(){
                                    self.dragSearchModel.selectedPreviewDatas.removeAll()
                                }
                            }){
                                HStack{
                                    Text("Trash All")
                                        .foregroundColor(.red)
                                        .font(.body)

                                    Image(systemName: "trash.circle")
                                        .foregroundColor(.white)
                                }
                            }

                            Spacer()
                            
                            if dragSearchModel.selectedPreviewDatas.count == self.dragSearchModel.getMaxSelectedItem(){
                                Text("FULLED!")
                                    .bold()
                                    .font(.caption)
                                
                                Spacer()
                            }

                    
                            Button(action:{
                                withAnimation(){
                                    self.previewModel.isShowPreview.toggle() //using envronment object
                                    self.previewModel.getMoviePreview(selectedDatas: self.dragSearchModel.selectedPreviewDatas) //geeting movie perview data with selected data
                                }
                            }){
                                HStack{
                                    Image(systemName: "arrow.up.circle")
                                        .foregroundColor(.white)

                                    Text("Preview")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)

                    }

                    ZStack{
                        //If not card is dropped
                        if dragSearchModel.selectedPreviewDatas.isEmpty{
                            HStack{
                                Spacer()
                                Text("Drop image here")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .transition(.identity)
                                Spacer()
                            }
                                
                        }else if self.dragSearchModel.getSelectedListWithFilter().isEmpty{
                            HStack{
                                Spacer()
                                Text("No Datas is selected!")
                                    .fontWeight(.bold)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                    .transition(.identity)
                                Spacer()
                            }
                        }else{
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(dragSearchModel.getSelectedListWithFilter(),id:\.id){card in
                                        //                                    ZStack(alignment: .topTrailing){
                                        VStack(spacing:3){
                                            if card.itemType == CharacterRule.Genre{
                                                WebImage(url: card.genreData!.posterImg)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width:60,height:85)
                                                    .cornerRadius(10)
                                                    .clipped()
                                                    .onTapGesture(count: 2){
                                                        withAnimation(.default){
                                                            self.dragSearchModel.selectedPreviewDatas.removeAll{ (checking) in
                                                                return checking.id == card.id
                                                            }}
                                                    }
                                                    .padding(.top,3)
                                                
                                                Text(card.genreData!.name)
                                                    .font(.caption)
                                                    .frame(width:55,height:13)
                                                    .lineLimit(1)
                                            }else{
                                                WebImage(url: card.personData!.ProfileImageURL)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width:60,height:85)
                                                    .cornerRadius(10)
                                                    .clipped()
                                                    .onTapGesture(count: 2){
                                                        withAnimation(.default){
                                                            self.dragSearchModel.selectedPreviewDatas.removeAll{ (checking) in
                                                                return checking.id == card.id
                                                            }}
                                                    }
                                                    .padding(.top,3)
                                                
                                                Text(card.personData!.name)
                                                    .font(.caption)
                                                    .frame(width:55,height:13)
                                                    .lineLimit(1)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                        }
                        
                    }
                    .frame(height: self.dragSearchModel.selectedPreviewDatas.isEmpty || self.dragSearchModel.getSelectedListWithFilter().isEmpty ? 50 : 100)
                    .padding(.bottom,10)
                    .padding(.top,10)
                    .background(self.dragSearchModel.selectedPreviewDatas.isEmpty  || self.dragSearchModel.getSelectedListWithFilter().isEmpty ? Color("OrangeColor") : Color("DropBoxColor"))
                    .cornerRadius(20
                    )
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: Color.black.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 1.0, y: 1.0 )
                    .padding(.horizontal)
                    .onDrop(of: [String(kUTTypeURL)], delegate: dragSearchModel)

                    if !dragSearchModel.selectedPreviewDatas.isEmpty{
                        
                        HStack{
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action:{
                                        withAnimation{
                                            self.dragSearchModel.filter = .All
                                        }
                                    }){
                                        HStack{
                                            Text("Show All")
                                               
                                            Spacer()
                                            if self.dragSearchModel.filter == .All{
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }
                                    
                                    Button(action:{
                                        withAnimation{
                                            self.dragSearchModel.filter = .Genre
                                        }
                                    }){
                                        HStack{
                                            Text("Show Genres")
                                               
                                            Spacer()
                                            if self.dragSearchModel.filter == .Genre{
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }

                                    Button(action:{
                                        withAnimation{
                                            self.dragSearchModel.filter = .Actor
                                        }
                                    }){
                                        HStack{
                                            Text("Show Actor")
                                            Spacer()
                                            if self.dragSearchModel.filter == .Actor{
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.green)
                                            }
                                                
                                        }
                                    }
                                    
                                    Button(action:{
                                        withAnimation{
                                            self.dragSearchModel.filter = .Director
                                        }
                                    }){
                                        HStack{
                                            Text("Show Director")
                                            if self.dragSearchModel.filter == Tab.Director{
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.green)
                                            }
                                                
                                        }
                                    }
                                    
                                    
                                }))
                                
                            Spacer()
                            Text("Double tab to remove!")
                                .font(.caption)
                                .foregroundColor(.red)
                                .bold()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(BlurView())
                .cornerRadius(25)
                .padding(.horizontal)
                .padding(.bottom,5)
            }
    }
}

