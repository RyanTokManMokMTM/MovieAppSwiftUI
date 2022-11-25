//
//  YoutubeView.swift
//  IOS_DEV
//
//  Created by Jackson on 3/8/2022.
//

import Foundation
import UIKit
import SwiftUI
import WebKit

struct YoutubeView : UIViewRepresentable {
    var video_id : String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(video_id)") else {
            return
        }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
    
    
}
