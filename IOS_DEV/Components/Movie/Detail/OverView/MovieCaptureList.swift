//
//  MovieCaptureList.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieCaptureList: View {
    var CaptureList:[MovieCapture]
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing:15){
                ForEach(0..<CaptureList.count){i in
                    Capture(capture: CaptureList[i])
                        .frame(width: 270, height: 180)
                    
                }
            }
        }
    }
}

struct MovieCaptureList_Previews: PreviewProvider {
    static var previews: some View {
        MovieCaptureList(CaptureList: CaptureLists)
    }
}

struct Capture:View{
    var capture:MovieCapture
    var body:some View{
        VStack{
            WebImage(url: URL(string:capture.CaptureImage))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)

                )
        }

    }
}
