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
    
    static func setConcertOneRegular(size : CGFloat) -> Font{
        Font.custom("ConcertOne-Regular", size: size)
    }

    static func setLeckerliOneRegular(size : CGFloat) -> Font{
        Font.custom("LeckerliOne-Regular", size: size)
    }
    
    static func setUnicaOneRegular(size : CGFloat) -> Font {
        Font.custom("UnicaOne-Regular", size:size)
    }
}
//
struct setConcertOneRegularFont : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        content.font(Font.setConcertOneRegular(size: size))
    }
}

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


struct setLeckerliOneRegularFont : ViewModifier{
    var size : CGFloat
    func body(content: Content) -> some View {
        return content.font(.setLeckerliOneRegular(size: size))
    }
}

struct setUnicaOneRegularFont : ViewModifier {
    var size : CGFloat
    func body(content: Content) -> some View {
        return content.font(.setUnicaOneRegular(size: size))
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
    
    func ConcertOneRegularFont(size : CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setConcertOneRegularFont(size: size))
    }
    
    func LeckerliOneRegularFont(size : CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setLeckerliOneRegularFont(size: size))
    }
    
    func UnicaOneRegularFont(size : CGFloat = 18) -> some View{
        ModifiedContent(content: self, modifier: setUnicaOneRegularFont(size: size))
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


extension Date{
    
    func dateDescriptiveString(dataStyle : DateFormatter.Style = .short) -> String {
        //self = current class date
        let formatter = DateFormatter()
        formatter.dateStyle = dataStyle
        let dayBetween = daysBetween(date: Date())
        
        if dayBetween == 0{
            return "今天"
        } else if dayBetween == 1 {
            return "昨天"
        }else if dayBetween < 5 {
            let weekDay = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekDay]
        }
        return formatter.string(from: self)
        
    }
    
    func sendTimeString(dataStyle : DateFormatter.Style = .short) -> String {
        //self = current class date
        let formatter = DateFormatter()
        formatter.dateStyle = dataStyle
        let dayBetween = daysBetween(date: Date())
        
        if dayBetween == 0{
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        } else if dayBetween == 1 {
            formatter.dateFormat = "HH:mm"
            return "昨天" + formatter.string(from: self)
        }else if dayBetween < 5 {
            formatter.dateFormat = "HH:mm"
            let weekDay = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekDay] + formatter.string(from: self)
        }
        
        formatter.dateFormat = "yy/M/d HH:mm a"
        return formatter.string(from: self)
        
    }
    
    func daysBetween(date : Date) -> Int{
        let calender = Calendar.current
        let date1 = calender.startOfDay(for: self)
        let date2 = calender.startOfDay(for: date)
        if let dayByDay = calender.dateComponents([.day], from: date1, to: date2).day{
            return dayByDay
        }
        return 0
    }
}


// Hide navigation bar without losing swipe back gesture in SwiftUI
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let size = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image{ _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    var asImage : UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.top))
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        print(targetSize)
        print(UIScreen.main.bounds.size)
        view?.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize)
        view?.backgroundColor = .clear

        let format = UIGraphicsImageRendererFormat()
        // Ensures 3x-scale images. You can customise this however you like.
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
