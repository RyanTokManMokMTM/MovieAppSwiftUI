//
//  signIn.swift
//
//  Ｐｒｏｊｅｃｔ
//
//  Created by 張馨予 on 2021/1/28.
//

import SwiftUI
//let registerService = RegisterService()


struct SignUpView: View {
    @EnvironmentObject var HubState : BenHubState
    @Binding var backToSignIn : Bool
    
    @State private var email : String = ""
    @State private var name : String = ""
    @State private var password : String = ""
    @FocusState private var isEmailFocus : Bool
    @FocusState private var isNameFocus : Bool
    @FocusState private var isPasswordFocus : Bool
    
    //    @State private var confirmPassword : String = ""

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
                    Text("註冊")
                        .TekoBold(size: 40)
                        .foregroundColor(.white)
                    
                    
                }
                .padding(.vertical,5)
                
                VStack(alignment:.leading){
                    Text("郵箱")
                        .OswaldSemiBold()
                        .foregroundColor(.white)
                    TextField("請輸入註冊郵箱", text: $email)
                        .accentColor(.white)
                        .submitLabel(.done)
                        .focused($isEmailFocus)
                        .font(.system(size: 14))
                    Divider()
                        .background(Color.gray)
                }
                .padding(.vertical,5)
                
                VStack(alignment:.leading){
                    Text("名稱")
                        .OswaldSemiBold()
                        .foregroundColor(.white)
                    TextField("請輸入您的名稱", text: $name)
                        .accentColor(.white)
                        .submitLabel(.done)
                        .focused($isNameFocus)
                        .font(.system(size: 14))
                    
                    Divider()
                        .background(Color.gray)
                }
                .padding(.vertical,5)
                
                VStack(alignment:.leading){
                    Text("密碼")
                        .OswaldSemiBold()
                        .foregroundColor(.white)
                    SecureField("請輸入帳號密碼", text: $password)
                        .accentColor(.white)
                        .submitLabel(.done)
                        .focused($isPasswordFocus)
                        .font(.system(size: 14))
                    Divider()
                        .background(Color.gray)
                }
                .padding(.vertical,5)
                
                VStack{
                    Button(action:{
                        withAnimation(){
                            self.HubState.SetWait(message: "Loading")
                        }
                        self.Register()
                    }){
                        Text("註冊")
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
            .padding(.horizontal,20)
            .edgesIgnoringSafeArea(.all)
            .background(Color("DarkMode2"))
            .zIndex(0)
        }
        .background(Color("DarkMode2"))
        .alert(isAlert: $HubState.isPresented){
            BenHubAlertView(message: HubState.message, sysImg: HubState.sysImg)
        }
    }

    
    func Register(){
        let signInData = UserSignInReq(name: self.name, email: self.email, password: self.password)
        
        APIService.shared.UserSignUp(req: signInData){ (result) in
            print(result)
            
            switch result {
            case .success:
                withAnimation{
                    self.HubState.isWait = false
                    self.HubState.AlertMessage(sysImg: "checkmark.circle.fill", message: "註冊成功!")
                    self.backToSignIn = false
                }
            case .failure(let err):
                withAnimation{
                    self.HubState.isWait = false
                    self.HubState.AlertMessage(sysImg: "xmark.circle.fill", message: err.localizedDescription)
                }

            }
            
        }

    }
    
}
