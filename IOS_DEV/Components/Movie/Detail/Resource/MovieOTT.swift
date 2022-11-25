//
//  MovieOTT.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/7/24.
//


import SwiftUI
import SafariServices
import Introspect

struct MovieOTT: View {

    let movieTitle: String
    @Binding var isAbleToScroll : Bool
    @EnvironmentObject var movieResourceState : MovieResourceState

    var body: some View {
        ScrollView(.vertical){
            VStack {
                if self.movieResourceState.isLoading {
                    ActivityIndicatorView()
                        .padding()
                } else if self.movieResourceState.resource != nil {
                    if self.movieResourceState.resource!.isEmpty {
                        VStack{
                            Text("暫無任何資源")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .padding(.vertical)
                   } else {
                       MovieOTTView(OTT: self.movieResourceState.resource!)
                   
                   }
                }
                
            }
        }.introspectScrollView{ scroll in
            scroll.isScrollEnabled = isAbleToScroll
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

