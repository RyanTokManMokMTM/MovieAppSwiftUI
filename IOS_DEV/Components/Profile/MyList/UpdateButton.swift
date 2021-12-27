//
//  UpdateButton.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/18.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

//控制在ListDetailView的動作（新增,編輯,刪除）

struct UpdateButton:View{
    @State var open = false
    @Binding var CreateAction : Bool
    @Binding var EditAction : Bool
    @Binding var DeleteAction : Bool
    

    var body:some View{
        
        ZStack(alignment: .trailing){
            CreateListMovieButton(open: $open, CreateAction: self.$CreateAction)
            EditListMovieButton(open: $open, EditAction: self.$EditAction)
            DeleteListMovieButton(open: $open, DeleteAction: self.$DeleteAction)
            
            smallNavButton(buttonColor: .gray, buttonTextColor: .white, text: "action"){
                self.open.toggle()
            }
          
            
          
            
        }

    }

}


//struct EditButton_Previews: PreviewProvider {
//    static var previews: some View {
//
//        EditButton()
//    }
//}

//----------------新增list電影的按鈕----------------//
struct CreateListMovieButton:View{
    @Binding var open : Bool
    @Binding var CreateAction : Bool
    var offsetX = 0
    var offsetY = 0
    var delay = 0.0

    var body:some View{
        Button(action: {
            self.CreateAction.toggle()
        })
        {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size:16,weight: .bold))
        }
        .padding()
        .frame(width: 60, height: 30)
        .font(.system(size: 15))
        .background(Color("CustomBlue"))
        .cornerRadius(20)
        .offset(x: open ? CGFloat(70) : 0 )
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(Double(delay)))
        
    }

}
//----------------編輯list電影的按鈕----------------//
struct EditListMovieButton:View{
    @Binding var open : Bool
    @Binding var EditAction : Bool
    var offsetX = 0
    var offsetY = 0
    var delay = 0.0

    var body:some View{
        Button(action: {
            self.EditAction.toggle()
        })
        {
            Image(systemName: "pencil")
                .foregroundColor(.white)
                .font(.system(size:16,weight: .bold))
        }
        .padding()
        .frame(width: 60, height: 30)
        .font(.system(size: 15))
        .background(Color("CustomPurple"))
        .cornerRadius(20)
        .offset(x: open ? CGFloat(140) : 0 )
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(Double(delay)))
        
    }

}
//----------------刪除list電影的按鈕----------------//
struct DeleteListMovieButton:View{
    @Binding var open : Bool
    @Binding var DeleteAction : Bool
    var offsetX = 0
    var offsetY = 0
    var delay = 0.0

    var body:some View{
        Button(action: {
            self.DeleteAction.toggle()
        })
        {
            Image(systemName: "trash")
                .foregroundColor(.white)
                .font(.system(size:16,weight: .bold))
        }
        .padding()
        .frame(width: 60, height: 30)
        .font(.system(size: 15))
        .background(Color("CustomRed"))
        .cornerRadius(20)
        .offset(x: open ? CGFloat(210) : 0 )
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(Double(delay)))
    }

}

//----------------新增list中的電影----------------//
struct CreateListMovie:View{
    @ObservedObject private var movieSearchState = MovieSearchState()
    @Binding var CreateAction:Bool
    @State var listOwner:String //片單創建者
    @State var listTitle:String //片單名稱
    
