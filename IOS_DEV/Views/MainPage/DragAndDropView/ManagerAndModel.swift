//
//  ManagerAndModel.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import Foundation
import SwiftUI
import UIKit
import MobileCoreServices

class PreviewModel : ObservableObject{
    private let apiService : APIService
    //Manage preview data and preview list and preview http request

    @Published var isShowPreview : Bool = false
    @Published var previewData : MoviePreviewInfo? //get the movie
    @Published var previewDataList : [MoviePreviewInfo] = []
    @Published var fetchError: NSError? = nil
    @Published var fetchPreLoading : Bool = false
    
    //More result preview
    @Published var isFetchingPreviewList : Bool = false
    @Published var fetchingPreviewListErr : NSError? = nil
    
    init(apiService : APIService = APIService.shared){
        self.apiService = apiService
    }
    
    func getMoviePreview(selectedDatas referenceData : [DragItemData]){
        self.previewDataList.removeAll()
        self.previewData = nil
        
        self.fetchPreLoading = true
        var ref : [SearchRef] = []
        ref.append(contentsOf: referenceData.map{info -> SearchRef in
            switch info.itemType{
            case .Genre:
                return SearchRef(id: info.genreData!.id, type: .Genre)
            case .Actor:
                return SearchRef(id: info.personData!.id, type: .Persons)
            case .Director:
                return SearchRef(id: info.personData!.id, type: .Persons)
            }
        })
        
        
        DispatchQueue.main.async{
            self.apiService.getPreviewMovie(datas: ref){ [weak self] result in
                guard let self = self else {return}
                switch result{
                case .success(let response):
//                    print(response)
                    self.previewData = response[0]
                    self.previewDataList = response
                    self.fetchError = nil
                    break
                case .failure(let error):
                    if error as! APIError != APIError.noData{
                        let err = error as NSError
                        print(err.localizedDescription)
                        self.fetchError = error as NSError
                    }
                }
                self.fetchPreLoading = false
                
            }
        }
    }
    
//    func getMorePreviewResults(selectedDatas referenceData : [DragItemData]? = nil){
////        self.isFetchingPreviewList = true
////        self.fetchingPreviewListErr = nil
////
////        //or some argument to provide
////        apiService.getPreviewMovieList(){ [weak self ] result in
////            guard let self = self else {return}
////            switch(result){
////            case .success(let response):
////                self.previewDataList.append(contentsOf: response)
////                self.isFetchingPreviewList = false
////                print(self.previewDataList.count)
////                break
////            case .failure(let error):
////                self.isFetchingPreviewList = false
////                self.fetchingPreviewListErr = error as NSError
////                break
////            }
////        }
//    }
    
}

class DragSearchModel : ObservableObject,DropDelegate {
    
    //This Part is for dragAndDropCar
    @Published var selectedPreviewDatas : [DragItemData] = [] //here we are getting all the movies info that user is selected
    @Published var dragActor : [DragItemData] = []
    @Published var dragDirector : [DragItemData] = []
    @Published var dragGenre : [DragItemData] = []
    @Published var selectedTab : Tab = .Actor
    @Published var filter : Tab = .All
    
    private var fetchingActorPage : Int = 1 //start at page 2 ,coz init function is fetched page 1
    private var fetchingDirectorPage : Int = 1 //start at page 2 ,coz init function is fetched page 1
    @Published var actorHTTPErr : NSError? = nil //is there any error when fetching??
    @Published var genreHTTPErr : NSError? = nil //is there any error when fetching??
    @Published var directorHTTPErr : NSError? = nil //is there any error when fetching??
    @Published var isActorLoading : Bool = false //is there any error when fetching??
    @Published var isDirectorLoading : Bool = false //is there any error when fetching??
    @Published var isGenreLoading : Bool = false //is there any error when fetching??
    @Published var isFinished : Bool = false

    private let apiService : APIService
    private let maxSelectedItem = 10;
    init(apiService : APIService = APIService.shared) {
        self.apiService = apiService
        getActorsList(succeed: {
            print("Data Fetching succeed")
        }, failed: {
            print("Data Fetching Failed")
        })
        getDirectorList(succeed: {
            print("Data Fetching succeed")
        }, failed: {
            print("Data Fetching Failed")
        })
        getGenreList()
    }
    
    func getActorsList(updateDataAt at : updateInsertPosition = .back, succeed actionSucceed :  @escaping (()->()),failed actionFailed : @escaping (()->())){
        //Avoid self referecing
        self.isFinished = false
        self.isActorLoading = true
        apiService.fetchActors(page: self.fetchingActorPage){ [weak self ] results in
            guard let self = self else {return}
            switch results{
            case .success(let responses):
                DispatchQueue.main.async {
                    self.fetchingActorPage += 1
                    self.isFinished = true
                }
                switch at {
                case .front:
                    withAnimation(){
                        self.dragActor.insert(contentsOf: responses.response.map{DragItemData(id:UUID().uuidString,itemType: .Actor, genreData: nil, personData: $0) }, at: 0)
                    }
                    break
                case .back:
                    withAnimation{
                        self.dragActor.append(contentsOf: responses.response.map{DragItemData(id:UUID().uuidString,itemType: .Actor, genreData: nil, personData: $0)})
                    }
                    break
                }
                self.actorHTTPErr = nil
                self.isActorLoading = false
                actionSucceed()
                break
            case .failure(let error):
                self.isActorLoading = false
                self.actorHTTPErr = error as NSError
                print(self.actorHTTPErr!.localizedDescription)
                actionFailed()
                break
            }
        }
    }
    
