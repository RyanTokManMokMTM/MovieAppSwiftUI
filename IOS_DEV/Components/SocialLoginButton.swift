//
//  SocialLoginButton.swift
//  IOS_DEV
//
//  Created by Jackson on 29/3/2021.
//

import SwiftUI

struct SocialLoginButton: View {
    let screen = UIScreen.main.bounds
    var text:String = "Something"
    var textColor:Color = Color.white
    var button:Color = Color.white
    var image:String = "fb"
    
    var action :()-> Void
    
    var body: some View {
        Button(action: action){
            HStack{
                HStack{
                    //                Spacer()
                    //                HStack{
                    //                    Spacer()
                    
                        Image(image)
                            .resizable()
                            .frame(width: 14, height: 15)
                            .padding(0)
                    
                    //                }
                    //                Spacer()
                    Text(text)
                        .foregroundColor(textColor)
                        .font(.system(size: 19))
                        .fontWeight(.medium)
                    
                    Spacer()
                                    
                }
                .padding(.leading,58)

                
                

            }
            .frame(width:screen.width-100,height: 50)
            .background(button)
            .cornerRadius(30)
            
            
        }
    }
}

struct SocialLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.gray
                .edgesIgnoringSafeArea(.all)
            
            SocialLoginButton(text: "Sign in with Google", textColor: .white, button: .black,image: "icons8-facebook-50 (1)"){
                print("test")
            }
            

        }

    }
}