    var body:some View{
        
            //--------搜尋想新增的電影---------//
            NavigationView {
                
                VStack{
                    
                    SearchBarView(placeholder: "Search movies", text: self.$movieSearchState.query)
                        .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                        
                  
                    
                    ScrollView(.vertical){
                        LoadingView(isLoading: self.movieSearchState.isLoading, error: self.movieSearchState.error) {
                            self.movieSearchState.search(query: self.movieSearchState.query)
                        }
                        
                        if self.movieSearchState.movies != nil {
                            ForEach(self.movieSearchState.movies!) { movie in
                                NavigationLink(destination: CreateListMovieDetail(movie:movie, CreateAction: self.$CreateAction,listOwner:self.listOwner,listTitle:self.listTitle)) {
                                    VStack(alignment: .leading) {
                                        
                                        HStack(spacing:5){
                                            Text(movie.title)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 20).bold())
                                                .padding()
                                            
                                            Text(movie.yearText)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16))
                                        }
                                        
                                        
                                        Divider()
                                            .padding(.horizontal)
                                     
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .onAppear {
                    self.movieSearchState.startObserve()
                }
                .navigationBarTitle("ADD NEW MOVIE")
                .toolbar{
                    Button(action:{
                        self.CreateAction.toggle()
                    }){
                        Text("Cancel")
                    }
                }
               
            }
           
            

    }

}

struct CreateListMovieDetail:View{
    @ObservedObject private var controller = ListDetailController()
    @State var starColor : Int = 0
    @State var movie : Movie
    @State private var text:String = " "
    @Binding var CreateAction:Bool
    @State var listOwner:String //片單創建者
    @State var listTitle:String //片單名稱
 
    
    var body: some View
    {
        GeometryReader { proxy in
            let size = proxy.size
            

            ScrollView(.vertical){
            VStack(alignment: .leading,spacing:5){
                VStack(alignment: .leading,spacing:10){

                    Text(movie.title)
                        .font(.title.bold())
                        .kerning(1.5)

                    Text(movie.yearText)
                        .kerning(1.2)
                        .font(.body)

                }
                    // movie pic
                    WebImage(url: movie.posterURL)
                        .resizable()
                        .frame(width: size.width-40, height: size.height/2)
                        .cornerRadius(12)

                 

                    // user card
                    VStack(alignment:.center, spacing:15){

                        HStack{
                            Text("評分：")
                                .font(.body)
                                .kerning(1.5)
                                .foregroundColor(.gray)
                            
                            Spacer(minLength: 0)
                            
                            HStack(spacing: 0){
                                ForEach(1..<6){ index in
                                  Image(systemName: "star.fill")
                                    .foregroundColor(starColor >= index ? .yellow : .gray)
                                    .onTapGesture {
                                        starColor = index
                                    }
                                }
                            }
                            
                            
                        }
                        
                
                        HStack(spacing:25){
                            Text("心得：")
                                .font(.body)
                                .kerning(1.5)
                                .foregroundColor(.gray)

                            Spacer(minLength: 0)
                            
                            VStack(alignment: .leading,spacing:6){
                                TextEditor(text: $text)
                                    .padding(3)
                                    .foregroundColor(.black)
                                    .background(Color(.gray).opacity(0.1))
                                    .onAppear {
                                        UITextView.appearance().backgroundColor = .white
                                    }
                                    
                                    
                                   
                            }
                       

                        }



                    }
                    .padding(20)
                    .frame(width: size.width-40)
                    .background(Color.white)
                    .cornerRadius(4)
                    
                
                //--------save button---------//

                HStack(alignment: .center, spacing: 15) {
                    Spacer(minLength: 0)
                    Button(action: {
                        controller.postListMovie(listTitle: listTitle, UserName: listOwner, movieID: movie.id, movietitle: movie.title, posterPath: movie.posterPath!, feeling: self.text, ratetext: self.starColor)
                        self.CreateAction.toggle()
                    })
                    {
                        HStack{
                            Image(systemName: "plus")
                            Text("Add")

                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(40)

                    }
                    .disabled(self.text == " " ? true : false)
                    .opacity(self.text == " " ? 0.5 : 1)

                    
                    Button(action:{
                        self.CreateAction.toggle()
                    }){
                        HStack{
                            Text("Cancel")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("CustomRed"))
                        .cornerRadius(40)
                        
                    }
                   


                }
                .padding()
                    
                }
               
            }
            .padding(20)
            .navigationBarTitle("")
            .navigationBarHidden(true)

        }

    }
    


}


//----------------編輯list中的電影----------------//

struct EditListMovie:View{
    @ObservedObject private var controller = ListDetailController()
    @State var starColor : Int = 0
    @State private var text:String = " "
    @Binding var EditAction:Bool
    @State var current: ListDetail //要編輯的movie
    @State var listTitle:String //片單名稱
 
    
    var body: some View
    {
        
        

        GeometryReader { proxy in
            let size = proxy.size
            

            
            VStack(alignment: .leading,spacing:5){
                VStack(alignment: .leading,spacing:10){

                    Text(current.title)
                        .font(.title.bold())
                        .kerning(1.5)

                    Text(listTitle)
                        .kerning(1.2)
                        .font(.body)

                }
                
                
                ScrollView(.vertical){
                    
                    // movie pic
                    WebImage(url: current.posterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width-40, height: size.height/2)
                        .cornerRadius(12)

                 

                    // user card
                    VStack(alignment:.leading, spacing:15){

                        HStack{
                            Text("評分：")
                                .font(.body)
                                .kerning(1.5)
                                .foregroundColor(.gray)

                            Spacer(minLength: 0)
                            
                            HStack(spacing: 0){
                                ForEach(1..<6){ index in
                                  Image(systemName: "star.fill")
                                    .foregroundColor(starColor >= index ? .yellow : .gray)
                                    .onTapGesture {
                                        starColor = index
                                    }
                                }
                            }
                            
                            
                        }
                        
                
                        HStack(spacing:25){
                            Text("心得：")
                                .font(.body)
                                .kerning(1.5)
                                .foregroundColor(.gray)

                            Spacer(minLength: 0)
                            
                            VStack(alignment: .leading,spacing:6){
                                TextEditor(text: $text)
                                    .padding(3)
                                    .foregroundColor(.black)
                                    .background(Color(.gray).opacity(0.1))
                                    .onAppear {
                                        UITextView.appearance().backgroundColor = .white
                                    }
                                   
                                   
                                    
                                   
                            }
                       

                        }



                    }
                    .padding(20)
                    .frame(width: size.width-40)
                    .background(Color.white)
                    .cornerRadius(4)
                    .onAppear{
                        self.text = current.feeling
                        self.starColor = current.ratetext
                    }
                    
                    
                }
                
                //--------save button---------//

                HStack(alignment: .center, spacing: 15) {
                    Spacer(minLength: 0)
                    Button(action: {
                        controller.putListMovie(ListDetailID: current.id!, feeling: self.text, ratetext: self.starColor)
                        self.EditAction.toggle()
                    })
                    {
                        HStack{
                            Text("Save")

                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(40)

                    }
                    .disabled(self.text == " " ? true : false)
                    .opacity(self.text == " " ? 0.5 : 1)

                    
                    Button(action:{
                        self.EditAction.toggle()
                    }){
                        HStack{
                            Text("Cancel")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("CustomRed"))
                        .cornerRadius(40)
                        
                    }
                   


                }
                .padding()
               
            }
            .padding(20)
            .navigationBarTitle("")
            .navigationBarHidden(true)

        }

    }
    


}
