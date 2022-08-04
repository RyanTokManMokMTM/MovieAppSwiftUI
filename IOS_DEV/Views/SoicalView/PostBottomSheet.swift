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
    @EnvironmentObject var userVM : UserViewModel
    var info : Post
    @State private var cardOffset:CGFloat = 0
    @State private var message : String = ""
    @FocusState var isFocues: Bool
    var body : some View{
        VStack(spacing:0){
            Text("內容&評論")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor.lightText))
                .overlay(
                    HStack{
                        Spacer()
                        Button(action: {
                            withAnimation{
                                self.postVM.isReadMorePostInfo.toggle()
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
                .padding(.vertical,8)
            
            
            PostInfoView(info: info)

            CommentArea()
        }
        .frame(alignment: .top)
        .padding(.horizontal)
        .padding(.top)
    }
    
    
    @ViewBuilder
    func CommentArea() -> some View {
        VStack{
            //                Spacer()
            Divider()
            HStack{
                TextField("留下點什麼~",text:$message)
                    .padding(.horizontal)
                    .frame(height:30)
                    .background(BlurView())
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocues)
                    .submitLabel(.send)
                    .onSubmit({
                        //TODO: SEND THE COMMENT
                    })
            }
            .frame(height: 30)
        }
        .padding(5)
        
        
    }
    
}

struct PostInfoView : View {
//    @Binding var offset: CGFloat
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
//
//struct ScrollViewOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGPoint = .zero
//
//    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//        value = nextValue()
//    }
//
//    typealias Value = CGPoint
//
//}
//
//struct ScrollViewOffsetModifier: ViewModifier {
//    let coordinateSpace: String
//    @Binding var offset: CGFloat
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            GeometryReader { proxy in
//                let x = proxy.frame(in: .named(coordinateSpace)).minX
//                let y = proxy.frame(in: .named(coordinateSpace)).minY
//                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
//            }
//        }
//        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//            offset = value.y
//        }
//    }
//}
//
//extension View {
//    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGFloat>) -> some View {
//        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
//    }
//}
