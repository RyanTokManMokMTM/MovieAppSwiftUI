//
//  SignUpInfoDetail.swift
//  new
//
//  Created by Jackson on 26/2/2021.
//

import SwiftUI

struct SignUpInfoDetail: View {
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button(action:{
                   //TODO
                }){
                    HStack(alignment:.lastTextBaseline) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.black.opacity(0.5))
                            .padding(.bottom,20)
                            .padding(.leading)
                        
                        Text("back")
                        Spacer()
                    }
                    .font(.title3)
                }
                
                Spacer()
            }
        }
    }
}

struct SignUpInfoDetail_Previews: PreviewProvider {
    static var previews: some View {
        SignUpInfoDetail()
    }
}
