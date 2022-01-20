//
//  personProfile.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 13/1/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct mainPersonView : View{
    var body: some View{
        GeometryReader{proxy in
            let topEdge = proxy.safeAreaInsets.top
            personProfile(topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}


let listURL : [URL] = [
    URL(string: "https://www.themoviedb.org/t/p/original/aaczVLsEYSHQzHUYr69bTMRA4CI.jpg")!,
    URL(string: "https://www.themoviedb.org/t/p/original/vFQXJ7BH052XXoJBs03oAZBwCIu.jpg")!,
    URL(string: "https://www.themoviedb.org/t/p/original/91pB7MxquMeFbeMHamslCKk5wNZ.jpg")!,
    URL(string: "https://www.themoviedb.org/t/p/original/91pB7MxquMeFbeMHamslCKk5wNZ.jpg")!,
    URL(string: "https://www.themoviedb.org/t/p/original/91pB7MxquMeFbeMHamslCKk5wNZ.jpg")!,
    URL(string: "https://www.themoviedb.org/t/p/original/91pB7MxquMeFbeMHamslCKk5wNZ.jpg")!
]

let listName : [String] = [
    "Disney 動畫電影!",
    "我最愛的科幻片💗",
    "愛了!",
    "愛了!",
    "愛了!",
    "愛了!"
]

struct profileCardCell : View {
    var url : URL
    var name : String
    var body: some View{
        VStack(alignment:.center){
            WebImage(url:  url)
                .placeholder(Image(systemName: "photo")) //
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(height:230)
                .clipShape(CustomeConer(width: 5, height: 5, coners: [.topLeft,.topRight]))

            Group{
    
                HStack{
                    Text(name)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.vertical,5)
                .font(.system(size: 15))
//                .frame(width:150,alignment: .center)
                
                HStack{
                    HStack(spacing:5){
                        Image("image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25, alignment: .center)
                            .clipShape(Circle())
                            
                        VStack(alignment:.leading){
                            Text("Jackson.tmm").bold()
                                .font(.caption)
                                .foregroundColor(Color("subTextGray"))
                            
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing:5){
                        Image(systemName: "heart")
                            .imageScale(.small)
                        
                        Text("0")
                            .foregroundColor(Color("subTextGray"))
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal,8)
            
        }
        .padding(.bottom,5)
        .background(Color("MoviePostColor").cornerRadius(5))
        .padding(.horizontal,2)
    }
}

struct testGridView : View{
    let gridItem = Array(repeating: GridItem(.flexible(),spacing: 5), count: 2)
    var body: some View{
        LazyVGrid(columns: gridItem){
            ForEach(0..<listURL.count){i in
                profileCardCell(url: listURL[i],name: listName[i])
            }
        }
    }
}

struct personProfile: View {
    private let max = UIScreen.main.bounds.height / 2.5
    var topEdge : CGFloat
    @State private var offset:CGFloat = 0.0
    @State private var menuOffset:CGFloat = 0.0
    @State private var isShowIcon : Bool = false
    var body: some View {
//
        ZStack(alignment:.top){
            VStack(alignment:.center){
                Spacer()
                HStack{
                    Image("image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30, alignment: .center)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .transition(.move(edge: .bottom))
            .offset(y:self.isShowIcon ? 0 : 40)
            .padding(.trailing,20)
            .frame(width:UIScreen.main.bounds.width ,height: topEdge)
            .padding(.top,30)
            .zIndex(10)
            .clipped()
            
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing:0){
                        GeometryReader{ proxy  in
                            ZStack(alignment:.top){
                                Image("bg")
                                    .resizable()
                                    .aspectRatio( contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
                                    .overlay(
                                        LinearGradient(colors: [
                                            Color("PersonCellColor").opacity(0.3),
                                            Color("PersonCellColor").opacity(0.6),
                                            Color("PersonCellColor").opacity(0.8),
                                            Color("PersonCellColor"),
                                            Color.black
                                        ], startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width, height: offset > 0 ? offset + max + 20 : getHeaderHigth() + 20, alignment: .bottom)
                                    )
                                    .zIndex(0)
                                
                                
                                profile()
                                    .frame(maxWidth:.infinity)
                                    .frame(height:  getHeaderHigth() ,alignment: .bottom)
                                    .overlay(
                                        ZStack{
                                            HStack{
                                                Button(action:{}){
                                                    Image(systemName: "line.3.horizontal")
                                                        .foregroundColor(.white)
                                                        .font(.title2)
                                                }
                                                Spacer()
                                            }
                                                .padding(.horizontal)
                                                .frame(height: topEdge)
                                                .padding(.top,30)
                                                .zIndex(1)
                                            

                                        }
                                        .background(Color("ResultCardBlack").opacity(getOpacity()))
                                        ,alignment: .top
                                    )
                                    .zIndex(1)
                            }
                        }
                        .frame(height:max)
                        .offset(y:-offset)
                        
                    
                    VStack(spacing:0){
                        HStack(spacing:20){
                            VStack(spacing:3){
                                Text("Collects")
                                RoundedRectangle(cornerRadius: 25, style: .circular)
                                    .fill(.orange)
                                    .frame(width: 25, height: 3)
                            }

                            VStack(spacing:3){
                                Text("Posts")
                                    .foregroundColor(Color("subTextGray"))
                                RoundedRectangle(cornerRadius: 25, style: .circular)
                                    .fill(.orange)
                                    .frame(width: 25, height: 3)
                                    .opacity(0)
                            }

                            VStack(spacing:3){
                                Text("Like")
                                    .foregroundColor(Color("subTextGray"))
                                RoundedRectangle(cornerRadius: 25, style: .circular)
                                    .fill(.orange)
                                    .frame(width: 25, height: 3)
                                    .opacity(0)
                            }

                        }
                        .frame(width:UIScreen.main.bounds.width,height:80)
                        .font(.system(size: 15))
                        .frame(height:UIScreen.main.bounds.height / 18)
                        .background(Color("PersonCellColor").clipShape(CustomeConer(width:15,coners: [.topLeft,.topRight])))
         
                        
                        Divider()
                    }
                    .offset(y:self.menuOffset < 77 ? -self.menuOffset + 77: 0)
                    .overlay(
                        GeometryReader{proxy -> Color in
                            let minY = proxy.frame(in: .global).minY
                
                            DispatchQueue.main.async {
                                self.menuOffset = minY
                            }
                            return Color.clear
                        }

                    )
                    testGridView()
                        .zIndex(-1)
                    
                }
                .modifier(PersonPageOffsetModifier(offset: $offset,isShowIcon:$isShowIcon))
            }
            .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
            
        }

    }
    
    @ViewBuilder
    func profile() -> some View{
        VStack(alignment:.leading){
            Spacer()
            HStack(alignment:.center){
                Image("image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                    .overlay(
                        HStack{
                            Image(systemName: "plus")
                                .imageScale(.small)
                        }
                            .frame(width: 20, height: 20)
                            .background(Color.orange)
                            .clipShape(Circle())
                            ,alignment: .bottomTrailing
                    )

                VStack(alignment:.leading){
                    Text("Jackson.tmm").bold()
                        .font(.title2)
                    Text("mid:000000001")
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(0.8))
                    
                }
                
                Spacer()
            }
                .padding(.bottom)
            
            HStack(){
                Text("歡迎來到我的個人頁面.")
                    .font(.footnote)
                    .lineLimit(3)
            }
            
            HStack{
                Text("喜劇")
                    .font(.caption)
                    .padding(8)
                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                Text("動畫")
                    .font(.caption)
                    .padding(8)
                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                Text("驚悚")
                    .font(.caption)
                    .padding(8)
                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                
            }
            .padding(.top,5)
            
            HStack{
                VStack{
                    Text("0")
                        .bold()
                    Text("Following")
                }
                
                VStack{
                    Text("0")
                        .bold()
                    Text("Followers")
                }

                
                VStack{
                    Text("0")
                        .bold()
                    Text("Likes")
                }
                
                Spacer()
                
                Button(action:{
                    //TODO : Edite data
                }){
                    Text("Edit Profile")
                        .padding(8)
                        .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                }
                .foregroundColor(.white)

                Button(action:{
                    //TODO : Edite data
                }){
                    Image(systemName: "gearshape")
                        .padding(.horizontal,5)
                        .padding(8)
                        .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                }
                .foregroundColor(.white)

            }
            .font(.footnote)
            .padding(.vertical)
        
        }
        .padding(.horizontal)
        
    }

    
    private func getHeaderHigth() -> CGFloat{
        //setting the height of the header
        
        let top = max + offset
        //constrain is set to 80 now
        // < 60 + topEdge not at the top yet
        return top > (40 + topEdge) ? top : 40 + topEdge
    }
    
    private func getOpacity() -> CGFloat{
        let progress = -(offset + 40 ) / 70
        return -offset > 40  ?  progress : 0
    }
    

}


struct personProfile_Previews: PreviewProvider {
    static var previews: some View {
        testCell()
    }
}


struct testCell : View{
    @State private var offset:CGFloat = 0.0
    var body: some View{
        VStack(){
            HStack(spacing:20){
                
                VStack{
                    Text("Posts")
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.orange)
                        .frame(width: 25, height: 5)
                }
                
                
                Text("Collects")
                    .foregroundColor(Color("subTextGray"))
                
                Text("Like")
                    .foregroundColor(Color("subTextGray"))
            }
            .frame(width:UIScreen.main.bounds.width)
            .font(.system(size: 15))
            .frame(height:UIScreen.main.bounds.height / 18)
            .background(Color("PersonCellColor").clipShape(CustomeConer(coners: [.topLeft,.topRight])))
            .padding(.bottom,5)
            .zIndex(1)
            
            Spacer()
            
            VStack{
                Spacer()
                Text("You have't post any post yet")
                    .font(.footnote)
                    .foregroundColor(Color("subTextGray"))
                Spacer()
            }
            .zIndex(0)
            
        }
        frame(height: UIScreen.main.bounds.height)
        .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace
        .background(Color.black.clipShape(CustomeConer(coners: [.topLeft,.topRight])))
        
    }
}
