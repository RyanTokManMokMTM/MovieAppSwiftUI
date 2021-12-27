//
//  test.swift
//  new
//
//  Created by 張馨予 on 2021/3/18.
//

import SwiftUI

struct test: View
{
    let FullSize = UIScreen.main.bounds.size
    var body: some View
    {
        let FullSize = UIScreen.main.bounds.size
        VStack()
        {
            SearchBar(text: .constant(""))
                .padding(.top, 60)
                .clipped()
                Spacer()
            
            ScrollView(.vertical, showsIndicators: true)
            {
                Spacer()
                
                
                
                HStack()
                {
                    Squsre1(ImageName: "wa", Content: "'孤味'相關文章")
                    Squsre1(ImageName: "wa", Content: "'孤味'相關文章")
                }
                .padding(.bottom)
               
            }
        }
        .ignoresSafeArea(edges: .top)
        .frame(width: FullSize.width, height: FullSize.height)
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            test()
        }
    }
}
