//
//  ListDetailView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/8/2.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI


struct ListDetailView: View
{
//    @ObservedObject private var listController = ListController()
    @State private var currentPage = 0
    @Binding var todo:Bool  //go back ListView
    @State var listDetails:[ListDetail] //片單資訊
    @State var listOwnerPhoto:URL //片單創建者照片
    @State var listOwner:String //片單創建者
    @State var listTitle:String //片單名稱
    @State var listID:UUID? //片單ID
    @State var CreateAction : Bool = false
    @State var EditAction : Bool = false
    @State var DeleteAction : Bool = false
    
    var body: some View {
        
        ZStack{
                
                GeometryReader{ proxy in
                    let size = proxy.size
                    //---------背景圖----------//
                    if !(listDetails).isEmpty {
                        WebImage(url: listDetails[currentPage].posterURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .blur(radius: 50)
                            .edgesIgnoringSafeArea(.all)
                    }
                       
                }
                .ignoresSafeArea()
                .colorScheme(.dark)
                
                
                VStack{
                        
                    VStack{
                        HStack {
                            
                            if listOwner == NowUserName {
                                UpdateButton(CreateAction: self.$CreateAction, EditAction: self.$EditAction, DeleteAction: self.$DeleteAction)
                                    .padding()
                            }
                                
                            
                            Spacer()
                            //---------返回鍵----------//
                            Button(action:{
                                withAnimation(){
                                    self.todo.toggle()
                                }
                            }){
                                ZStack{
                                    Circle()
                                        .frame(width:30,height:30)
                                        .opacity(0.5)
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                }
                                .foregroundColor(.black)

                            }
                        }
              
                    }
                    .padding([.top,.trailing],20)
                    
                  
                    VStack {
                            TabView(selection: $currentPage) {
                                ForEach(0..<listDetails.count) { (index) in
                                    CarouselBodyView(listTitle: listTitle, listOwner:listOwner, listOwnerPhoto: listOwnerPhoto, listDetail: listDetails[index], EditAction: self.$EditAction, DeleteAction: self.$DeleteAction)
                                        
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    
                }
                .fullScreenCover(isPresented: self.$CreateAction, content: {
                    CreateListMovie(CreateAction: self.$CreateAction,listOwner: self.listOwner,listTitle: self.listTitle)
                })
               
                
            
            
            

        }
        
   
 

    }


}


//struct ListDetailView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ListDetailView(todo: .constant(true), listDetails: stubbedListDetail, listOwner: "Chichi", listTitle: "你一定要看")
//    }
//}



struct CarouselBodyView: View
{
    @ObservedObject private var controller = ListDetailController()
    @State var listTitle:String //片單名稱
    @State var listOwner:String //片單創建者
    @State var listOwnerPhoto:URL //片單創建者照片
    @State var listDetail:ListDetail //片單資訊
    @Binding var EditAction : Bool
    @Binding var DeleteAction : Bool
    @State private var todo : Bool = false
    
    var body: some View {
        
        

        GeometryReader { proxy in
            let size = proxy.size
            

            
            VStack(alignment: .leading){
                VStack(alignment: .leading,spacing:10){

                    Text(listDetail.title)
                        .font(.title.bold())
                        .kerning(1.5)

                    Text(listTitle)
                        .kerning(1.2)
                        .font(.body)

                }
                .foregroundColor(.white)
                
                
                ZStack(alignment: .bottom){
                    
                    // movie pic
                    WebImage(url: listDetail.posterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width-40, height: size.height/1.2)
                        .cornerRadius(12)

                 

                    // user card
                    VStack(alignment:.leading, spacing:15){

                        HStack{
                            Text("\(listOwner)的評分")
                                .font(.system(size:18))
                                .kerning(1.5)
                                .foregroundColor(.black)
                            
                            HStack(spacing:0){
                                ForEach(1..<6){ index in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(listDetail.ratetext >= index ? .yellow : .gray)
                                        
                                }

                                    
                            }
                            
                            
                        }
                        
                
                        HStack(spacing:25){
                            
                            
                            WebImage(url: listOwnerPhoto)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                           

                            VStack(alignment: .leading,spacing:6){
                                
                        
                                Text(listDetail.feeling)
                                    .kerning(1.2)
                                    .font(.body)
                                    .foregroundColor(.black)
                            }
                       

                        }



                    }
                    .padding(20)
                    .frame(width: size.width-40)
                    .background(Color.white)
                    .cornerRadius(4)
                    
                    
                }
                .onTapGesture {
                    self.todo.toggle()
                }
                
                
                    
               
               
            }
            .padding(20)
            .fullScreenCover(isPresented: self.$todo, content: {
                GestureDetailVeiw(movieId: listDetail.movie ,navBarHidden: .constant(true), isAction: .constant(false), isLoading: .constant(true),isPresented: self.$todo)
                    .preferredColorScheme(.dark)
            })
            .sheet(isPresented: self.$EditAction ,content: {
                EditListMovie(EditAction: self.$EditAction, current:listDetail,listTitle: listTitle)
            })
            .alert(isPresented: self.$DeleteAction, content: {
                Alert(title: Text("刪除此電影？"),
                      primaryButton: .default(Text("確定"),
                                              action: {controller.deleteListMovie(ListDetailID: listDetail.id!)} ),
                      secondaryButton: .destructive(Text("取消")))

            })
      
           


        }





    }


}



//
//struct ListDetailView: View
//{
//    @Binding var todo:Bool  //go back ListView
//    let imageLoader = ImageLoader()
//    @State var listDetail:[ListDetail] //allow as to remove
//    @State var currentMovie:Movie?
//    @State var movies : [Movie]  //allow as to remove
//    @State var currentList:ListDetail?
//    @State var gestureState = CardGesture.CardGestureState.inactive
//    var body: some View {
//        ZStack(){
//
//
//            ForEach(movies){movie in
//                if self.movies.reversed().firstIndex(where: {$0.id == movie.id}) == 0{
//                    //render the current item as CoverGesture view
//
//                    CardGesture(
//                        DragState: self.$gestureState,
//                        onTapGesture: {},
//                        willEndTranslation: {(translation) in},
//                        EndTranslation: {(direction) in
//                            self.getEndPostion(direction: direction)
//                        }, movie: movie)
//
//                }else{
//                    TheCard(movie: movie)
//                        .frame(width:245)
//                        .scaleEffect( 1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movie.id})!) * 0.03 + self.calculateScale())
//                        .padding(.top,1 - CGFloat(self.movies.reversed().firstIndex(where: {$0.id == movie.id})!) * 16)
//                        .animation(.spring())
//
//                }
//
//            }
//
//
//            GeometryReader{proxy in
//                    Button(action:{
//                        withAnimation(){
//                            self.todo.toggle()
//                        }
//                    }){
//                        ZStack{
//                            Circle()
//                                .frame(width:30,height:30)
//                                .opacity(0.5)
//                            Image(systemName: "xmark")
//                                .foregroundColor(.white)
//                        }
//                        .foregroundColor(.black)
//
//                    }
//                    .position(x: proxy.frame(in: .local).maxX - 40
//                              , y: proxy.frame(in: .local).minY + 10)
//
//                if currentMovie != nil
//                {
//
//                    self.renderCurrentInfo()
//                        .position(x: proxy.frame(in: .local).midX
//                                  , y: proxy.frame(in: .local).minY + 100)
//
//                    Text(self.currentList!.text)
//                        .foregroundColor(.white)
//                        .font(.system(size: 17))
//                        .multilineTextAlignment(.center)
//                        .frame(width:300)
//                        .opacity(self.gestureState.isDragging ? 0 : 1)
//                        .animation(.easeInOut)
//                        .position(x: proxy.frame(in: .local).midX
//                              , y: proxy.frame(in: .local).maxY - 120)
//
//                }
//
//
//            }
//
//
//
//
//        }
//        .background(FullMovieCoverBackground(urlPath: self.currentMovie?.posterPath ?? "/oOZITZodAja6optBgLh8ZZrgzbb.jpg").blur(radius: 50))
//
//    }
//
//
//    func renderCurrentInfo() -> some View{
//        ZStack{
//
//                VStack(spacing:10){
//
//                    Text(currentMovie!.title)
//                        .bold()
//                        .foregroundColor(.white)
//                        .lineLimit(2)
//                        .font(.system(size: 25))
//
//                    Text(self.currentMovie!.ratingText)
//                        .foregroundColor(.yellow)
//                        .font(.system(size: 20))
//
//
//                }
//                .frame(width:300)
//                .multilineTextAlignment(.center)
//                .opacity(self.gestureState.isDragging ? 0 : 1)
//                .animation(.easeInOut)
//
//
//        }
//
//    }
//
//    func getEndPostion(direction:CardGesture.EndTranslationPostion){
//        if direction == .left || direction == .right{
//            //TODO
//            //remove the last movie in array and set current movie
//
//            _ = self.movies.popLast()
//            currentMovie = self.movies.last
//            _ = self.listDetail.popLast()
//            currentList = self.listDetail.last
//
//
//        }
//    }
//
//    func calculateScale()->CGFloat{
//        //when dragging it will affect other card behind
//        return CGFloat(abs(self.gestureState.translation.width / 6000))
//    }
//}

//
//
//struct SearchingResultView : View{
//    /*
//     TODO:
//     Show some result,maybe 10 or more .don't know now
//     Show basic information about the movie
//     User scrollig to show other movie
//     Gestrue event:
//        TabGestrue count 1 = user select this movie ,and show detail
//        TabGestrue count 2 = user like this movie, maybe add to user list
//
//        //Planing
//        TabGestrue count 3 = user don't like the movie, won't show it next time
//        etc..
//
//     */
//
//    @Binding var todo:Bool  //go back ListView
//    @State var listDetail:[ListDetail] //allow as to remove
//    @State var movies : [Movie]  //allow as to remove
//
//
//    var body : some View{
//        TabView(){
//            ForEach(movies , id:\.id){ movie in
//                ResultCardView(movie: movie)
//
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .tabViewStyle(PageTabViewStyle())
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//        .onAppear(perform: {
//            UIScrollView.appearance().alwaysBounceVertical = false
//        })
//        .onDisappear(perform: {
//            UIScrollView.appearance().alwaysBounceVertical = true
//        })
//
//
//    }
//}
//
//struct ResultCardView : View{
//    let movie : Movie
//    let listTemp =  ["Action","Adventure","Science Fiction"]
//    var body : some View{
//        VStack(spacing:10){
//            Text(movie.title)
//                .bold()
//                .font(.headline)
//                .foregroundColor(.white)
//                .padding(.vertical,3)
//                .padding(.top)
//
//            HStack(alignment:.center){
//                ForEach(0..<3){i in
//                        Text(listTemp[i])
//                            .bold()
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .padding(.horizontal,3)
//                        if i != 2{
//                            Circle()
//                                .frame(width: 5, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(.red)
//                        }
//
//                }
//            }
//            .padding(.bottom)
//
//            WebImage(url: movie.posterURL)
//                .resizable()
//                .placeholder{
//                    Text(movie.title)
//                }
//                .indicator(.activity) // Activity Indicator
//                .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                .aspectRatio(contentMode: .fit)
//                .frame(width:UIScreen.main.bounds.width / 1.6)
//                .clipped()
//                .cornerRadius(15)
//                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 6, y: 6)
//                .padding(.bottom)
//
//
//            HStack(alignment:.center){
//                VStack(alignment:.leading,spacing:3){
//                    Text("RELEASE")
//                    Text(movie.releaseDate!)
//                        .font(.system(size: 13))
//                        .foregroundColor(.white)
//
//                }
//
//                Spacer()
//                VStack{
//                    Image(systemName: "play.circle.fill")
//                        .resizable()
//                        .frame(width: 45, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                        .foregroundColor(.red)
//                }
//
//                Spacer()
//
//                VStack(alignment: .trailing, spacing: 3){
//                    Text("PLAY TIME")
//                    Text(movie.durationText)
//                        .font(.system(size: 13))
//                        .foregroundColor(.white)
//                }
//
//            }
//            .foregroundColor(.gray)
//            .font(.caption)
//            .padding(.horizontal,30)
//        }
//        .padding(.vertical)
//        .frame(width:UIScreen.main.bounds.width / 1.2)
//        .background(BlurView().cornerRadius(25))
//
//
//    }
//}
//
//



//            GeometryReader{ proxy in
//                let size = proxy.size
//
//                //---------背景圖----------//
//                Image(currentTab)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: size.width, height: size.height)
//                    .cornerRadius(1)
//                    .blur(radius: 20)
//
//            }
//            .ignoresSafeArea()
//            .colorScheme(.dark)
