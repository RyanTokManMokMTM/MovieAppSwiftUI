//
//  UIScrollView+Additional.swift
//  Aquaman
//
//  Created by bawn on 2018/12/12.
//  Copyright © 2018 bawn. All rights reserved.( http://bawn.github.io )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit


private struct AssociatedKeys {
    static var AMIsCanScroll = "AMIsCanScroll"
    static var AMOriginOffset = "AMOriginOffset"
}

extension UIScrollView {
    internal var am_isCanScroll: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.AMIsCanScroll) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AMIsCanScroll, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var am_originOffset: CGPoint? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.AMOriginOffset) as? CGPoint
        }
        set {
            guard am_originOffset == nil else {
                return
            }
            objc_setAssociatedObject(self, &AssociatedKeys.AMOriginOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}



extension Optional where Wrapped == CGPoint{
    var val: CGPoint{
        if let v = self{
            return v
        }
        else{
            return .zero
        }
    }
}


extension Optional where Wrapped == UIScrollView{
    var offset: CGPoint{
        if let v = self?.am_originOffset.val{
            return v
        }
        else{
            return .zero
        }
    }
}






extension UIView{
    
    
    func addSubs(_ views: [UIView]){
        views.forEach(addSubview(_:))
    }
 
    
    
}
