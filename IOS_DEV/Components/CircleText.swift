//
//  CircleText.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//

import SwiftUI
import Foundation

struct CircleText: View {
    var radius: Double //circle radius
    var text: String //input text
    var kerning: CGFloat = 5.0 //spacing of character
    var width : CGFloat = 300.0
    var height : CGFloat = 300.0
    
    //split our stirng to array
    private var texts: [(offset: Int, element:Character)] {
        return Array(text.enumerated())
    }
    
    @State var textSizes: [Int:Double] = [:]
    
    var body: some View {
        ZStack {
            ForEach(self.texts, id: \.self.offset) { (offset, element) in
                VStack {
                    Text(String(element))
                        .bold()
                        .font(.system(size: 9))
                        .kerning(self.kerning)
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                            self.textSizes[offset] = Double(size)
                        })
                        .foregroundColor(.white)
                        
                    Spacer()
                        
                }
                .rotationEffect(self.angle(at: offset))
                
                
            }
        }
        .rotationEffect(-self.angle(at: self.texts.count-1)/2)
        .frame(width: width, height: height, alignment: .center)
    }
    
    //calculate angle of each character
    private func angle(at index: Int) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        
        
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        
        return .radians(angleForPreChars + labelAngle)
    }
    
}



//circle perimeter
extension Double {
    var perimeter: Double {
        return self * 2 * .pi
    }
}


//Get size for label helper
//Getting Character width
struct WidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct CircleText_Previews: PreviewProvider {
    static var previews: some View {
        CircleText(radius: 200, text: "Avenger:EndGame",kerning: 80.0,width: 100,height: 100)
            
            
    }
}


