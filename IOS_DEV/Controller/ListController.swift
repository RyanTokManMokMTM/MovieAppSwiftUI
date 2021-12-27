//
//  ArticleController.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/6/5.
//

import Foundation
class ListController: ObservableObject {

    let listService = ListService()
    @Published var listData:[CustomList] = []
    @Published var mylistData:[CustomList] = []
    @Published var listDetails:[ListDetail] = []
    
    //---------------------所有的片單---------------------//
    func GetAllList(){
        listService.GET_allLists(endpoint: "/list"){ (result) in
            switch result {
            case .success(let lists):
                print("get all list")
                self.listData = lists
              

            case .failure: print("list failed")
            }
        }
    }
    //---------------------我的片單---------------------//
    func GetMyList(userID : UUID){
        listService.GET_allLists(endpoint: "/list/my/\(userID)"){ [self] (result) in
            switch result {
            case .success(let lists):
                print("get my list success")
                self.mylistData = lists

            case .failure: print("get my list failed")
            }
        }
    }
    
    //---------------------get某片單的內容---------------------//
    func GetListDetail(listID : UUID){
        listService.GET_ListsDetails(endpoint: "/list/detail/\(listID)"){ (result) in
            switch result {
            case .success(let lists):
                print("get list details")
                print(lists)
                self.listDetails = lists

            case .failure: print("list detail failed")
            }
        }
    }
    
    
    //---------------------新增空的片單---------------------//
    func postList(title:String){
      
        let newlist = NewList(UserName: NowUserName, Title: title )
        listService.POST_Lists(endpoint: "/list/new",RegisterObject: newlist ){ (result) in
            switch result {
            case .success(let lists):
                print("post list success")
                print(lists)

            case .failure:
                print("post list failed")
            }
            
        }

    }
    //---------------------更新片單---------------------//
    func putList(listID: UUID, listTitle: String){
      
        let update = UpdateList(listID: listID, listTitle: listTitle)
        listService.PUT_Lists(endpoint: "/list/update",RegisterObject: update ){ (result) in
            switch result {
            case 200 :
                print("put list success")

            default:
                print("put list failed")
            }
            
        }

    }
    //---------------------刪除片單---------------------//
    func deleteList(ListID: UUID){
      
        listService.DELETE_ListDetails(endpoint: "/list/delete/\(ListID)"){ (result) in
            switch result {
            case 200 :
                print("delete list success")

            default:
                print("delete list failed")
            }
            
        }
    }


}
