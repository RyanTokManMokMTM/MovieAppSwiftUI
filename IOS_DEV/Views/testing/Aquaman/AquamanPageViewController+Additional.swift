//
//  AquamanPageViewController.swift
//  Aquaman
//
//  Created by bawn on 2018/12/7.
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

extension AquamanPageViewController {
    
    public func setSelect(index: Int, animation: Bool) {
        let offset = CGPoint(x: contentScrollView.bounds.width * CGFloat(index),
                             y: contentScrollView.contentOffset.y)
        contentScrollView.setContentOffset(offset, animated: animation)
        if animation == false {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }

}


extension AquamanPageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mainScrollView {
            // 竖向
            let offsetY = scrollView.contentOffset.y
            if offsetY >= sillValue {
                scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                currentChildScrollView?.am_isCanScroll = true
                scrollView.am_isCanScroll = false
                pageController(attach: self, menuView: true)
            } else {
                let negScroll = (scrollView.am_isCanScroll == false)
                pageController(attach: self, menuView: negScroll)
                if negScroll{
                    scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                }
            }
        } else {
            // 横向
            // menu bar
            pageController(self, contentScrollViewDidScroll: scrollView)
            // front content page
            layoutChildViewControlls()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            mainScrollView.isScrollEnabled = false
        }
    }

    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == contentScrollView {
            mainScrollView.isScrollEnabled = true
            if decelerate == false {
                contentScrollViewDidEndScroll(contentScrollView)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard scrollView == mainScrollView else {
            return false
        }
        // code scroll
        currentChildScrollView?.setContentOffset(currentChildScrollView.offset, animated: true)
        // return scroll
        return true
    }
    
}



extension AquamanPageViewController {
    internal func childScrollView(didScroll scrollView: UIScrollView){
        let scrollOffset = scrollView.am_originOffset.val
        
        let offsetY = scrollView.contentOffset.y
        
        if scrollView.am_isCanScroll == false {
            scrollView.contentOffset = scrollOffset
        }
        else if offsetY <= scrollOffset.y {
            scrollView.contentOffset = scrollOffset
            scrollView.am_isCanScroll = false
            mainScrollView.am_isCanScroll = true
        }
    }
}
