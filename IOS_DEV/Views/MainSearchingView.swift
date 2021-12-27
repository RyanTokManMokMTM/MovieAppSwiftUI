//
//  MainSearchingView.swift
//  IOS_DEV
//
//  Created by Jackson on 15/5/2021.
//

import SwiftUI

import SDWebImageSwiftUI


import SwiftUI

struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    @Binding var isHidden : Bool
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text ,searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>,searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Movie Name,Actor Name..."
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
            
            
        }
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
    
}
struct YourView: View {
    // Search string to use in the search bar
    @State var searchString = ""
    @State var isHidden = false
    let dataArray = ["Jackson","Tome","dummy"]
    
    // Search action. Called when search key pressed on keyboard
    func search() {
    }
    
    // Cancel action. Called when cancel button of search bar pressed
    func cancel() {
    }
    
    // View body
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    HStack{
                        Text("Discover")
                            .bold()
                            .font(.title2)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    CardScroll(isCardSelectedMovie: .constant(false))
                        .padding(.top)
                }
                .padding(.top,10)
                
                VStack{
                    MovieScrollList(listTitle: "Upcomming",MovieList: coverList)
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
            .navigationTitle("")
            .navigationBarTitle("",displayMode: .inline)
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading){
                    HStack{
                        Image(systemName: "film")
                        Text("Movies")
                            .bold()
                            .font(.title)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.bottom)
                }
            })
        }
    }
            
        // Search Navigation. Can be used like a normal SwiftUI NavigationView.
//        SearchNavigation(text: $searchString, isHidden: $isHidden, search: search, cancel: cancel) {
//            // Example SwiftUI View
//            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false){
//                VStack{
//                    HStack{
//                        Text("Discover")
//                            .bold()
//                            .font(.title)
//                            .padding(.horizontal)
//
//                        Spacer()
//                    }
//
//                    CardScroll()
//                        .padding(.top)
//                }
//            }
//            .navigationBarTitle("")
//            .toolbar(content: {
//                ToolbarItemGroup(placement: .navigationBarLeading){
//                    Text("Movies")
//                        .bold()
//                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                        .padding(.vertical)
//                }
//
//                ToolbarItemGroup(placement: .navigationBarTrailing){
//                    HStack{
//                        Image(systemName: "magnifyingglass.circle.fill")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//
//                        Image(systemName: "photo.on.rectangle.angled")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                    }
//
//                }
//
//
//            })
//
//        }
//        .edgesIgnoringSafeArea(.top)
//        .onAppear{
//            UIScrollView().bounces = true
//
//        }
    
}
//
//struct MainSearchingView: View {
//    var planets = ["Mercury", "Venus", "Earth", "Mars"]
//    var searchControllerProvider: SearchControllerProvider = SearchControllerProvider()
//    @State var searchText: String = ""
//
//     var body: some View {
//        NavigationView {
//            List {
//                TextField("Search", text: $searchText)
//                    .padding(7)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//
//                ForEach(
//                    planets.filter {
//                        searchText.isEmpty ||
//                            $0.localizedStandardContains(searchText)
//                    },
//                    id: \.self
//                ) { eachPlanet in
//                    Text(eachPlanet)
//                }
//            }
//            .navigationBarTitle("Planets")
//            .overlay(
//                ViewControllerResolver { viewController in
//                    viewController.navigationItem.searchController =
//                        self.searchControllerProvider.searchController
//                }
//                    .frame(width: 0, height: 0)
//            )
//        }
//     }
//    //        NavigationView{
//    //
//    //            VStack{
//        //                if !isHidden{
//        //                    SearchBar(text: .constant(""))
//        //                        .animation(.easeInOut)
//        //                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
//        //                        .padding(.top)
//        //                }
//        //
//        //
//        //                ScrollView(.vertical, showsIndicators: false){
//        //                    ForEach(0..<50,id:\.self){i in
//        //                        Text("\(i)")
//        //                            .padding()
//        //                    }
//        //                    .frame(width: UIScreen.main.bounds.width)
//        //                }
//        //
//        //            }
//        //            .navigationTitle("")
//        //            .navigationBarTitle("Searching")
//        //            .navigationBarTitleDisplayMode(.inline)
//        //            .toolbar{
//        //                ToolbarItemGroup(placement: .navigation){
//        //                    Text("Movies")
//        //                        .font(.title)
//        //                        .bold()
//        //
//        //                }
//        //                ToolbarItemGroup(placement: .navigationBarTrailing){
//        //                    Image(systemName: "magnifyingglass.circle.fill")
//        //                        .resizable()
//        //                        .frame(width: 25, height: 25)
//        //                        .onTapGesture {
//        //                            self.isHidden.toggle()
//        //                        }
//        //                }
//        //
//        //            }
//        //        }
//
//}

struct MainSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            YourView()
               
        }
    }
}



struct SearchView:UIViewRepresentable{
    func makeUIView(context: Context) -> UISearchBar {
        let controller = UISearchController()
        controller.searchBar.placeholder = "Moive Name,Actor Name etc..."
        
        return controller.searchBar
    }
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        //update the text
    }
}


struct CustomNavigationController<Content:View> : UIViewControllerRepresentable{
    let content: ()->Content
    
  

    func makeUIViewController(context: Context) -> UIViewController {
        let childView = UIHostingController(rootView: self.content())
        let controller = UINavigationController(rootViewController: childView)
        
        controller.navigationBar.topItem?.title = "Searching"
        controller.navigationBar.prefersLargeTitles = true

        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Movie Type, Actor..."
        searchController.obscuresBackgroundDuringPresentation = false
   //     searchController.hidesNavigationBarDuringPresentation = false
        
        
        controller.navigationBar.topItem?.searchController = searchController
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "google"), style: .plain, target: self, action:nil)
        

        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }

    class coordiator:NSCoder{

    }
}
