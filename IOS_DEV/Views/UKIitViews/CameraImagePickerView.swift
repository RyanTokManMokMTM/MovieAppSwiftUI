//
//  CameraImagePickerView.swift
//  IOS_DEV
//
//  Created by Jackson on 25/7/2021.
//

import SwiftUI
import UIKit

struct CameraImagePickerView : UIViewControllerRepresentable{
    @Binding var selectedImage : UIImage?
    @Environment (\.presentationMode) var isPresented //show the camera view or phone bottome ship
    var sourceType:UIImagePickerController.SourceType //passing the source type
    @Binding var selected : Bool
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType // photo library or camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
       //TODO

    }
    

    class Coordinator :NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
        var picker: CameraImagePickerView
        
        init(picker : CameraImagePickerView){
            self.picker = picker //passing our controller into the brige
        }
        
        //from UIImagePickerControllerDelegate
        //trigger when user is taken a photo or selected a phone from photoLib
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { //is the original image is UIImage
                return
            }
            self.picker.selectedImage = selectedImage
            self.picker.selected.toggle()
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
}


struct EditableImagePickerView : UIViewControllerRepresentable{
    var sourceType:UIImagePickerController.SourceType
    var imageUploadType : UploadImageType
//    @Binding var selectedImage : UIImage? 
    @EnvironmentObject var UserVM : UserViewModel
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = self.sourceType // photo library or camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
       //TODO

    }
    

    class Coordinator :NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
        var picker: EditableImagePickerView
        
        init(picker : EditableImagePickerView){
            self.picker = picker //passing our controller into the brige
        }
        
        //from UIImagePickerControllerDelegate
        //trigger when user is taken a photo or selected a phone from photoLib
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { //is the original image is UIImage
                return
            }

            //update user profile
            //update view model and send the http request
            if self.picker.imageUploadType == .Avatar{
                self.picker.UserVM.UploadUserAvatar(uiImage: selectedImage)
            } else  {
                print("update cover?")
                self.picker.UserVM.UploadUserCover(uiImage: selectedImage)
            }
            
            picker.dismiss(animated: true)
        }
    }
}