    func getDirectorList(updateDataAt at : updateInsertPosition = .back,succeed actionSucceed :  @escaping (()->()),failed actionFailed : @escaping (()->())){
        self.isFinished = false
        self.isDirectorLoading = true
        apiService.fetchDirectors(page: self.fetchingDirectorPage){ [weak self ] results in
            guard let self = self else {return}
            switch results{
            case .success(let responses):
                DispatchQueue.main.async {
                    self.fetchingDirectorPage += 1
                    self.isFinished = true
                }
                switch at {
                case .front:
                    withAnimation(){
                        self.dragDirector.insert(contentsOf: responses.response.map{DragItemData(id:UUID().uuidString,
itemType: .Director, genreData: nil, personData: $0) }, at: 0)
                    }
                    break
                case .back:
                    withAnimation{
                        self.dragDirector.append(contentsOf: responses.response.map{DragItemData(id:UUID().uuidString,
itemType: .Director, genreData: nil, personData: $0)})
                    }
                    break
                }
                self.directorHTTPErr = nil
                self.isDirectorLoading = false
                actionSucceed()
                break
            case .failure(let error):
                self.isDirectorLoading = false
                self.directorHTTPErr = error as NSError
                print(self.directorHTTPErr!.localizedDescription)
                actionFailed()
                break
            }
        }
    }
    
    func getGenreList(){
        self.isGenreLoading = true
        apiService.fetchAllGenres(){ [weak self ]results in
            guard let self = self else {return}
            switch results{
            case .success(let responses):
                self.dragGenre.append(contentsOf: responses.response.map{DragItemData(id:UUID().uuidString,itemType: .Genre, genreData:$0, personData: nil)})
                self.genreHTTPErr = nil
                self.isGenreLoading = false
                break
            case .failure(let error):
                self.isGenreLoading = false
                self.genreHTTPErr = error as NSError
                print(self.genreHTTPErr!.localizedDescription)
                break
            }
        }
    }
    
    //get the list with the tab its selected!
    func getSelectedListWithFilter() -> [DragItemData]{
        if selectedPreviewDatas.isEmpty{
            return []
        }
        switch self.filter {
        case .All:
            return self.selectedPreviewDatas

        case .Genre:
            return self.selectedPreviewDatas.filter{$0.itemType == .Genre}
            
        case .Actor:
            return self.selectedPreviewDatas.filter{$0.itemType == .Actor}

        case .Director:
            return self.selectedPreviewDatas.filter{$0.itemType == .Director}

        }
    }
    
    func getMaxSelectedItem() -> Int{
        self.maxSelectedItem
    }

    func performDrop(info: DropInfo) -> Bool {
        // just allow to drop at most 10 Card

        for imgProvider in info.itemProviders(for: [String(kUTTypeURL)]){
            if imgProvider.canLoadObject(ofClass: URL.self){
                let _ = imgProvider.loadObject(ofClass: URL.self){ (CardId,err) in
                    let checkState = self.selectedPreviewDatas.contains{ (exist) -> Bool in
                        return exist.id == "\(CardId!)"
                    }

                    //Get the item is exist in current list or not
                    //If not exist append to current list
                    if !checkState {
                        //We need to find the current data in provider lsit first
                        //and we can get is Actor? Director? Genre
                        //But we don't know the card in which list
                        // we need to figure our first
//
                        if self.selectedPreviewDatas.count == self.maxSelectedItem{
                            return
                        }
                        
                        
                        let actor = self.dragActor.filter{(item) -> Bool in
                            return item.id == "\(CardId!)"
                        }

                        let director = self.dragDirector.filter{(item) -> Bool in
                            return item.id == "\(CardId!)"
                        }

                        let genre = self.dragGenre.filter{(item) -> Bool in
                            return item.id == "\(CardId!)"
                        }

                        //Either one is not empty
                        
                        if !actor.isEmpty {
//
                            DispatchQueue.main.async {
//                                withAnimation(.default){
//                                    self.fetchPreLoading = true
//
//                                }
                                
                                withAnimation(.default){
                                    self.selectedPreviewDatas.insert(actor.first!, at: 0) //we have already check is not empty
                                }
                            }
 
                        }
                        else if !director.isEmpty {
                
                            DispatchQueue.main.async {
//                                withAnimation(.default){
//                                    self.fetchPreLoading = true
//                                }
//
                                withAnimation(.default){
                                    self.selectedPreviewDatas.insert(director.first!, at: 0) //we have already check is not empty
                                }
                            }
                        }
                        else if !genre.isEmpty {
//
                            DispatchQueue.main.async {
//                                withAnimation(.default){
//                                    self.fetchPreLoading = true
//                                }
//
                                withAnimation(.default){
                                    self.selectedPreviewDatas.insert(genre.first!, at: 0) //we have already check is not empty
                                }
                            }
                        
                        }

                    }
                }
            }
            else {
                print("URL can't load")
            }


        }
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal.init(operation: .move)
    }

}

