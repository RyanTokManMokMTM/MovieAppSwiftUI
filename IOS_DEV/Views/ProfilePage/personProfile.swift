//
//  personProfile.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 13/1/2022.
//

import SwiftUI

struct mainPersonView : View{
    var body: some View{
        GeometryReader{proxy in
            let topEdge = proxy.safeAreaInsets.top
            personProfile(topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct personProfile: View {
    private let max = UIScreen.main.bounds.height / 2.7
    var topEdge : CGFloat
    @State private var offset:CGFloat = 0.0
    var body: some View {
//
        ScrollView(.vertical, showsIndicators: false){
              VStack{
                  GeometryReader{ proxy in
                      profile()
                          .frame(maxWidth:.infinity)
                          .frame(height: getHeaderHigth(), alignment: .bottom)
                          .background(
                            Image("bg").overlay(LinearGradient(colors: [
                              Color.black.opacity(0.2),
                              Color.black.opacity(0.6),
                              Color.black,

                          ], startPoint: .top, endPoint: .bottom))
                                .frame(height: getHeaderHigth(), alignment: .bottom)
                          )
                          .overlay(
                            HStack{
                                Button(action:{}){
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                }
                                
                                Spacer()
                            }
                                .padding(.horizontal)
                                .frame(height: 50)
                                .padding(.top,topEdge)
                                .background(Color.red.opacity(getOpacity()))
                            ,alignment: .top
                          )
                  }
                  .frame(height:max)
                  .offset(y:-offset)
                  .zIndex(1)
                  
                  
                  personCell()
                      .zIndex(0)
//                      .frame(height: UIScreen.main.bounds.height - max - 80)
                  
                  
              }
             
              .modifier(PersonPageOffsetModifier(offset: $offset))
        }
        .coordinateSpace(name: "SCROLL") //cotroll relate coordinateSpace

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
                    
                VStack(alignment:.leading){
                    Text("Jackson").bold()
                        .font(.title2)
                    Text("ID:123651239")
                        .font(.caption)
                        .foregroundColor(Color("subTextGray"))
                    
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
                
                Text("Edit Profile")
                    .padding(8)
                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke())
                
                Image(systemName: "gearshape")
                    .padding(.horizontal,5)
                    .padding(8)
                    .background(BlurView(sytle: .systemThickMaterialDark).clipShape(CustomeConer(width: 25, height: 25, coners: .allCorners)))
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke())
            }
            .font(.footnote)
            .padding(.vertical)
        
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func personCell() -> some View{
        VStack(){
            HStack(spacing:20){
                
                Text("Posts")
                
                Text("Collects")
                    .foregroundColor(Color("subTextGray"))
                
                Text("Like")
                    .foregroundColor(Color("subTextGray"))
            }
            .font(.system(size: 15))
//            .foregroundColor(.red)
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height / 18)
            .background(Color("PersonCellColor").clipShape(CustomeConer(coners: [.topLeft,.topRight])))
            .padding(.bottom,5)
            
            Spacer()
            
            VStack{
                ForEach(0..<50){i in
                    Text("\(i)")
                }
//                Spacer()
//                Text("You have't post any post yet")
//                    .font(.footnote)
//                    .foregroundColor(Color("subTextGray"))
//                Spacer()
            }
            .frame(maxHeight:.infinity)
            
        }
        
        .background(Color.black.clipShape(CustomeConer(coners: [.topLeft,.topRight])))
        

    }
    
    
    private func getHeaderHigth() -> CGFloat{
        //setting the height of the header
        
        let top = max + offset
        //constrain is set to 80 now
        // < 80 + topEdge not at the top yet
        return top > (20 + topEdge) ? top : 20 + topEdge
    }
    
    private func getOpacity() -> CGFloat{
        let progress = -offset / 70
        let opcity = 1 - progress
        
        return offset  < 0 ? 1 : opcity
    }
}

struct personProfile_Previews: PreviewProvider {
    static var previews: some View {
        mainPersonView()
    }
}



