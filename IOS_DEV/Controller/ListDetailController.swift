//
//  ListDetailController.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/9/22.
//

import Foundation
class ListDetailController: ObservableObject {

    let listService = ListService()
    @Published var listData:[CustomList] = []
    @Published var mylistData:[CustomList] = []
    @Published var listDetails:[ListDetail] = []
    
    //---------------------新增片單中的電影---------------------//
    func postListMovie(listTitle:String, UserName: String, movieID: Int, movietitle: String, posterPath: String, feeling: String, ratetext: Int){
      
        let newlistDetail = NewListMovie(listTitle: listTitle, UserName: UserName, movieID: movieID, movietitle: movietitle, posterPath: posterPath, feeling: feeling, ratetext: ratetext)
        listService.POST_ListDetails(endpoint: "/list/detail/new",RegisterObject: newlistDetail ){ (result) in
            switch result {
            case .success(let result):
                print("post movie success")
                print(result)

            case .failure:
                print("post movie failed")
            }
            
        }

    }

    //---------------------更新片單中的電影---------------------//
    func putListMovie(ListDetailID: UUID, feeling: String, ratetext: Int){
      
        let newlistDetail = UpdateListMovie(ListDetailID: ListDetailID, feeling: feeling, ratetext: ratetext)
        listService.PUT_ListDetails(endpoint: "/list/detail/update",RegisterObject: newlistDetail ){ (result) in
            switch result {
            case 200 :
                print("put movie success")

            default:
                print("put movie failed")
            }
            
        }

    }
    
    //---------------------刪除片單中的電影---------------------//
    func deleteListMovie(ListDetailID: UUID){
      
        listService.DELETE_ListDetails(endpoint: "/list/detail/delete/\(ListDetailID)"){ (result) in
            switch result {
            case 200 :
                print("delete movie success")

            default:
                print("delete movie failed")
            }
            
        }

    }
    
  
   



}
