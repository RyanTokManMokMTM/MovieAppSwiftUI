//
//  Login.swift
//  Ｐｒｏｊｅｃｔ
//
//  Created by 張馨予 on 2021/1/28.
//

import SwiftUI
//import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit
var NowUserName:String = "" // user who login
var NowUserID:UUID? // user who login
var NowUserPhoto:Image? // user who login


struct SignInView: View   {
    @EnvironmentObject var userVM : UserViewModel
    @State private var email : String = ""
    @State private var password : String = ""
    
    @State private var isSignUp : Bool = false
    @State private var isLoading : Bool = false
    @State var ErrorAlert = false
    @State private var remember = false
    @State private var errMsg : String = ""
    @Binding  var backToHome : Bool
    @Binding var isLoggedIn : Bool
    @AppStorage("userEmail") private var userEmail : String = ""
    @AppStorage("userPassword") private var userPassword : String = ""
    @AppStorage("rememberUser") private var rememberUser : Bool = false
    @ObservedObject private var networkingService = NetworkingService.shared
    @State private var isFocuse : [Bool] = [false,true]
    
    var body: some View {
        ZStack{
            VStack(alignment:.leading){
                VStack{
                    Button(action:{
                        withAnimation(){
                            self.backToHome.toggle()
                        }
                    }){
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical)
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom,50)
                VStack(alignment:.leading,spacing:0){
                    HStack{
                        Text("Sign In")
                            .TekoBold(size: 40)
                            .foregroundColor(.white)
                        
                    }
                    
                    LoginInfo(FieldText: "Email", bindText: $email, placeHolder: "Enter your email", keyType: .default, returnType: .default)
                    LoginInfo(FieldText: "Password", bindText: $password, placeHolder: "Enter your password", keyType: .default, returnType: .default,isSecureText: true)
                    
                    HStack{
                        Group{
                            Image(systemName: self.remember ? "checkmark.square.fill" : "square.fill")
                                .font(.body)
                                .foregroundColor(.white)
                                .onTapGesture(){
                                    withAnimation(){
                                        self.remember.toggle()
                                        UserDefaults.standard.set( self.remember, forKey: "rememberUser")
                                    }
                                }
                            Text("Remember me")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .OswaldSemiBold()
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical,8)
                    
                    VStack{
                        Button(action:{
                            //Check and
                            withAnimation(){
                                self.isLoading.toggle()
                            }
                            self.Login(UserName: self.email, Password: self.password)
                        }){
                            Text("Sign In")
                                .bold()
                                .OswaldSemiBold()
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity,maxHeight: 50)
                                .background(Color.pink.cornerRadius(8))
                        }
                        .padding(.top)
                        
                        HStack{
                            Text("Do not have an account?")
                                .foregroundColor(.gray)
                            
                            Button(action:{
                                //TODO
                                withAnimation(){
                                    self.isSignUp.toggle()
                                }
                            }){
                                Text("SignUp")
                                    .foregroundColor(.white)
                            }
                        }
                        .OswaldSemiBold(size: 15)
                    }
                }
                Spacer()
            }
            .padding(.horizontal,20)
            .edgesIgnoringSafeArea(.all)
            .background(Color.black.overlay(Color.black.opacity(0.45)).edgesIgnoringSafeArea(.all))
            .zIndex(0)
            
            if isSignUp{
                SignUpView(backToSignIn: $isSignUp)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    .zIndex(1)
            }
            
            if isLoading{
                VStack{
                    BasicLoadingView()
                        .padding()
                        .background(BlurView().cornerRadius(15))
                }
                .zIndex(1.0)
                .frame(maxWidth:.infinity, maxHeight:.infinity)
                .background(Color.black.opacity(0.75).edgesIgnoringSafeArea(.all))
            }
        }
        .ignoresSafeArea(.keyboard)
        .alert(isPresented: $ErrorAlert, content: {
            Alert(title: Text(errMsg),
                  dismissButton: .default(Text("Enter")))
        })
        .onAppear(perform: {
            self.remember = rememberUser
            self.email = userEmail
            self.password = userPassword
        })

    }
    
