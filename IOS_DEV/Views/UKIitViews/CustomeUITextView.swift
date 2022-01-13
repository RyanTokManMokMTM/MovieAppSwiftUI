//
//  CustomeUITextView.swift
//  IOS_DEV
//
//  Created by JacksonTmm on 12/1/2022.
//

import SwiftUI

struct CustonUITextView : UIViewRepresentable{
    @State private var forcus : [Bool] = [false,true]
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
//        print(self.text)
        uiView.text = self.text == "" ?  "" : self.text
        if self.tag == 1{
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
        var parent : CustonUITextView
        init(_ textField: CustonUITextView){
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
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent.text = textField.text ?? ""
//            print(textField.text ?? "")
            if parent.tag == 0{
                parent.forcus = [false,true]
            }else{
                parent.forcus = [false,false]
            }
            return true
        }
    }
}
