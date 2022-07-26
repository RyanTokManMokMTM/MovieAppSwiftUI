//
//  MoviePosterCard.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//


import SwiftUI
import SDWebImageSwiftUI
struct MoviePosterCard: View {
    
    let movie: Movie
//    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack(alignment:.center,spacing:8){
//            ZStack {
//                if self.imageLoader.image != nil {
////                    let poster = resizeImage(image: self.imageLoader.image!, width: 145)
////
////                    Image(uiImage: self.imageLoader.image!)
////                        .aspectRatio(contentMode: .fill)
////                        .cornerRadius(8)
////                        .shadow(radius: 4)
////                        .frame(width: 145, height: 225, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
////                        .overlay(
////                            RoundedRectangle(cornerRadius: 10)
////                                .stroke(Color.pink, lineWidth: 1)
////                        )
////                        .padding(.horizontal,8)
//////                        .shadow(color: Color.secondary, radius: 2, x: 0, y: 0 )
////
////                } else {
////                    Rectangle()
////                        .fill(Color.gray.opacity(0.3))
////                        .cornerRadius(8)
////                        .shadow(radius: 4)
////                        .frame(width: 145, height: 225, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
////                    Text(movie.title)
////                        .multilineTextAlignment(.center)
////                }
//
//
//            }
//            .frame(width: 145, height: 225)
//            .onAppear {
//                self.imageLoader.loadImage(with: self.movie.posterURL)
//            }
            //
            WebImage(url: movie.posterURL)
                .resizable()
                .placeholder {
                    ZStack{
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .frame(maxWidth: 120, maxHeight: 200)
                        Text(movie.title)
                            .multilineTextAlignment(.center)
                            .font(.caption)
                    }
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFill()
                .frame(maxWidth: 120, maxHeight: 200)
                .clipped()
                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.pink, lineWidth: 1)
//                )

            
            
            //title
            Text(movie.title)
                .bold()
                .foregroundColor(.white)
                .frame(width:150,height:30)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            //star
            HStack(spacing:3){
                if (movie.voteAverage)/2 == 0{
                    Text("N/A")
                        .foregroundColor(.white)
                        .font(.caption)
                }else{
                    ForEach(1...5,id:\.self){index in
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(index <= Int(movie.voteAverage)/2 ? .yellow: .gray)
                    }
                    
                    Text("(\(Int(movie.voteAverage)/2).0)")
                        .foregroundColor(.white)
                        .font(.caption)
                }

            }
            
            
            
        }
    }
}
//
//struct MoviePosterCard_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviePosterCard(movie: stubbedMovie[0])
//    }
//}

struct MovieGenreCard : View{
    let genreCard: MovieCardInfo
    let genreTitle : String
    @Binding var isPress : Bool
    var body: some View {
        VStack(alignment:.center,spacing:8){
            WebImage(url: genreCard.posterURL)
                .resizable()
                .placeholder {
                    ZStack{
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                            .shadow(radius: 4)
                           
                        Text(genreCard.title)
                            .multilineTextAlignment(.center)
                            .font(.caption)
                    }
                    .frame(maxWidth: 200, maxHeight: 280)
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFill()
                .frame(maxWidth: 200, maxHeight: 280)
                .clipped()
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation(){
                        self.isPress.toggle()
                    }
                }
            
            Text(genreTitle)
                .bold()
                .font(.body)
                .padding(.vertical)
            
            
        }
    }
}

func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height:
            image.size.height * width / image.size.width)
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { (context) in
            image.draw(in: renderer.format.bounds)
        }
        return newImage
}

func resizeImageWithFixedSize(image: UIImage, width: CGFloat,height : CGFloat) -> UIImage{
    let size = CGSize(width: width, height: height)
    let renderer = UIGraphicsImageRenderer(size: size)
    let newImage = renderer.image { (context) in
        image.draw(in: renderer.format.bounds)
    }
    return newImage
}
