//
//  signIn.swift
//
//  Ｐｒｏｊｅｃｔ
//
//  Created by 張馨予 on 2021/1/28.
//

import SwiftUI
let registerService = RegisterService()


struct SignUp2: View {
    @Binding var backToSignIn : Bool
    
    @State private var email : String = ""
    @State private var name : String = ""
    @State private var password : String = ""
    @State private var confirmPassword : String = ""
    
    @State var ErrorResponse:String = ""
    @State var ErrorAlert = false
    @State private var isLoading : Bool = false
    @State private var isFocuse : [Bool] = [false,true]
    var body: some View {
        ZStack{
            VStack(alignment:.leading){
                VStack{
                    Button(action:{
                        withAnimation(){
                            self.backToSignIn.toggle()
                        }
                    }){
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical)
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                
                HStack{
                    Text("Sign Up")
                        .TekoBold(size: 40)
                        .foregroundColor(.white)
                    
                    
                }
                
                signUpInfo(FieldText: "Email", bindText: $email, placeHolder: "Enter your email", keyType: .emailAddress, returnType: .default)
                signUpInfo(FieldText: "Name", bindText: $name, placeHolder: "Enter your email", keyType: .default, returnType: .default)
                signUpInfo(FieldText: "Password", bindText: $password, placeHolder: "Enter your password", keyType: .default, returnType: .default,isSecureText: true)
                signUpInfo(FieldText: "Confirm Password", bindText: $confirmPassword, placeHolder: "Confirm Your password", keyType: .default, returnType: .default,isSecureText: true)
                
                
                VStack{
                    Button(action:{
                        withAnimation(){
                            self.isLoading.toggle()
                        }
                        self.Register()
                    }){
                        Text("Sign Up")
                            .bold()
                            .OswaldSemiBold()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity,maxHeight: 50)
                            .background(Color.pink.cornerRadius(8))
                    }
                    .padding(.top)

                    
                }
                
                Spacer()
                
            }
            .alert(isPresented: $ErrorAlert, content: {
                Alert(title: Text(self.ErrorResponse),
                      dismissButton: .cancel())
                
            })
            .padding(.horizontal,20)
            .edgesIgnoringSafeArea(.all)
            .background(Color.black.overlay(Color.black.opacity(0.45)))
            .ignoresSafeArea(.keyboard)
            .zIndex(0)
            
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
    }
    
    @ViewBuilder
    func signUpInfo(FieldText : String,bindText: Binding<String>,placeHolder : String,keyType : UIKeyboardType,returnType:UIReturnKeyType,isSecureText : Bool = false) -> some View{
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
    
    func Register(){
        let auth = UserRegister(user_name: self.name, email: self.email, password: self.password, confirm_password: self.confirmPassword)
        registerService.requestRegister(endpoint: "/users/register", RegisterObject: auth) { (result) in
            print(result)
            
            switch result {
            case .success:
                print("register success")
                ErrorAlert = false
                withAnimation(){
                    self.isLoading.toggle()
                    self.backToSignIn.toggle()
                }
                
            case .failure(let error):
                print("register failed")
                ErrorAlert = true
                ErrorResponse = error.localizedDescription
                withAnimation(){
                    self.isLoading.toggle()
                }

            }
        }
    }
    
    
}


struct SignUp: View {
    @State var ErrorResponse:String = ""
    @State var ErrorAlert = false
    @State private var isLoading : Bool = false
    @State private var MovieSetting : Bool = false
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var ConfirmPassword:String = ""
    @State private var UserName:String = ""

    @Binding var isSignUp:Bool
    @Binding var isSignIn : Bool

    //  @Namespace var names
    

    
    func Register(){
  
        let auth = UserRegister(user_name: self.UserName, email: self.email, password: self.password, confirm_password: self.ConfirmPassword)
        
        registerService.requestRegister(endpoint: "/users/register", RegisterObject: auth) { (result) in
            print(result)
            
            switch result {
            case .success:
                print("register success")
                ErrorAlert = false
                withAnimation(){
                    self.MovieSetting.toggle()
                    self.isLoading.toggle()
                }
                
            case .failure(let error):
                print("register failed")
                ErrorAlert = true
                ErrorResponse = error.localizedDescription
                withAnimation(){
                    self.isLoading.toggle()
                }

            }
        }
    }
    
    
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Button(action:{
                        withAnimation(){
                            isSignUp.toggle()
                        }
                    }){
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.title)
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.bottom,20)
                                .padding(.leading)
                            Spacer()
                            
                        }
                    }
                }
                Spacer()
                
                
                HStack {
                    Text("Sign Up")
                        .bold()
                        .foregroundColor(.orange)
                        .TekoBold(size: 45)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.leading,10)
                
                
                UserRegForm(email: $email, password: $password, ConfirmPassword: $ConfirmPassword, UserName: $UserName)
                
                
                Spacer()
                
                
                
                smallButton(text: "Next", textColor: .black, button: .white, image: ""){
                    withAnimation(){
                        self.isLoading.toggle()
                    }
                    self.Register()
                }
                .padding(.horizontal,50)
                .alert(isPresented: $ErrorAlert, content: {
                    Alert(title: Text(self.ErrorResponse),
                          dismissButton: .cancel())
                    
                })
                .fullScreenCover(isPresented: $MovieSetting, content: {
                    FirstMovieSettingView(isSignUp: $isSignUp, MovieSetting: $MovieSetting)
                })
                
                
                Spacer()
                
                
                HStack{
                    Text("Already have an account?")
                        .foregroundColor(.secondary)
                    Button(action:{
                        //TODO:
                        //GO TO SIGN UP PAGE
                        withAnimation{
                            self.isSignIn.toggle()
                            self.isSignUp.toggle()
                        }
                    }){
                        Text("Sign In")
                    }
                }
                .font(.system(size: 14))
                .padding()
                
                Spacer()
                
            }
            .zIndex(0)
            
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
    }
    
}


