//
//  BlurView.swift
//  IOS_DEV
//
//  Created by Jackson on 5/8/2021.
//

import SwiftUI
import UIKit

struct BlurView : UIViewRepresentable {
    var sytle : UIBlurEffect.Style = .systemMaterialDark
    func makeUIView(context: Context) -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: UIBlurEffect(style: sytle))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //TO UPDATE
    }
}
