//
//  CustomeUITextView.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 12/1/2022.
//

import SwiftUI


//it need to chage
struct CustomUITextView : UIViewRepresentable{

    @Binding var focuse : [Bool] 
    @Binding var text : String

    let placeholder : String
    let keybooardType : UIKeyboardType
    let returnKeytype : UIReturnKeyType
    var tag:Int
    var isSecureText : Bool = false
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField(frame: .zero)
        view.placeholder = placeholder
        view.attributedPlaceholder = NSAttributedString(string: self.placeholder, attributes:
                                                            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font : UIFont(name: "Oswald-SemiBold", size: 16) ?? UIFont()])
        view.returnKeyType = returnKeytype
        view.keyboardType = keybooardType
        view.isSecureTextEntry = isSecureText
        view.textColor = .white
        view.tintColor = .darkGray
        view.autocorrectionType = .no
        view.tag = tag
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text.isEmpty ?  "" : self.text
        if self.focuse[tag]{
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }else{
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }
    
    class Coordinator : NSObject,UITextFieldDelegate{
        var parent : CustomUITextView
        init(_ textField: CustomUITextView){
            self.parent = textField
        }
        
        func updatefocus(textfield: UITextField) {
            DispatchQueue.main.async {
                textfield.becomeFirstResponder()
            }
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async{
                self.parent.text = textField.text ?? ""
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
//            print(textField.text ?? "")
            if parent.tag == 0{
                parent.focuse = [false,true]
            }else{
                parent.focuse = [false,false]
            }
            self.parent.text = textField.text ?? ""
            return true
        }
    }
}


struct CustomTextView : UIViewRepresentable{
    @Binding  var focuse : [Bool]
    @Binding var text : String
    let maxSize : Int 
    let placeholder : String
    let keybooardType : UIKeyboardType
    let returnKeytype : UIReturnKeyType
    var tag:Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField(frame: .zero)
        view.placeholder = placeholder
        
//        view.attributedPlaceholder = NSAttributedString(string: self.placeholder, attributes:
//                                                            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font : UIFont(name: "Oswald-SemiBold", size: 16) ?? UIFont()])
        view.returnKeyType = returnKeytype
        view.keyboardType = keybooardType
        view.textColor = .white
        view.tintColor = .darkGray
        view.autocorrectionType = .no
        view.tag = tag
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text.isEmpty ?  "" : self.text
        print(self.text)
        if self.focuse[tag]{
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }else{
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }
    
    class Coordinator : NSObject,UITextFieldDelegate{
        var parent : CustomTextView
        init(_ textField: CustomTextView){
            self.parent = textField
        }
        
        func updatefocus(textfield: UITextField) {
            DispatchQueue.main.async {
                textfield.becomeFirstResponder()
            }
        }
        
        
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            self.parent.text = textField.text ?? ""
//        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = self.parent.maxSize
            let currentStr : NSString = (textField.text ?? "") as NSString
            let newStr : NSString = currentStr.replacingCharacters(in: range, with: string) as NSString
            return newStr.length <= self.parent.maxSize
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            
            DispatchQueue.main.async{
                self.parent.text = textField.text ?? ""
            }
        }
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            self.parent.textCount = textField.text == nil ? 0 : textField.text!.count
//        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
//            print(textField.text ?? "")
            if parent.tag == 0{
                parent.focuse = [false,true]
            }else{
                parent.focuse = [false,false]
            }
            self.parent.text = textField.text ?? ""
            return true
        }
    }
}