class SearchBarViewModel : ObservableObject{
    @Published var searchingText : String = ""
    
    @Published var searchResult : [Movie] = [] //For Result View
    @Published var searchRecommandResult : [MovieSearchInfo] = [] //For Preivew Result View
    @Published var searchResultPage : Int = 1
    @Published var isLoading : Bool = false
    @Published var fetchingError : NSError?
    @Published var recommandPlachold : String = "Movie Name"
    
    @Published var hotList : [SearchHotItem] = []
    @Published var isHotListLoading : Bool = false
    @Published var hotListErr : NSError? = nil

    @Published var isNoData : Bool = false
    @Published var isNoResult : Bool = false
    private let movieService: MovieService
    private let apiService: APIService
    
    
    init(movieService: MovieService = MovieStore.shared,apiService : APIService = APIService.shared) {
        self.movieService = movieService
        self.apiService = apiService
//        self.hotSearchingDatas = HotTest
    }
    
    //This function is used for preview searching
    func getRecommandationList(){
//        //when the return button is press
        searchRecommandResult.removeAll()
        movieService.searchRecommandMovie(query: searchingText){ [weak self] result in
            guard let self = self else { return }
            self.isLoading = true
            switch result{
            case.success(let response):
                //Save the page???
//                self.searchResult = response.results
                self.searchRecommandResult = response.results
                self.isLoading = false
            case .failure(let error):
                
                self.fetchingError = error as NSError
            }
        }
    }
    
    //This function for fetching detail result
    func getSearchingResult(){
        self.isNoResult = false
        self.isLoading = true
        movieService.searchMovieInfo(query: searchingText, page: 1){ [weak self] result in
            guard let self = self else { return }
            self.isLoading = true
            switch result{
            case.success(let response):
                if response.results.isEmpty{
                    self.isNoResult = true
                    break
                }
//                self.isNoData =  response.total_pages <= self.searchResultPage

            
                self.searchResult.append(contentsOf: response.results.map{$0})
                self.searchResultPage += 1
            case .failure(let error):
                self.fetchingError = error as NSError
            }
            self.isLoading = false
        }
    }
    
    func getMoreSearchingResult(succeed actionSucceed:@escaping ()->(), failed actionFailed:@escaping ()->()){
        //This function will only work ,when more datas is available
        //Base on the result page
        if isNoData {
            actionSucceed()
            return
        }
        
        movieService.searchMovieInfo(query: searchingText, page: searchResultPage){ [weak self] result in
            guard let self = self else { return }
            self.isLoading = true
            switch result{
            case.success(let response):
                self.searchResult.append(contentsOf: response.results.map{$0})
                self.searchResultPage += 1
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
//                    self.isNoData =  response.total_pages <= self.searchResultPage
                }
                actionSucceed()

            case .failure(let error):
                self.fetchingError = error as NSError
                actionFailed()
            }
            self.isLoading = false
        }
    }
    
    func getHotSeachList(){
        self.hotList.removeAll()
        self.isHotListLoading = true
        apiService.getHotSeachingList(){ [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let response):
                self.hotList.append(contentsOf: response.map{$0})
                self.recommandPlachold = self.hotList.randomElement()!.title
            case .failure(let error):
                self.hotListErr = error as NSError

            }
            self.isHotListLoading = false
        }
    }
    

}

class SeachingViewStateManager : ObservableObject{
    //For all state in searching view
    @Published var isSeaching : Bool = false // this for opening the searhing model,for main searching page only
    @Published var isRemove : Bool = false
    @Published var isFocuse : [Bool] = [false,true] //we are only using [1] true mean open the keybody
    @Published var isEditing : Bool = false
    @AppStorage("seachHistory") var history : [String] =  []
    
    //going to share the searching text between the view
//    @Published var searchingText : String = ""
    @Published var getSearchResult : Bool  = false
    
    @Published var previewResult : Bool = false
    @Published var previewMoreResult : Bool = false
    @Published var isFetchingPreview : Bool = true
    @Published var isFetchingPreviewErr : NSError? = nil
    
    //just for try!
    @Published var searchingLoading : Bool = true
    
    func updateSearchingHistory(query : String){
        if self.history.count == 15{
            self.history.removeLast()
        }
        
        let exist = self.history.contains{$0 == query}
        if exist{
            //the string is inside the collection
            let index = self.history.firstIndex(of: query)
            self.history.remove(at: index!)
        }
        self.history.insert(query, at: 0)
    }
    
    func removeAllHistory(){
        self.history.removeAll()
    }
}


struct MovieRule : Identifiable,Hashable{
    let id :String = UUID().uuidString //for now just dummy id
    let name : String
    let rule : CharacterRule
    let postURL : String
}