//



struct SocialSignUp: View {
    var body: some View {
        HStack {
            Spacer()
            CircleButton(IconName: "applelogo") {
                // TODO:
                // SIGN IN WITH APPLE ID
            }
            Spacer()
            
            CircleButton(IconName: "GoogleIcon",isSystemName: false) {
                // TODO:
                // SIGN IN WITH APPLE ID
            }
            
            Spacer()
            
            CircleButton(IconName: "facebook",isSystemName: false) {
                // TODO:
                // SIGN IN WITH APPLE ID
            }
            
            Spacer()
            
            CircleButton(IconName: "twitter",isSystemName: false) {
                // TODO:
                // SIGN IN WITH APPLE ID
            }
            
            Spacer()
            
        }
    }
}

struct UserRegForm: View {
    @Binding var email:String
    @Binding var password:String
    @Binding var ConfirmPassword:String
    @Binding var UserName:String
    
    
    var body: some View {
        VStack(spacing:20){
            
            VStack {
                HStack{
                    Text("UserName :")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                
                TextFieldWithLineBorder(text: $UserName,placeholder: "Enter Yout UserName")
            }
            .padding(.horizontal)
            
            VStack {
                HStack{
                    Text("Email :")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                
                TextFieldWithLineBorder(text: $email,placeholder: "Enter Your Email")
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)

            
            VStack {
                HStack{
                    Text("Password :")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                
                SeruceFieldWithLineBorder(text: $ConfirmPassword, placeholder: "Enter Your Password")
                
            }
            .padding(.horizontal)
            
            
            VStack {
                HStack{
                    Text("Enter Password :")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                
                SeruceFieldWithLineBorder(text: $password, placeholder: "Enter Your Password")
                
            }
            .padding(.horizontal)
            
            
        }
        .padding()
    }
}


//---------------------問卷-------------------------//

struct FirstMovieSettingView: View {
    @ObservedObject var dramaData=dramaInfoData()
    @Binding var isSignUp : Bool
    @Binding var MovieSetting : Bool
    let genreData = DataLoader().genreData
    var columns = Array(repeating: GridItem(.flexible(),spacing:15), count: 3)
    var body: some View{
        
        Spacer()
        
        VStack(spacing:20){
            

            Text("選擇您喜愛的類別")
                .font(.body)
                .padding(15)
            
            LazyVGrid(columns: columns, spacing: 15){

                ForEach(genreData, id:\.id){ genre in
                    genrebutton(genreInfo: genre, dramadata: dramaData)
                }

            }

            Spacer()
            
           
            smallButton(text: "SignUp", textColor: .black, button: .white, image: ""){
                withAnimation(){
                    self.MovieSetting.toggle()  //離開問卷
                    self.isSignUp.toggle()      //離慨註冊頁面
                }
            }
            .padding(.horizontal,50)
            Spacer()
        }
        .navigationTitle("電影喜好設定")
    }
}
