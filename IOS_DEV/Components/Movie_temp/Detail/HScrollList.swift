//
//  HScrollList.swift
//  IOS_DEV
//
//  Created by Jackson on 22/4/2021.
//

import SwiftUI

//GIVEN INFO OF CURRENT MOVIE
/*
 1.RANKING //No Need
 2.RELEASE DAY
 3.MOVIE TIME
 4.Movie Rate
 5.Movie Language
 6.Type
 
 ju
 
 */

struct HScrollList: View {
    var info:Movie
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment:.center,spacing:15){
                
                Spacer()
                
                //DATE
                VStack(spacing:10){
                    Text("RELEASE DATE")
                        .bold()
                    Text(info.releaseDate!)
                        .font(.subheadline)
                        
                }
                .frame(minWidth:80)
 

                Divider()
                    .background(Color.gray)
                
                VStack(spacing:10){
                    Text("TIME")
                        .bold()
                    Text(info.durationText)
                        .font(.subheadline)
                }
                .frame(minWidth:80)
     
                
                Divider()
                    .background(Color.gray)
                
                //LANGUAGE
                VStack(spacing:10){
                    Text("LANGUAGE")
                        .bold()
                    Text(info.originalLanguage)
                        .font(.subheadline)
                }
                .frame(minWidth:80)
               
                
                Divider()
                    .background(Color.gray)
                
                VStack(spacing:10){
                    Text("Year")
                        .bold()
                    Text(info.yearText)
                        .font(.subheadline)
                }
                .frame(minWidth:80)


    
            
            }
            .frame(height: 50)
            .foregroundColor(.gray)
            
        }
        .foregroundColor(.white)
        
        
    }
}

struct HScrollList_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            HScrollList(info:stubbedMovie[0])
        }

    }
}
