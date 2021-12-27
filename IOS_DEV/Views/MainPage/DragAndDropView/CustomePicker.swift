//
//  CustomePicker.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI

struct CustomePicker : View {
    @Binding var selectedTabs : Tab
    @Namespace var animateTab
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "globe")
                    .font(.system(size: 22,weight:.bold))
                    .foregroundColor(self.selectedTabs == .Genre ? .black : .white)
                    .frame(width: 70, height: 35)
                    .background(
                        ZStack{
                            if self.selectedTabs != .Genre {
                                Color.clear
                            }else{
                                Color.white.matchedGeometryEffect(id: "Tab", in: animateTab)
                            }

                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation{
                            self.selectedTabs = .Genre
                        }
                    }

                Image(systemName: "signature")
                    .font(.system(size: 22,weight:.bold))
                    .foregroundColor(self.selectedTabs == .Actor ? .black : .white)
                    .frame(width: 70, height: 35)
                    .background(
                        ZStack{
                            if self.selectedTabs != .Actor {
                                Color.clear
                            }else{
                                Color.white.matchedGeometryEffect(id: "Tab", in: animateTab)
                            }

                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation{
                            self.selectedTabs = .Actor
                        }
                    }

                Image(systemName: "squareshape.controlhandles.on.squareshape.controlhandles")
                    .font(.system(size: 22,weight:.bold))
                    .foregroundColor(self.selectedTabs == .Director ? .black : .white)
                    .frame(width: 70, height: 35)
                    .background(
                        ZStack{
                            if self.selectedTabs != .Director {
                                Color.clear
                            }else{
                                Color.white.matchedGeometryEffect(id: "Tab", in: animateTab)
                            }

                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation{
                            self.selectedTabs = .Director
                        }
                    }
            }
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)
//
//            Text(self.selectedTabs)
//                .bold()
//                .font(.title3)
//                .padding(.vertical,5)
           // Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.vertical,10)

    }

}
