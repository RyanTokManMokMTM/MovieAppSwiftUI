//
//  TextFieldWithLineBorder.swift
//  new
//
//  Created by Jackson on 23/2/2021.
//

import SwiftUI


struct HorizontalLineShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))
        
        return path
    }
}

struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 1.0
    
    init(color: Color, height: CGFloat = 1.0) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}

struct TextFieldWithLineBorder: View {
    @Binding var text: String
    var placeholder = ""
    private let lineThickness = CGFloat(2.0)
    
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
            HorizontalLine(color: .white)
        }.padding(.bottom, lineThickness)
    }
}

struct SeruceFieldWithLineBorder: View {
    @Binding var text: String
    var placeholder:String = ""
    private let lineThickness = CGFloat(2.0)
    
    
    var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
            HorizontalLine(color: .white)
        }.padding(.bottom, lineThickness)
    }
}



struct TextFieldWithLineBorder_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLineBorder(text: .constant(""), placeholder: "test")
    }
}
