//
//  MoviePosterCard.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/8.
//


import SwiftUI

struct MoviePosterCard: View {
    
    let movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack(alignment:.center,spacing:8){
            
            //image
            ZStack {
                if self.imageLoader.image != nil {
                    let poster = resizeImage(image: self.imageLoader.image!, width: 145)
                    
                    Image(uiImage: poster)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.pink, lineWidth: 1)
                        )
                        .padding(.horizontal,8)
                        .shadow(color: Color.secondary, radius: 2, x: 0, y: 0 )
                    
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .frame(width: 145, height: 225, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                      
                    
                    Text(movie.title)
                        .multilineTextAlignment(.center)
                }
                
                
            }
            .frame(width: 145, height: 225)
            .onAppear {
                self.imageLoader.loadImage(with: self.movie.posterURL)
            }
           
            
            
            //title
            Text(movie.title)
                .bold()
                .foregroundColor(.purple)
                .frame(width:150,height:30)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            //star
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundColor(.yellow)
                }
                Text(movie.scoreText)
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

func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height:
            image.size.height * width / image.size.width)
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { (context) in
            image.draw(in: renderer.format.bounds)
        }
        return newImage
}
