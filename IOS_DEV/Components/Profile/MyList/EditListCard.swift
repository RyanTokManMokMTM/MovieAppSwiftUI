//
//  EditListCard.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import SwiftUI

struct EditListCard:View{
    @ObservedObject private var listController = ListController()
    @Binding var editAction: Bool
    @Binding var title:String
    @Binding var listID:UUID?
   

    var body: some View {
        VStack{
            VStack{
                Text("Edit List Title ")
                    .font(.system(size: 20).bold())

                TextField("", text: $title)
                    .font(.system(size: 20))
                    
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            HStack{
                
                Button(action: {
                    self.listController.putList(listID: self.listID! , listTitle: self.title)
                    self.editAction.toggle()
                })
                {
                    Text("Save")
                        .foregroundColor(.blue)
                        .padding()
                    
                }
                .disabled(self.title == "" ? true : false)
                .opacity(self.title == "" ? 0.5 : 1)
            
                
           
                Button(action: {
                    self.editAction.toggle()
                })
                {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                    
                }
            
            }
            
        }
        .padding()
        .frame(width: screenSize.width*0.7, height: screenSize.height*0.24)
        .background(BlurView())
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: editAction ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: .gray.opacity(0.5), radius: 6, x: -9, y: -9)
        
       
    
    }

}
