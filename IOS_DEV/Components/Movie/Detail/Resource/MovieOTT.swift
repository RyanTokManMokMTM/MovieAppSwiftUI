//
//  MovieOTT.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/24.
//


import SwiftUI
import SafariServices


struct MovieOTT: View {

    let movieTitle: String
    @ObservedObject private var movieResourceState = MovieResourceState()

    var body: some View {
        VStack {
            if self.movieResourceState.isLoading || self.movieResourceState.error != nil{
                LoadingView(isLoading: self.movieResourceState.isLoading, error: self.movieResourceState.error) {
                    self.movieResourceState.fetchMovieResource(query:movieTitle )
                }
                
            }else if self.movieResourceState.resource != nil {
                if self.movieResourceState.resource!.isEmpty {
                   Text("No resources.")
               } else {
                   MovieOTTView(OTT: self.movieResourceState.resource!)
               }
            }
            
        }
        .onAppear {
            self.movieResourceState.fetchMovieResource(query: movieTitle)
        }
    }
}



struct MovieOTTView:View {
    
    let OTT: [ResourceResponse]
    @State private var selected: ResourceResponse?
    let FullSize = UIScreen.main.bounds.size
    var columns = Array(repeating: GridItem(.flexible(),spacing:12), count: 3)
    
    var body: some View {

        VStack{
            
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(OTT, id:\.ott) { resource in
                    Button(action: {
                        self.selected = resource
                    }) {
                     
                        Link(destination: URL(string: resource.result[0].href)!){
                            VStack {
                                Image("\(resource.ott)")
                                        .resizable()
                                        .frame(width: FullSize.width/3.5, height: FullSize.width/3.5)
                                            .cornerRadius(30)
                                    
                                HStack{
                                    Text(resource.ott)
                                        .foregroundColor(Color(.white))
                                        .font(.system(size: 16))
                                    
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(Color(.gray))
                                }
                                .frame(width: FullSize.width/3.5, height: 60)
                            }
                            .padding()

                        }
                        
//                        Spacer()
//
//                        Divider()
//                            .background(Color.gray)
                    }
                }
            }
  
            
            Spacer(minLength: 80)
    
        }
//        .sheet(item: self.$selected) { resource in
//            SafariView(url: URL(string: resource.result[0].href)!)
//
//        }

        
    }
}

