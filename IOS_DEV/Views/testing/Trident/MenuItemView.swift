//
//  MenuItemView.swift
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

import UIKit

internal class MenuItemView: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let placeholdLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var normalColor = UIColor.white
    private var selectedColor = UIColor.lightGray
    private var normalColors = UIColor.white.rgb
    private var selectedColors = UIColor.lightGray.rgb
    private var normalFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    private var selectedFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    
    internal var isSelected = false {
        didSet {
            configAttributedText(isSelected ? 1 : 0)
        }
    }
    
    internal var rate: CGFloat = 0.0 {
        didSet {
            guard rate > 0.0, rate < 1.0 else {
                return
            }
            configAttributedText(rate)
        }
    }
    
    internal init(_ text: String,
                  _ normalFont: UIFont,
                  _ selectedFont: UIFont,
                  _ normalColor: UIColor,
                  _ selectedColor: UIColor) {
        super.init(frame: .zero)
        
        self.normalFont = normalFont
        self.selectedFont = selectedFont
        
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        
        normalColors = normalColor.rgb
        selectedColors = selectedColor.rgb
        
        addSubview(placeholdLabel)
        NSLayoutConstraint.activate([
            placeholdLabel.topAnchor.constraint(equalTo: topAnchor),
            placeholdLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            placeholdLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholdLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        let attributes: [NSAttributedString.Key: Any] = [.font: normalFont, .foregroundColor: normalColor]
        textLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        placeholdLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    internal func configAttributedText(_ rate: CGFloat) {
        let r = normalColors.red + (selectedColors.red - normalColors.red) * rate
        let g = normalColors.green + (selectedColors.green - normalColors.green) * rate
        let b = normalColors.blue + (selectedColors.blue - normalColors.blue) * rate
        let a = normalColors.alpha + (selectedColors.alpha - normalColors.alpha) * rate
        
        
        let strokeWidth = floor(CGFloat(selectedFont.weightValue - normalFont.weightValue) * 8.0) * rate
        guard let text = textLabel.attributedText?.string
            , normalFont.pointSize != 0.0 else {
            return
        }
        
        let color =  UIColor(red: r, green: g, blue: b, alpha: a)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: normalFont,
                .foregroundColor: color,
                .strokeWidth: -abs(strokeWidth),
                .strokeColor: color
            ]

        textLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        placeholdLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        let scaleRatio = (selectedFont.pointSize / normalFont.pointSize) - 1.0
        let scaleValue = 1.0 + scaleRatio * rate
        textLabel.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateText(_ text: String) {
        let attributes: [NSAttributedString.Key: Any] = [.font: normalFont, .foregroundColor: normalColor]
        textLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        placeholdLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

