//
//  CustomeConer.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI

struct CustomeConer : Shape {
    var width :CGFloat = 30
    var height :CGFloat = 30
    var coners : UIRectCorner

    func path(in rect: CGRect) -> Path {
        //set coner and coner radius
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: coners, cornerRadii: CGSize(width: width, height: height))
        return Path(path.cgPath)
    }
}
