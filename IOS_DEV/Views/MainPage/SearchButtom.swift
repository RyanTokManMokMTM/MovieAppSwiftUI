//
//  SearchButtom.swift
//  IOS_DEV
//
//  Created by 張馨予 on 2021/5/18.
//

import SwiftUI

struct SearchButtom: View
{
    var ImageName:String = ""
    
    var body: some View
    {
        Button(action: {print("test")})
        {
            HStack()
            {
                Image(ImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 105)
                
            }
            .frame(width: 100, height: 105, alignment: .leading)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 2, x: 1.0, y: 1.0)
            .padding(.horizontal, 10)
        }
        .foregroundColor(.black)
    }
}

struct SearchButtom_Previews: PreviewProvider
{
    static var previews: some View
    {
        SearchButtom(ImageName: "wa")
    }
}
