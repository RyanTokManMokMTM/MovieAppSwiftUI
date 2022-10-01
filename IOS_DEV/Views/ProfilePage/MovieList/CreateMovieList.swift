//
//  CreateMovieList.swift
//  IOS_DEV
//
//  Created by Jackson on 30/7/2022.
//

import SwiftUI

struct CreateMovieList: View {
    @Binding var isCreateList : Bool
    @EnvironmentObject var userModel : UserViewModel
    @State private var listTitle : String = ""
    @State private var intro : String = ""
    @FocusState private var isTitleFocus : Bool
    @FocusState private var isIntroFocus : Bool
    
    @State private var isLoading = false
    @State private var err : Error?
    
    init(isCreateList : Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._isCreateList = isCreateList
    }
    var body: some View {
        ZStack{
            GeometryReader{proxy in
                VStack(alignment:.leading,spacing:0){
                    VStack{
                        HStack(){
                            Button(action:{
                                withAnimation{
                                    self.isCreateList = false
                                }
                            }){
                               Image(systemName: "chevron.left")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                            Button(action:{
                                if listTitle.isEmpty {return}
                                CreateNewList()
                                
                            }){
                              Text("建立")
                                    .font(.system(size:16,weight:.semibold))
                                    .foregroundColor(.white)
                                    
                            }
                         
                        }
                        .overlay(
                            HStack{
                                Text("新建專輯")
                                    .font(.system(size:14,weight:.bold))
                                    .foregroundColor(.white)
    //                                .padding(.bottom,10)
                            }
                        
                        )
                        .font(.system(size: 14))
                        .padding(.horizontal,10)
                        .padding(.bottom,10)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: proxy.safeAreaInsets.top + 30,alignment: .bottom)
                    .background(Color("DarkMode2"))
                    Divider()
                    
                    List{
                        HStack(spacing:5){
                            Text("標題")
                                .font(.system(size:14,weight:.semibold))
                                .foregroundColor(.white)
                                .padding(.trailing,8)
                            
                            TextField("", text: $listTitle)
                                .font(.system(size:14))
                                .focused($isTitleFocus)
                                .submitLabel(.done)
                                .accentColor(.white)
    //                            .frame(maxWidth:.infinity)
                        }
                        .listRowBackground(Color("DarkMode2"))
                        
                        HStack(alignment:.center,spacing:5){
                            Text("簡介")
                                .font(.system(size:14,weight:.semibold))
                                .foregroundColor(.gray)
                                .padding(.trailing,8)
                            
                           TextEditor(text: $intro)
                                .font(.system(size:14))
                                .foregroundColor(.gray)
                                .focused($isIntroFocus)
                                .lineLimit(5)
                                .frame(height:100)
                                .accentColor(.gray)
    //                            .frame(maxWidth:.infinity)
                        }
                        .frame(height:100)
                        .listRowBackground(Color("DarkMode2"))
                    }
                    .listStyle(GroupedListStyle())
    //                .padding(.top,30)
                  

                    
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            if isLoading || self.err != nil {
                LoadingView(isLoading: self.isLoading, error: self.err as NSError?){
                    print("retry Create LIST")
                }
                .background(Color.black.opacity(0.5).frame(maxWidth:.infinity,maxHeight: .infinity))
            }
        }
  
    }
    
    func CreateNewList() {
        if listTitle.isEmpty{
            return
        }
        
        let newList = CreateNewCustomListReq(title: listTitle,intro: self.intro)
        self.isLoading = true
        self.err = nil
        APIService.shared.CreateCustomList(req: newList){ (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result{
                case .success(let data):
                    if self.userModel.profile!.UserCustomList == nil {
                        self.userModel.profile!.UserCustomList = []
                    }
                    
                    let listInfo = CustomListInfo(id: data.id, title: data.title,intro:data.intro, movie_list: nil)
                    userModel.profile!.UserCustomList!.append(listInfo)
                    self.err = nil
                    withAnimation(){
                        self.isCreateList = false
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    self.err = err
                }
            }
        }
    }
}

//struct CreateMovieList_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateMovieList()
//    }
//}
