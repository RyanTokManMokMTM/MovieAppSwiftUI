//
//  SearchBar.swift
//  new
//
//  Created by 張馨予 on 2021/3/19.
//

import SwiftUI

struct SearchBar: View
{
    @Binding var text: String

    @State private var isEditing = false

    var body: some View
    {
        HStack
        {

            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack
                    {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)

                        if isEditing
                        {
                            Button(action:{
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 3)
                            }
                        }
                    }
                )
                .padding(.horizontal, 5)
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing
            {
                Button(action: {
                    self.isEditing = false
                    self.text = ""

                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 2)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(0)
    }
}

struct SearchBar_Previews: PreviewProvider
{
    static var previews: some View
    {
        SearchBar(text: .constant(""))
            //.padding(.top, -50)
    }
}
