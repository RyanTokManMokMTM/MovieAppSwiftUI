//
//  personProfile.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 13/1/2022.
//

import SwiftUI

struct personProfile: View {
    var body: some View {
        VStack{
            
            VStack{
                HStack{
                    Image(systemName: "line.3.horizontal")
                        .imageScale(.large)
                    Spacer()
                }
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom)
                profile()

            }
            .padding(.horizontal)
            .background(Image("bg").blur(radius: 2).overlay(LinearGradient(colors: [
                Color.black.opacity(0.2),
                Color.black.opacity(0.6),
                Color.black,
                
            ], startPoint: .top, endPoint: .bottom)))
            Spacer()
            
            personCell()
                
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func profile() -> some View{
        VStack(alignment:.leading){
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

    }
    
    @ViewBuilder
    func personCell() -> some View{
        VStack(){
            HStack(spacing:15){
                
                Text("Posts")
                
                Text("Collects")
                    .foregroundColor(Color("subTextGray"))
                
                Text("Like")
                    .foregroundColor(Color("subTextGray"))
            }
            .font(.body)
//            .foregroundColor(.red)
            .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height / 22)
            .background(Color("PersonCellColor").clipShape(CustomeConer(coners: [.topLeft,.topRight])))
            .padding(.bottom,5)
            Spacer()
            
            HStack{
                Text("You have't post any post yet")
                    .font(.footnote)
                    .foregroundColor(Color("subTextGray"))
            }
        
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color.black.clipShape(CustomeConer(coners: [.topLeft,.topRight])))

    }
}

struct personProfile_Previews: PreviewProvider {
    static var previews: some View {
        personProfile()
    }
}