    @ViewBuilder
    func LoginInfo(FieldText : String,bindText: Binding<String>,placeHolder : String,keyType : UIKeyboardType,returnType:UIReturnKeyType,isSecureText : Bool = false) -> some View{
        VStack(alignment:.leading){
            Text(FieldText)
                .OswaldSemiBold()
                .foregroundColor(.white)
            CustomUITextView(focuse:$isFocuse,text: bindText, placeholder: placeHolder, keybooardType: keyType, returnKeytype: returnType, tag: 1,isSecureText:isSecureText)
                .frame(height:23)
            Divider()
                .background(Color.white)
        }
        .padding(.vertical,10)
    }
    
    
    //Sending Request to server - Login Request
    func Login(UserName:String, Password:String){
        let loginReq = UserLoginReq(email: email, password: password)
        APIService.shared.UserLogin(req: loginReq){ (result) in
            switch result {
            case .success(let user):
                print("login success")
                //get user profile by token
                ErrorAlert = false
                UserDefaults.standard.set(user.token, forKey: "userToken") //storing token
                UserDefaults.standard.set(user.expired, forKey: "tokenExpired") //storing token expired time
                
                self.GetUserProfile(token: user.token)
            case .failure(let error):
                print(error.localizedDescription)
                ErrorAlert = true
                self.isLoading.toggle()
                self.errMsg = error.localizedDescription
            }
        }
//        networkingService.requestLogin(endpoint: "/api/v1/user/login", loginObject: loginReq) { (result) in
//            switch result {
//            case .success(let user):
//                print("login success")
////                self.isPresented.toggle()
//                //Here we are gonna to set t
//
//                ErrorAlert = false
////                NowUserName = user.name
////                NowUserID = user.id
//                //set it to user model
//                self.userVM.setUserInfo(info: user)
//                UserDefaults.standard.set(self.remember ? email : "", forKey: "userEnail")
//                UserDefaults.standard.set(self.remember ? password : "", forKey: "userPassword")
//
//                withAnimation(){
//                    self.isLoggedIn.toggle()
//                    self.backToHome.toggle()
//                    self.isLoading.toggle()
//                }
//
//            case .failure(let error):
//                //need to fixed here
//                print("login failed")
//                print(error.localizedDescription)
//                ErrorAlert = true
//                self.isLoading.toggle()
//            }
//        }
    }
    
    
    //Sending Request to server - Get Profile by Token
    func GetUserProfile(token : String) {
        APIService.shared.GetUserProfile(token: token){ (result) in
            switch result{
            case .success(let profile):
                ErrorAlert = false
//                NowUserName = user.name
//                NowUserID = user.id
                //set it to user model
                self.userVM.setUserInfo(info: profile)
                self.errMsg.removeAll()
                UserDefaults.standard.set(self.remember ? email : "", forKey: "userEmail")
                UserDefaults.standard.set(self.remember ? password : "", forKey: "userPassword")
                
                withAnimation(){
                    self.isLoggedIn.toggle()
                    self.backToHome.toggle()
                    self.isLoading.toggle()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.errMsg = error.localizedDescription
                withAnimation(){
                    self.ErrorAlert = true
                    self.isLoading.toggle()
                }
            }
        }
    }
}
//2
//struct SignIn: View {
//    @State private var failed = false
//    @State private var check:Bool = false
//
//    @State private var email:String = ""
//    @State private var username:String = ""
//    @State private var password:String = ""
//    @State private var isLoading : Bool = false
//
//    @Binding var isSignIn:Bool
//    @Binding var isLoggedIn : Bool
//    //  @Namespace var names
//    var body: some View {
//        ZStack{
//            VStack{
//                HStack {
//                    Spacer()
//                    Button(action:{
//                        withAnimation(){
//                            isSignIn.toggle()
//                        }
//                    }){
//                        HStack {
//                            Image(systemName: "arrow.backward")
//                                .font(.title)
//                                .foregroundColor(Color.white.opacity(0.5))
//                                .padding(.bottom,20)
//                                .padding(.leading)
//                            Spacer()
//
//                        }
//                    }
//                }
//                Spacer()
//
//                SignInCell(email: $email, username: $username, password: $password,isLoading:self.$isLoading,isSignIn: $isSignIn,isLoggedIn:$isLoggedIn)
//                Spacer()
//            }
//            .padding(.top,20)
//            .padding(.vertical)
//            .zIndex(0)
//
//            if isLoading{
//                VStack{
//                    BasicLoadingView()
//                        .padding()
//                        .background(BlurView().cornerRadius(15))
//                }
//                .zIndex(1.0)
//                .frame(maxWidth:.infinity, maxHeight:.infinity)
//                .background(Color.black.opacity(0.75).edgesIgnoringSafeArea(.all))
//            }
//        }
//
//    }
//}

//struct SignInCell : View{
//
//    @Binding var email:String
//    @Binding var username:String
//    @Binding var password:String
//    @Binding var isLoading:Bool
//    @Binding var isSignIn:Bool
//    @Binding var isLoggedIn : Bool
//
//    @State var ErrorAlert = false
//    @State private var remember = false
//    @AppStorage("userName") private var userName : String = ""
//    @AppStorage("userPassword") private var userPassword : String = ""
//    @AppStorage("rememberUser") private var rememberUser : Bool = false
//    @ObservedObject private var networkingService = NetworkingService.shared
//
//    func Login(UserName:String, Password:String){
//
////        let login = UserLogin(UserName: UserName, Password: Password)
////
////        //If token is not nil check then token first else login with request
////        networkingService.requestLogin(endpoint: "/users/login", loginObject: login) { (result) in
////            switch result {
////            case .success(let user):
////                print("login success")
//////                self.isPresented.toggle()
////
////                ErrorAlert = false
////                NowUserName = user.UserName
////                NowUserID = user.id
////                UserDefaults.standard.set(self.remember ? username : "", forKey: "userName")
////                UserDefaults.standard.set(self.remember ? password : "", forKey: "userPassword")
////
////                withAnimation(){
////                    self.isLoggedIn.toggle()
////                    self.isSignIn.toggle()
////                    self.isLoading.toggle()
////                }
////
////            case .failure:
////                print("login failed")
////                ErrorAlert = true
////                self.isLoading.toggle()
////            }
////        }
//    }
//
//    var body: some View{
//        Group{
//            Text("Sign In")
//                .bold()
//                .foregroundColor(.orange)
//                .TekoBold(size: 45)
//
//            VStack(){
//                VStack {
//                    HStack{
//                        Text("Username :")
//                            .foregroundColor(.white)
//                            .font(.headline)
//                        Spacer()
//                    }
//
//                    TextFieldWithLineBorder(text: $username,placeholder: "Enter Your Username")
//                        .keyboardType(.emailAddress)
//                }
//                .padding(.horizontal)
//
//                VStack {
//                    HStack{
//                        Text("Password :")
//                            .foregroundColor(.white)
//                            .font(.headline)
//                        Spacer()
//                    }
//
//                    SeruceFieldWithLineBorder(text: $password, placeholder: "Enter Your Password")
//
//                }
//                .padding(.horizontal)
//
//                HStack {
//                    Group{
//                        Image(systemName: self.remember ? "checkmark.square.fill" : "square.fill")
//                            .font(.body)
//                            .foregroundColor(.white)
//                            .onTapGesture(){
//                                withAnimation(){
//                                    self.remember.toggle()
//                                    UserDefaults.standard.set( self.remember, forKey: "rememberUser")
//                                }
//                            }
//                        Text("Remember me")
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                    }
//
//                    Spacer()
//
//                    Button(action:{
//                        //TODO
//                        //GO TO FROGET PASSWORD
//
//                    }){
//                        Text("Forget Password?")
//                            .foregroundColor(.secondary)
//                            .font(.footnote)
//                    }
//
//                }
//                .padding(.horizontal)
//
//            }
//            .padding()
//
//            Spacer()
//
//            VStack{
//                smallButton(text: "Sign In", textColor: .black, button: .white, image: ""){
//                    withAnimation(){
//                        self.isLoading.toggle()
//                    }
//                    self.Login(UserName: self.username, Password: self.password)
//                }.padding(.horizontal,50)
//                .alert(isPresented: $ErrorAlert, content: {
//                    Alert(title: Text("帳號密碼錯誤"),
//                          dismissButton: .default(Text("Enter")))
//                })
//            }
//
////            HStack{
////                VStack{
////                    Divider()
////                        .padding(.horizontal)
////                        .background(Color.secondary)
////                }
////
////                Text("OR")
////                    .font(.subheadline)
////                    .foregroundColor(.white)
////
////                VStack{
////                    Divider()
////                        .padding(.horizontal)
////                        .background(Color.secondary)
////                }
////            }
////            .padding(.vertical,5)
////            .frame(width: UIScreen.main.bounds.width)
//
//
//
//
//
//
//        }
//        .onAppear(){
//            self.remember = rememberUser
//            self.username = userName
//            self.password = userPassword
//
//        }
//    }
//}
//
//
//
