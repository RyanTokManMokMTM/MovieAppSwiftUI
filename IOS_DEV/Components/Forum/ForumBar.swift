//
//  TopBar.swift
//  new
//
//  Created by 張馨予 on 2021/4/15.
//

import SwiftUI

struct ForumBar: View
{
    @State private var index = 0
    var body: some View
    {
        
            HStack
            {
                Button(action: {self.index=0})
                {
                    Text("Hot")
                        .font(.system(size: index == 0 ? 25 : 20))
                        .foregroundColor(index == 0 ? Color.orange : Color.black.opacity(0.5))
                }
                .padding(30)
                
                Button(action: {self.index=1})
                {
                    Text("Recommand")
                        .font(.system(size: index == 1 ? 25 : 20))
                        .foregroundColor(index == 1 ? Color.orange : Color.black.opacity(0.5))
                }
                
                .padding(30)
            
            }
            .frame(width: 390, height: 55, alignment: .center)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .gray, radius: 2, x: 1.0, y: 1.0)
            .padding(.horizontal,10)
    }
}

struct ForumBar_Previews: PreviewProvider
{
    static var previews: some View
    {
        ForumBar()
    }
}

