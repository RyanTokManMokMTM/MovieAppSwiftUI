//
//  ImageCropVIew.swift
//  IOS_DEV
//
//  Created by Jackson on 25/1/2022.
//

import SwiftUI

struct ImageCropVIew: View {
    @State var imageWidth:CGFloat = 0
    @State var imageHeight:CGFloat = 0
    
    @Binding var isCropping:Bool
    
    @State var croppingOffset = CGSize(width: 0, height: 0)
    @State var croppingMagnification:CGFloat = 1
    
    var image : UIImage
    @Binding var croppedImage:UIImage

    var body: some View {
        ZStack(alignment:.bottom){
            Color.black.edgesIgnoringSafeArea(.all)
                .zIndex(0)
            
            VStack{
                ZStack{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .overlay(GeometryReader{porxy -> AnyView in
                            DispatchQueue.main.async{
                                self.imageWidth = porxy.size.width
                                self.imageHeight = porxy.size.height
                            }
                            return AnyView(EmptyView())
                        })
                    
                    ImageCropping(imageWidth: self.$imageWidth, imageHeight: self.$imageHeight, finalOffset: $croppingOffset, finalMagnification: $croppingMagnification)
                }
                .padding()
                
                
                
            }
            .ignoresSafeArea()
            .background(Color.black)
            .zIndex(1)
            
            HStack{
                Button(action:{
                    isCropping = false
                }){
                    Text("取消")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action:{
                    let cgImage: CGImage = image.cgImage!
                    print("image: \(cgImage.width) x \(cgImage.height)")
                    let scaler = CGFloat(cgImage.width)/imageWidth
                    let dim:CGFloat = getDimension(w: CGFloat(cgImage.width), h: CGFloat(cgImage.height))
                    
                    let xOffset = (((imageWidth/2) - (getDimension(w: imageWidth, h: imageHeight) * croppingMagnification/2)) + croppingOffset.width) * scaler
                    let yOffset = (((imageHeight/2) - (getDimension(w: imageWidth, h: imageHeight) * croppingMagnification/2)) + croppingOffset.height) * scaler
                    print("xOffset = \(xOffset)")
                    let scaledDim = dim * croppingMagnification
                    
                    
                    if let cImage = cgImage.cropping(to: CGRect(x: xOffset, y: yOffset, width: scaledDim, height: scaledDim)){
                        croppedImage = UIImage(cgImage: cImage)
                        isCropping = false
                    }

                }){
                    Text("完成")
                        .foregroundColor(.white)
                }
            }
            .zIndex(2)
        }
        
    }
}

//struct ImageCropVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCropVIew()
//    }
//}
