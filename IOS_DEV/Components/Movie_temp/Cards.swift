//
//  SwiftUIView.swift
//  new
//
//  Created by 張馨予 on 2021/1/28.
//

import SwiftUI
 
let screen = UIScreen.main.bounds //取得螢幕尺寸
 
//
//struct Section: Identifiable {
//    var id = UUID()
//    var title: String
//    var text: String
//    var logo: String
//    var image: Image
//    var color: Color
//}
//
//
//let sectionData1 = Section(
//    title: "劉以豪",
//    text: "高淇淇老公",
//    logo: "豪",
//    image: Image("hh"),
//    color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
//)
//let sectionData2 = Section(
//    title: "易烊千璽",
//    text: "Jackson的好朋友",
//    logo: "璽",
//    image: Image("ja"),
//    color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
//)
//
//let sectionData3 = Section(
//    title: "劉以豪",
//    text: "高淇淇老公",
//    logo: "豪",
//    image: Image("hh"),
//    color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
//)
//
//
//let sectionData = [sectionData1,sectionData2,sectionData3]
//
//struct SectionView: View
//{
//    var section: Section
//
//    var body: some View
//    {
//        VStack
//        {
//            HStack(alignment: .top)
//            {
//                Text(section.title)
//                    .font(.system(size: 24, weight: .bold))
//                    .frame(width: 160, alignment: .leading)
//                    .foregroundColor(.black)
//                Spacer()
//                //Image(section.logo)
//            }
//
//            Text(section.text.uppercased())
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .foregroundColor(.black)
//
//            section.image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 210)
//        }
//        .padding(.top, 30)
//        .padding(.horizontal, 20)
//        .frame(width: 275, height: 570)
//        .background(section.image)
//        .cornerRadius(30)
//        .shadow(color: section.color.opacity(0.7), radius: 5, x: 0, y: 5)
//    }
//}
 
struct CardScroll: View{
    @Binding var isCardSelectedMovie:Bool
    private func getScale(geo : GeometryProxy)->CGFloat{
        var scale:CGFloat = 1.0
        let x = geo.frame(in: .global).minX
        
        let newScale = abs(x)
        if newScale < 100{
            scale = 1 + (100 - newScale) / 500
        }
        
        return scale
    }
    
    var body: some View
    {
        
        ScrollView(.horizontal, showsIndicators: false)
        {
            HStack(spacing: 30)
            {
//                ForEach(0..<morelist.count) { item in
                    GeometryReader { proxy in
                        let scaleValue = getScale(geo: proxy)

                        MovieCoverStack(isCardSelectedMovie: $isCardSelectedMovie, movies: morelist[0])
                                .rotation3DEffect(Angle(degrees:Double(proxy.frame(in: .global).minX - 30)  / -20), axis: (x: 0, y: 20.0, z: 0))
                                .scaleEffect(CGSize(width: scaleValue, height: scaleValue))
                            .onTapGesture {
                                withAnimation(){
                                    
                                    self.isCardSelectedMovie.toggle()
                                    
                                }
                                
                            }
                        
//
//                            Text(proxy.frame(in: .global).minX.description)
//                                .bold()
//                                .padding()
//
                        
                    }
                    .frame(width: 275)
//                }//for
                
                
            }
            .padding(.vertical,50)
            .padding(.horizontal,28)
            .padding(.top,50)
            
        }
        .frame(height:600)
    }
}
struct CardsView: View
{
    var body: some View
    {

        CardScroll(isCardSelectedMovie: .constant(false))
    }
}
 
 
struct Cards_Previews: PreviewProvider
{
    static var previews: some View
    {
        CardsView()
           .preferredColorScheme(.dark)
    }
}

