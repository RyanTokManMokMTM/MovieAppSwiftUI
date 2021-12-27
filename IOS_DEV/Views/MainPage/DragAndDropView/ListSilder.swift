//
//  ListSilder.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI

struct ListSilder<Content:View, T:Identifiable> : View{
    var content : (T) -> Content
    var list :[T]

    var spacing :CGFloat
    var trailingSpace : CGFloat
    @Binding var index : Int

    init(spacing:CGFloat = 15.0,trailingSpace:CGFloat = 100,index : Binding<Int>,items:[T],@ViewBuilder content : @escaping (T)->Content){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }

    @GestureState private var offestCard : CGFloat = 0.0
    @State private var currentIndex : Int = 0

    var body : some View{
        GeometryReader{proxy in
            let currentWidth = proxy.size.width - (self.trailingSpace - self.spacing)
            let adjWidth = (self.trailingSpace / 2) - spacing //only affect none 0th
            HStack(spacing:self.spacing){
                ForEach(list){post in
                    content(post)
                        .frame(width:proxy.size.width - trailingSpace)
                        .offset(y:getOffset(item : post,width : currentWidth))
                }

            }
            //padding horizontal
            .padding(.horizontal,spacing)
            .offset(x: (CGFloat(currentIndex) * -currentWidth) + (self.currentIndex != 0 ? adjWidth : 0) + offestCard) //offset the card + index *total width for each card
            .scaleEffect()
            .gesture(
                DragGesture()
                    .updating($offestCard, body: {(value,out,_) in
                        out = value.translation.width

                    })
                    .onEnded({value in
                        //calculating the offset
                        let offsetX = value.translation.width
                    //    print(offsetX)
                        //value of offset of the total width and round 0 to 1
                        let totalOffset = -offsetX / currentWidth

                        //get the index
                        let roundInt = totalOffset.rounded()
                    //    print(roundInt)
                        //add to currentIndx
                        //lmit the bounds of index 0- list-1
                        currentIndex = max(min(Int(currentIndex) + Int(roundInt),list.count - 1),0)

                        currentIndex = index
                    })
                    .onChanged{value in
                        //calculating the offset
                        let offsetX = value.translation.width
                    //    print(offsetX)
                        //value of offset of the total width and round 0 to 1
                        let totalOffset = -offsetX / currentWidth

                        //get the index
                        let roundInt = totalOffset.rounded()
                    //    print(roundInt)
                        //add to currentIndx
                        //lmit the bounds of index 0- list-1
                        index = max(min(Int(currentIndex) + Int(roundInt),list.count - 1),0)

                    }
            )

        }
        .animation(.easeInOut,value: offestCard == 0)
    }
    
    private func getOffset(item : T,width:CGFloat) -> CGFloat{
        //current Index item offset up tp 60
        // current Index value times 60
        let currentProgress = ((self.offestCard < 0 ? offestCard : -offestCard) / width) * 60
        
        //let currentProgress to positive
        
        //if top offset is less than  60 -> currentProgress else -currentProgress
        let topOffset = -currentProgress < 60 ? currentProgress : -(currentProgress + 120)
        
        let previous = getIndex(item: item) - 1 == currentIndex ? (self.offestCard < 0 ? topOffset : -topOffset)  : 0
        let next = getIndex(item: item) + 1 == currentIndex ? (self.offestCard < 0 ? -topOffset : topOffset) : 0
        
        //if current index between 0 and count-1
        let check = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next): 0
//        print("pre :\(previous)")
//        print("next :\(next)")
//        print("check :\(check)")
        return getIndex(item: item) == currentIndex ? -60 - topOffset : check
    }
    
    private func getIndex(item : T) -> Int{
        let index = list.firstIndex{ currenItem in
            return currenItem.id == item.id
        } ?? 0
        return index
    }
}



