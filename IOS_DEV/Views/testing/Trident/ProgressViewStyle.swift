//
//  ProgressViewStyle.swift
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

public enum SliderPosition {
    case top
    case center
    case bottom
}

public enum SliderShape {
    case line
    case triangle
    case round
}

public enum SliderStyle {
    case backgroundColor(UIColor)
    case originWidth(CGFloat) // only for telescopic switch style
    case elasticValue(CGFloat) // only for telescopic switch style
    case height(CGFloat)
    case extraWidth(CGFloat)
    case cornerRadius(CGFloat)
    case hidden(Bool)
    case position(SliderPosition)
    case shape(SliderShape)
}

public class SliderViewStyle {
    
    public var backgroundColor = UIColor.black {
        didSet {
            targetView?.backgroundColor = backgroundColor
        }
    }
    
    public var height: CGFloat = 2.0 {
        didSet {
            targetViewHeight?.constant = height
            if shape == .round {
                targetView?.layer.cornerRadius = height * 0.5
            }
        }
    }
    
    public var hidden = false {
        didSet {
            targetView?.isHidden = hidden
        }
    }
    
    public var cornerRadius: CGFloat = 1.0 {
        didSet {
            switch shape {
            case .line:
                targetView?.layer.cornerRadius = cornerRadius
            default:
                break
            }
        }
    }
    
    var originWidth: CGFloat = 10.0
    var shape = SliderShape.line
    var elasticValue: CGFloat = 1.6
    var extraWidth: CGFloat = 0.0
    var position = SliderPosition.bottom
    
    private var targetViewHeight: NSLayoutConstraint?
    weak var targetView: UIView? {
        didSet {
            targetView?.translatesAutoresizingMaskIntoConstraints = false
            targetView?.backgroundColor = backgroundColor
            targetViewHeight = targetView?.heightAnchor.constraint(equalToConstant: height)
            targetViewHeight?.isActive = true
            targetView?.isHidden = hidden
            switch shape {
            case .line:
                targetView?.layer.cornerRadius = cornerRadius
            case .round:
                targetView?.layer.cornerRadius = height * 0.5
            case .triangle:
                targetView?.layer.cornerRadius = 0
                guard let targetView = targetView else {
                    return
                }
                
                let trianglePath = UIBezierPath()
                switch position {
                case .top:
                    trianglePath.move(to: CGPoint(x: targetView.frame.minX, y: targetView.frame.minY))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth), y: targetView.frame.minY))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth) * 0.5, y: height))
                case .bottom, .center:
                    trianglePath.move(to: CGPoint(x: targetView.frame.minX, y: height))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth), y: height))
                    trianglePath.addLine(to: CGPoint(x: (height + extraWidth) * 0.5, y: targetView.frame.minY))
                }
                trianglePath.close()
                trianglePath.lineJoinStyle = .round
                trianglePath.lineCapStyle = .round

                let shapeLayer = CAShapeLayer()
                shapeLayer.path = trianglePath.cgPath
                targetView.layer.mask = shapeLayer
            }
        }
    }
    
    public init(view: UIView) {
        targetView = view
    }
    
    public init(parts: SliderStyle...) {
        for part in parts {
            switch part {
            case .backgroundColor(let color):
                backgroundColor = color
            case .height(let value):
                height = value
            case .cornerRadius(let value):
                cornerRadius = value
            case .position(let value):
                position = value
            case .extraWidth(let value):
                extraWidth = value
            case .shape(let value):
                shape = value
            case .originWidth(let width):
                originWidth = width
            case .elasticValue(let value):
                elasticValue = value
            case .hidden(let value):
                hidden = value
            }
        }
    }
}
