//
//  ActorAvatarList.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//


import SwiftUI
import SDWebImageSwiftUI

struct ActorAvatarList: View {
    let cast: [MovieCast]
    @ObservedObject private var personSearchState0 = PersonSearchState()
    @ObservedObject private var personSearchState1 = PersonSearchState()
    @ObservedObject private var personSearchState2 = PersonSearchState()
    
    var body:some View{
        
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(){
                    Group{
                        LoadingView(isLoading: self.personSearchState0.isLoading, error: self.personSearchState0.error) {
                            self.personSearchState0.searchPerson(query: cast[0].name)
                        }
                        
                        if personSearchState0.person != nil {
                            NavigationLink(
                                destination: ActorMovieView(actor: personSearchState0.person!)
                                ){
                                Avatar(character: cast[0].character, actorList: personSearchState0.person!.first!)
                            }
                            
                        }
                    }
                    
                    Group{
                        LoadingView(isLoading: self.personSearchState1.isLoading, error: self.personSearchState1.error) {
                            self.personSearchState1.searchPerson(query: cast[1].name)
                        }
                        
                        if personSearchState1.person != nil {
                            NavigationLink(
                                destination: ActorMovieView(actor: personSearchState1.person!)
                            ){
                                Avatar(character: cast[1].character, actorList: personSearchState1.person!.first!)
                            }
                           
                        }
                    }
                    
                    Group{
                        LoadingView(isLoading: self.personSearchState2.isLoading, error: self.personSearchState2.error) {
                            self.personSearchState2.searchPerson(query: cast[2].name)
                        }
                        
                        if personSearchState2.person != nil {
                            NavigationLink(
                                destination: ActorMovieView(actor: personSearchState2.person!)
                            ){
                                Avatar(character: cast[2].character, actorList: personSearchState2.person!.first!)
                            }
            
                        }
                    }
                    
//                    Group{
//                        LoadingView(isLoading: self.personSearchState3.isLoading, error: self.personSearchState3.error) {
//                            self.personSearchState3.searchPerson(query: cast[3].name)
//                        }
//
//                        if personSearchState3.person != nil {
//                            NavigationLink(
//                                destination: ActorMovieView(actor: personSearchState3.person!)
//                            ){
//                                Avatar(character: cast[3].character, actorList: personSearchState3.person!.first!)
//                            }
//
//                        }
//                    }
                    
//                    Group{
//                        LoadingView(isLoading: self.personSearchState4.isLoading, error: self.personSearchState4.error) {
//                            self.personSearchState4.searchPerson(query: cast[4].name)
//                        }
//
//                        if personSearchState4.person != nil {
//                            NavigationLink(
//                                destination: ActorMovieView(actor: personSearchState4.person!)
//                            ){
//                                Avatar(character: cast[4].character, actorList: personSearchState4.person!.first!)
//                            }
//                        }
//                    }
                    
//                    Group{
//                        LoadingView(isLoading: self.personSearchState5.isLoading, error: self.personSearchState5.error) {
//                            self.personSearchState5.searchPerson(query: cast[5].name)
//                        }
//
//                        if personSearchState5.person != nil {
//                            NavigationLink(
//                                destination: ActorMovieView(actor: personSearchState5.person!)
//                            ){
//                                Avatar(character: cast[5].character, actorList: personSearchState5.person!.first!)
//                            }
//                        }
//                    }
                    
//                    Group{
//                        LoadingView(isLoading: self.personSearchState6.isLoading, error: self.personSearchState6.error) {
//                            self.personSearchState6.searchPerson(query: cast[6].name)
//                        }
//
//                        if personSearchState6.person != nil {
//                            NavigationLink(
//                                destination: ActorMovieView(actor: personSearchState6.person!)
//                            ){
//                                Avatar(character: cast[6].character, actorList: personSearchState6.person!.first!)
//                            }
//                        }
//                    }
                    
//                    Group{
//                        LoadingView(isLoading: self.personSearchState7.isLoading, error: self.personSearchState7.error) {
//                            self.personSearchState7.searchPerson(query: cast[7].name)
//                        }
//
//                        if personSearchState7.person != nil {
//                            NavigationLink(
//                                destination: ActorMovieView(actor: personSearchState7.person!)
//                            ){
//                                Avatar(character: cast[7].character, actorList: personSearchState7.person!.first!)
//                            }
//                        }
//                    }
                    
//                    Group{
//                        LoadingView(isLoading: self.personSearchState8.isLoading, error: self.personSearchState8.error) {
//                            self.personSearchState8.searchPerson(query: cast[8].name)
//                        }
//
//                        if personSearchState8.person != nil {
//                            NavigationLink(
//                                destination: ActorMovieView(actor: personSearchState8.person!)
//                            ){
//                                Avatar(character: cast[8].character, actorList: personSearchState8.person!.first!)
//                            }
//                        }
//                    }
                    
 
                    
                    
                            
                }
                
            }
            
        }
        .onAppear {
            self.personSearchState0.searchPerson(query: cast[0].name)
            self.personSearchState1.searchPerson(query: cast[1].name)
            self.personSearchState2.searchPerson(query: cast[2].name)
//            self.personSearchState3.searchPerson(query: cast[3].name)
//            self.personSearchState4.searchPerson(query: cast[4].name)
//            self.personSearchState5.searchPerson(query: cast[5].name)
//            self.personSearchState6.searchPerson(query: cast[6].name)
//            self.personSearchState7.searchPerson(query: cast[7].name)
//            self.personSearchState8.searchPerson(query: cast[8].name)
           
            
        }
       
    }
}

//struct ActorAvatarList_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ActorAvatarList(name: "LeBron James")
//
//    }
//}

struct Avatar:View{
    var character : String
    var actorList : Person
    var body:some View{
        VStack(spacing:5){
            
            WebImage(url: actorList.ProfileImageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(lineWidth: 1.0)
                        .foregroundColor(.purple)
                )
            
            Group{
                Text(actorList.name)
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                //    .multilineTextAlignment(.center)
                    .frame(width:120)
                
                Text(character)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(width:120)
            }
        }
        
    }
}
