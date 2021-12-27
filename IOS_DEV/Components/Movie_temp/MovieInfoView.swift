//
//  MovieInfoView.swift
//  IOS_DEV
//
//  Created by Jackson on 1/5/2021.
//

import SwiftUI

struct MovieInfoView: View {
    var movie : Movie
    var body: some View {
        HStack {
            VStack(alignment:.leading,spacing:5){
                Text("MORE INFORMATION")
                    .bold()
                    .font(.title2)

                HStack(alignment: .top, spacing: 4) {
                    
                
               
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("Genre").font(.headline)
                        Text(movie.genreText)
                            .foregroundColor(.white)
                        
                        Spacer()
                        Text("Release Date").font(.headline)
                        Text(movie.releaseDate!)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Movie Time").font(.headline)
                        Text(movie.durationText)
                            .foregroundColor(.white)
                       
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()

               
                  
                
                   
                    //actor
//                    if movie.cast != nil && movie.cast!.count > 0 {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Starring").font(.headline)
//                            ForEach(self.movie.cast!.prefix(9)) { cast in
//                                Text(cast.name)
//                            }
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                        Spacer()
//
//                    }
                    
                    
                    
                    if movie.crew != nil && movie.crew!.count > 0 {
                        VStack(alignment: .leading, spacing: 4) {
                            if movie.directors != nil && movie.directors!.count > 0 {
                                Text("Director(s)").font(.headline)
                                ForEach(self.movie.directors!.prefix(2)) { crew in
                                    Text(crew.name)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            if movie.producers != nil && movie.producers!.count > 0 {
                                Text("Producer(s)").font(.headline)
                                    .padding(.top)
                                ForEach(self.movie.producers!.prefix(2)) { crew in
                                    Text(crew.name)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                                Text("Screenwriter(s)").font(.headline)
                                    .padding(.top)
                                ForEach(self.movie.screenWriters!.prefix(2)) { crew in
                                    Text(crew.name)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    
                }.padding()
                .foregroundColor(.gray)
                
                
                

                
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical)
    }
}

struct MovieInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            MovieInfoView(movie: stubbedMovie[0])
                
        }
        
    }
}
//
//
//struct temp{
//    let releaseDate:String
//    let movieTime:String
//    let movieLanguage:String
//    let cast:[String]
//    let director:[String]
//    let restrictedLevel:String
//    let region:String
//    let company:String
//}
//
//let tempData = temp(releaseDate: "12-12-2020", movieTime: "162mins", movieLanguage: "English", cast: ["Jackson","Tome","Jack","Amy"], director: ["test1","test2","test3"], restrictedLevel:"16+" , region: "US", company: "Marval")
