//
//  BottomLineViewStyle.swift
//  Trident
//
//  Created by bawn on 2020/02/11.
//  Copyright © 2020 bawn. All rights reserved.( http://bawn.github.io )
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

public enum BottomLineStyle {
    case backgroundColor(UIColor)
    case height(CGFloat)
    case hidden(Bool)
}


public class BottomLineViewStyle {
    
    public var backgroundColor = UIColor.black.withAlphaComponent(0.15) {
        didSet {
            targetView?.backgroundColor = backgroundColor
        }
    }
    
    public var height: CGFloat = 0.5 {
        didSet {
            targetViewHeight?.constant = height
        }
    }
    
    public var hidden = false {
        didSet {
            targetView?.isHidden = hidden
        }
    }
    
    weak var targetView: UIView? {
        didSet {
            targetView?.translatesAutoresizingMaskIntoConstraints = false
            targetView?.backgroundColor = backgroundColor
            targetView?.isHidden = hidden
            targetViewHeight = targetView?.heightAnchor.constraint(equalToConstant: height)
        }
    }
    
    private var targetViewHeight: NSLayoutConstraint?
    public init(view: UIView) {
        targetView = view
    }
    
    public init(parts: BottomLineStyle...) {
        for part in parts {
            switch part {
            case .backgroundColor(let color):
                backgroundColor = color
            case .height(let value):
                height = value
            case .hidden(let value):
                hidden = value
            }
        }
    }

}
