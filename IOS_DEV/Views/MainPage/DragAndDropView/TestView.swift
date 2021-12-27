//
//  TestView.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 3/12/2021.
//

import SwiftUI

struct TestView: View {
 
    @State var isShow : Bool = false
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("Detail view here"),isActive: $isShow) {
                Button(action: {
                    self.isShow.toggle()
                }, label: {
                    Text("Testing")
                })
            }
//            .buttonStyle(.plain)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

