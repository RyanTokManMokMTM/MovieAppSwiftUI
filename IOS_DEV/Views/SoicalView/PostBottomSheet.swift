//
//  PostBottomSheet.swift
//  IOS_DEV
//
//  Created by Jackson on 15/7/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostBottomSheet : View{
    @State var offset: CGFloat = 0.0
    @EnvironmentObject var postVM : PostVM
    var info : Post
    @State private var cardOffset:CGFloat = 0
    var body : some View{
        VStack{
            Spacer()
            VStack(spacing:12){
                Text("Content & Comments")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.lightText))
                    .overlay(
                       HStack{
                           Spacer()
                            Button(action: {
                                withAnimation{
                                    self.postVM.isShowMore.toggle()
                                }
                            }){
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }
                       }
                        .padding(.horizontal,10)
                        .frame(width: UIScreen.main.bounds.width)
                    )

                
                
                PostInfoView(offset:$offset, info: info)
                    .padding(.top,10)
                    .padding(.bottom)
                //                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .ignoresSafeArea()
                Spacer()
            }
            .padding(.horizontal)
            .frame(height:UIScreen.main.bounds.height / 1.5)
            .padding(.top)
            .background(Color("appleDark").clipShape(CustomeConer(width: 10, height: 10,coners: [.topLeft,.topRight])))
            .offset(y:cardOffset)
            .gesture(
                DragGesture()
                    .onChanged(self.onChage(value:))
                    .onEnded(self.onEnded(value:))
            )
            .offset(y: self.postVM.isShowMore ? 0 : UIScreen.main.bounds.height)
          
        }
//        .frame(height:UIScreen.main.bounds.height / 2)
        .ignoresSafeArea()

//        .background(Color
//                        .white
//                        .opacity( self.postVM.isShowMore ? 0.3 : 0)
//                        .onTapGesture {
//
//                            withAnimation(){                                 self.postVM.isShowMore.toggle()
//                            }
//                        }
//                        .ignoresSafeArea().clipShape(CustomeConer(width: 10, height: 10,coners: [.topLeft,.topRight])))

    }

    private func onChage(value : DragGesture.Value){
        if offset > 0 {
            return
        }
        print(value.translation.height)
        if value.translation.height > 0 {
            self.cardOffset = value.translation.height
        }
    }

    private func onEnded(value : DragGesture.Value){
        if value.translation.height > 0 {
            withAnimation(){
                let cardHeight = UIScreen.main.bounds.height / 4

                if value.translation.height > cardHeight / 2 {
                    self.postVM.isShowMore.toggle()
                }
                self.cardOffset = 0
            }
        }
    }

}

struct PostInfoView : View {
    @Binding var offset: CGFloat
    var info : Post
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment:.leading,spacing:8){
                //Content and Comment View
                
                Text(info.post_title)
                    .font(.system(size: 18, weight: .bold))
                
                Text(info.post_desc)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(uiColor: UIColor.lightText))
                    .multilineTextAlignment(.leading)
                
                Text(info.post_at.dateDescriptiveString())
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.vertical,5)
                
                Divider()
                    .background(Color(uiColor: UIColor.darkGray))
                    .padding(.bottom)
                
                VStack(alignment:.leading){
                    Text("Comments: \(info.post_comment_count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(uiColor: UIColor.lightText))
                    
                    if info.comments != nil && info.comments!.count == 0 {
                        HStack{
                            Spacer()
                            Image(systemName: "text.bubble")
                                .imageScale(.medium)
                                .foregroundColor(.gray)
                            Text("沒有評論,趕緊霸佔一樓空位!")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.vertical,20)
                    }else {
                        ForEach(info.comments!) { comment in
                            commentCell(comment: comment)
                        }
                    }
                }
                
            }
            .readingScrollView(from: "scroll", into: $offset)
        }.coordinateSpace(name: "scroll")

    }
    
    
    @ViewBuilder
    func commentCell(comment : CommentInfo) ->  some View {
        HStack(alignment:.top){
//                HStack(alignment:.center){
            WebImage(url:comment.user_info.UserPhotoURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
                VStack(alignment:.leading,spacing: 3){
                    Text(comment.user_info.user_name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(uiColor: .systemGray))
                    
                    
                    Text(comment.comment)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 12, weight: .semibold))
                    
                    Text(comment.comment_time.dateDescriptiveString())
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                }
                
//                }
            Spacer()
            
            Image(systemName: "heart")
                .imageScale(.medium)
        }
        
        PostViewDivider
            .padding(.vertical,5)
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
        print("value = \(value)")
    }
    
    typealias Value = CGPoint

}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value.y
        }
    }
}

extension View {
    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGFloat>) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}
