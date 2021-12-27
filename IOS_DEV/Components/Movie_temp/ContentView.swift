//
//  SwiftUIView.swift
//  new
//
//  Created by 張馨予 on 2021/1/28.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    var body: some View {
        VStack{
            Spacer()
            SocialLoginButton(text: "Sign in with Google", textColor: .white, button: .black,image: "google"){
                print("test")
            }
            
            SocialLoginButton(text: "Sign in with Facebook", textColor: .white, button: .black,image: "twitter"){
                print("test")
            }
            
            
            SignInWithAppleButton(
                onRequest: { request in
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                },
                onCompletion: { result in
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                }
            )
            .cornerRadius(25)
            .frame(height:50)
            .padding(.horizontal,50)
        }

    }
}
 
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        tab(isCardSelectedMovie: .constant(false),showHomePage: .constant(false))

    }
}

struct tab:View{
    @Binding var isCardSelectedMovie:Bool
    @Binding var showHomePage:Bool
    var body: some View{
        
        VStack(spacing:0){
            GeometryReader{proxy in
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        HStack{
                            Text("All Movies")
                                .bold()
                                .font(.title2)
                                .padding(.horizontal)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        CardScroll(isCardSelectedMovie: $isCardSelectedMovie)
                            .padding(.top)
                 
                    }
                    .padding(.top,20)
                    
                    VStack(spacing:10){
                        MovieScrollList(listTitle: "Upcomming",MovieList: coverList)
                        MovieScrollList(listTitle: "Top Rate",MovieList: coverList.shuffled())
                        MovieScrollList(listTitle: "For You",MovieList: coverList.shuffled())
                        MovieScrollList(listTitle: "Your List",MovieList: coverList.shuffled())
                    }
                    
                    VStack{
                        HStack{
                            Text("")
                                .bold()
                                .font(.title)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }
                .frame(width:proxy.frame(in: .global).width, height: proxy.frame(in: .global).height)
            }
//            .background(Color.init("ThemeBackGroundColor").edgesIgnoringSafeArea(.all))
            
//            NavBar(index: 0)
            
        }
//
//        .onAppear{
//            UITabBar.appearance().barTintColor = .black
//            UINavigationBar.appearance().barTintColor = .black
//            UINavigationBar.appearance().tintColor = .white
//        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Discovery")
        .navigationBarTitleDisplayMode(.large)
        .toolbar{
            ToolbarItemGroup(placement:.navigationBarLeading){
                HStack{
                    Image("LogoIconsBlack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:100)
                        .offset(x:-15)
                    
                }
            }
            
            ToolbarItemGroup(placement:.navigationBarTrailing){
                Button(action:{
                    withAnimation(){
                        //TO trailer view
                        showHomePage.toggle()
                    }
                }){
                    
                    VStack(spacing:5){
                        Image(systemName: "arrowtriangle.forward.square.fill")
                            .resizable()
                            .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        Text("Tariler")
                            .bold()
                            .font(.footnote)
                        
                    }
                    .foregroundColor(.black)
            
                        
                }
            }
        }
    }
    
    
}

