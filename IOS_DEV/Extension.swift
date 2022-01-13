//
//  Extension.swift
//  IOS_DEV
//
//  Created by Jackson on 20/4/2021.
//


import Foundation
import SwiftUI
import SDWebImageSwiftUI
import AVKit

extension String{
    func widthOfStr(Font font:UIFont) ->CGFloat{
        let fontAttr = [NSAttributedString.Key.font:font]
        let size = self.size(withAttributes: fontAttr)
        return size.width
    }
}

//for Appstorage
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}


extension View{
    func HiddenKeyBoard(to:Any?,from:Any?,forEvent:UIEvent?){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: to, from: from, for: forEvent)
    }
}

extension Font{
    static func CourgetteRegular(size: CGFloat)->Font{
        .custom("Courgette-Regular", size: size)
    }
    
    static func TekoBoldFont(size:CGFloat)->Font{
        .custom("Teko-Bold", size:size)
    }
    //KleeOne-SemiBold.ttf
    static func ZCOOLKuaiLeRegular(size : CGFloat)->Font{
        .custom("ZCOOLKuaiLe-Regular", size: size)
    }
    
    static func ZenKurenaidoRegular(size : CGFloat)->Font{
        .custom("ZenKurenaido-Regular", size: size)
    }

    static func KleeOneSemiBold(size : CGFloat)->Font{
        .custom("KleeOne-SemiBold", size: size)
    }
    
    //Oswald-SemiBold
    static func setPadaukRegular(size : CGFloat) -> Font{
        Font.custom("Roboto-Regular", size: size)
    }
    
    static func setOswaldSemiBold(size : CGFloat) -> Font{
        Font.custom("Oswald-SemiBold", size: size)
    }
}
//
struct setCourgetteRegularFont : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        content.font(Font.CourgetteRegular(size: size))
    }
}

struct setTekoBoldFont : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        content.font(Font.TekoBoldFont(size: size))
    }
}



struct setZCOOLKuaiLeRegular : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        content.font(Font.ZCOOLKuaiLeRegular(size: size))
    }
}

struct setZenKurenaidoRegular : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        content.font(Font.ZCOOLKuaiLeRegular(size: size))
    }
}

struct setKleeOneSemiBold : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        content.font(Font.ZCOOLKuaiLeRegular(size: size))
    }
}


struct setPadaukRegularFont : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        return content.font(.setPadaukRegular(size: size))
    }
}

struct setsetOswaldSemiBoldFont : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        return content.font(.setOswaldSemiBold(size: size))
    }
}



extension View{
    func CourgetteRegularFont(size:CGFloat = 18)-> some View{
        ModifiedContent(content: self, modifier:setCourgetteRegularFont(size: size) )
    }
    
    func TekoBold(size:CGFloat = 18)-> some View{
        ModifiedContent(content: self, modifier:setTekoBoldFont(size: size) )
    }
    
    func ZCOOLKuaiLeRegular(size:CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setZCOOLKuaiLeRegular(size: size))
    }
    
    func ZenKurenaidoRegular(size:CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setZenKurenaidoRegular(size: size))
    }

    func KleeOneSemiBold(size:CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setKleeOneSemiBold(size: size))
    }
    
    
    func PadaukRegular(size : CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setPadaukRegularFont(size: size))
    }
    
    func OswaldSemiBold(size : CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setsetOswaldSemiBoldFont(size: size))
    }
}

//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}

extension AVPlayer{
    func isPlaying() -> Bool{
        timeControlStatus == AVPlayer.TimeControlStatus.playing
    }
}
