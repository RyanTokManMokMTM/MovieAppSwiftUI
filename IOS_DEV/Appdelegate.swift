//
//  Appdelegate.swift
//  new
//
//  Created by Jackson on 28/3/2021.
//

import UIKit
import Firebase
import GoogleSignIn

class Appdelegate: NSObject,UIApplicationDelegate,GIDSignInDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

      return Appdelegate.orientationLock

    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print((error?.localizedDescription)!)
            return
        }
        else{
            //get user token
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential){
                (result,error) in
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                else{
                    //user login successfully
                    
                    //send notification to UI
                    NotificationCenter.default.post(name: Notification.Name("GoolgSignIN"),object: nil)
                    
                    //demo printing
                    print(result?.user.email ?? "profile is empty")
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print((error?.localizedDescription)!)
        }
    }
}


