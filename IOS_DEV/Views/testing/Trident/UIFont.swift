//
//  UIFont.swift
//  Trident
//
//  Created by bawn on 2020/3/17.
//  Copyright © 2020 bawn. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    var weightValue: Float {
        guard let value = traits[.weight] as? NSNumber else {
            return 0
        }
        return value.floatValue
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
    }
}





extension UIView{
    
    func addSubs(_ views: UIView...){
        views.forEach(addSubview(_:))
    }


}
