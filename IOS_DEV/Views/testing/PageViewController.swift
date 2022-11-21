//
//  PageViewController.swift
//  Aquaman-Demo
//
//  Created by bawn on 2018/12/8.
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

import UIKit

import Aquaman
import Trident
import SwiftUI

struct TestKit : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AquamanPageViewController{
        return PageViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class PageViewController: AquamanPageViewController {
    
    
    let titles = ["Superman", "Batman", "Wonder Woman", "哈 哈 哈"]

    lazy var menuView: TridentMenuView = {
        let view = TridentMenuView(parts:
            .normalTextColor(UIColor.gray),
            .selectedTextColor(UIColor.blue),
            .normalTextFont(UIFont.systemFont(ofSize: 15.0)),
            .selectedTextFont(UIFont.systemFont(ofSize: 15.0, weight: .medium)),
            .sliderStyle(
                SliderViewStyle(parts:
                    .backgroundColor(.blue),
                    .height(3.0),
                    .cornerRadius(1.5),
                    .position(.bottom),
                    .extraWidth( -10.0 ),
                    .shape( .line )
                )
            ),
            .bottomLineStyle(
                BottomLineViewStyle(parts:
                    .hidden( false )
                )
            )
        )
        view.delegate = self
        view.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.titles = titles
        return view
    }()
    
    private let headerView = HeaderView()

    override func headerViewFor(_ pageController: AquamanPageViewController) -> UIView {
        return headerView
    }
    
    override func headerViewHeightFor(_ pageController: AquamanPageViewController) -> CGFloat {
        return 200.0
    }
    
    override func numberOfViewControllers(in pageController: AquamanPageViewController) -> Int {
        return titles.count
    }
    
    func pageController(_ pageController: AquamanPageViewController, viewControllerAt index: Int) -> (UIViewController & AquamanChildViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            return SupermanViewController()
        } else if index == 1 {
            return storyboard.instantiateViewController(withIdentifier: "BatmanViewController") as! BatmanViewController
        } else if index == 2 {
            return storyboard.instantiateViewController(withIdentifier: "WonderWomanViewController") as! WonderWomanViewController
        } else {
            return storyboard.instantiateViewController(withIdentifier: "TheFlashViewController") as! TheFlashViewController
        }
    }

    override func pageController(_ pageController: AquamanPageViewController, viewControllerAt index: Int) -> AquamanController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "SupermanViewController") as! SupermanViewController
        } else if index == 1 {
            return storyboard.instantiateViewController(withIdentifier: "BatmanViewController") as! BatmanViewController
        } else if index == 2 {
            return storyboard.instantiateViewController(withIdentifier: "WonderWomanViewController") as! WonderWomanViewController
        } else {
            return storyboard.instantiateViewController(withIdentifier: "TheFlashViewController") as! TheFlashViewController
        }
    }
    
    override func menuViewFor(_ pageController: AquamanPageViewController) -> UIView {
        return menuView
    }
    
    override func menuViewHeightFor(_ pageController: AquamanPageViewController) -> CGFloat {
        return 54.0
    }
    

    override func pageController(_ pageController: AquamanPageViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        menuView.updateLayout(scrollView)
    }
    
//    override func pageController(attach pageController: AquamanPageViewController, menuView isAdsorption: Bool) {
//        menuView.backgroundColor = isAdsorption ? .red : .white
//    }
//
//
//    override func pageController(_ pageController: AquamanPageViewController, didDisplay viewController: AquamanController, forItemAt index: Int) {
//        menuView.checkState(animation: true)
//    }
    
}


extension PageViewController: TridentMenuViewDelegate {
    func menuView(_ menuView: TridentMenuView, didSelectedItemAt index: Int) {
        guard index < titles.count else {
            return
        }
        setSelect(index: index, animation: true)
    }
}
