//
//  MovieDetailScrollView.swift
//  IOS_DEV
//
//  Created by Jackson on 30/4/2021.
//

import SwiftUI

//struct MovieDetailScrollView: View {
//    var tabs:[Tabs]
//    @State private var currentTab:Tabs = .overView
//
//    func getStrWidth(_ font:Tabs)->CGFloat{
//        //get current string size
//        let current = font.rawValue //get enum value
//        return current.widthOfStr(Font: .systemFont(ofSize: 16,weight: .bold))
//    }
//
//    var body: some View {
//        VStack(spacing:5) {
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack(spacing:10){
//                    ForEach(tabs,id:\.self){tab in
//                        VStack{
//                            Button(action: {
//                                withAnimation(.easeInOut){
//                                    currentTab = tab
//                                }
//                            }){
//                                Text(tab.rawValue)
//                                    .font(.system(size: 16))
//                                    .bold()
//                                    .foregroundColor(currentTab == tab ? Color.white : Color.gray)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .frame(width:getStrWidth(tab),height:50)
//
//
//                            RoundedRectangle(cornerRadius: 2)
//                                .frame(width:getStrWidth(tab),height: 6)
//                                .foregroundColor(currentTab == tab ? Color.red : Color.clear)
//                                .offset(y:-10)
//
//                        }
//
//                    }
//                }
//            }
//
//            switch currentTab{
//            case .overView:
//                OverViews()
//                    .padding(.top)
//            case .trailer:
//                Text("")
//            case .more:
//                MoreMovieView() //in progress
//            case .resouces:
//                Text("test")
//         //   case .info:
//             //   MovieInfoView(data: tempData)
//
//            }
//
//
//           Spacer()
//        }
//        .foregroundColor(.gray)
////        .frame(height: 50)
//    }
//}

//struct MovieDetailScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack{
//            Color.black.edgesIgnoringSafeArea(.all)
//            MovieDetailScrollView(tabs: [.overView,.trailer,.more,.resouces])
//        }
//    }
//}

//enum Tabs : String{
//    case overView = "OVERVIEW"
//    case trailer = "TRAILER & MORE"
//    case more = "MORE MOVIE"
//    case resouces = "MOVIE RESOURCE"
//}
//
//
//struct OverViews:View {
//    var body:some View{
//        VStack(spacing:5){
//            VStack(spacing:10){
//                HStack(alignment:.bottom){
//                    Text("Plot Summary:")
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                }
//                
//                //just support at most 5 line
//                
//                ExpandableText("電玩改編電影，新版《魔宮帝國》又名《真人快打》。體驗新世代格鬥，延續血腥暴力的風格，描述綜合格鬥選手「科爾楊」準備好跟地球最強的冠軍聯手，為了宇宙展開一場高風險戰役，並肩對抗外世界的敵人。", lineLimit: 5)
//            }
//            .padding(.horizontal,10)
//            
//            Spacer()
//            
//            Divider()
//                .background(Color.gray)
//            
//            
//            VStack(spacing:10){
//                HStack(alignment:.bottom){
//                    Text("Movie Capture:")
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                .padding(.horizontal,10)
//                
//                MovieCaptureList(CaptureList: CaptureLists)
//                    .frame(height:200)
//            }
//            
//            Spacer()
//            
//            Divider()
//                .background(Color.gray)
//            
//            
//            VStack(spacing:10){
//                HStack(alignment:.bottom){
//                    Text("Movie Cast:")
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                .padding(.horizontal,10)
//                
//                ActorAvatarList(actorList: ActorLists)
//                
//            }
//            
//            Spacer()
//            
//            Divider()
//                .background(Color.gray)
//            
//            MovieInfoView(data: tempData)
//                .padding(.horizontal,10)
//            
//        }
//        .foregroundColor(.gray)
//    }
//}

//struct OverViews_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack{
//            Color.black.edgesIgnoringSafeArea(.all)
//            MovieDetailScrollView(tabs: [.overView,.trailer,.more,.resouces])
//        }
//    }
//}

//
//
//struct ExpandableText: View {
//    @State private var expanded: Bool = false
//    @State private var truncated: Bool = false
//    private var text: String
//
//    let lineLimit: Int
//
//    init(_ text: String, lineLimit: Int) {
//        self.text = text
//        self.lineLimit = lineLimit
//    }
//
//    private var moreLessText: String {
//        if !truncated {
//            return ""
//        } else {
//            return self.expanded ? "less" : "more"
//        }
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading,spacing:5) {
//            Text(text)
//                .lineLimit(expanded ? nil : lineLimit)
//                .background(
//                    Text(text).lineLimit(lineLimit)
//                        .background(GeometryReader { visibleTextGeometry in
//                            ZStack { //large size zstack to contain any size of text
//                                Text(self.text)
//                                    .background(GeometryReader { fullTextGeometry in
//                                        Color.clear.onAppear {
//                                            self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
//                                        }
//                                    })
//                            }
//                            .frame(height: .greatestFiniteMagnitude)
//                        })
//                        .hidden() //keep hidden
//            )
//            if truncated {
//                Button(action: {
//                    withAnimation {
//                        expanded.toggle()
//                    }
//                }){
//                    Text(moreLessText)
//                        .font(.body)
//                        .foregroundColor(.white)
//                        
//                }
//            }
//        }
//        .font(.subheadline)
//        .foregroundColor(Color(UIColor.systemGray3))
//    }
//}
