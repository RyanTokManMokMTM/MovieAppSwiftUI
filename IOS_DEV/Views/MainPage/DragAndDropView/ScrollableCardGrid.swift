//
//  ScrollableCardGrid.swift
//  IOS_DEV
//
//  Created by Jackson on 6/11/2021.
//

import SwiftUI
import MobileCoreServices
import SDWebImageSwiftUI
import CoreHaptics


struct ScrollableCardGrid: View{
    @EnvironmentObject var dragPreviewModel : DragSearchModel
    @State private var coreHaptics : CHHapticEngine?
    @State private var isLoading : Bool = false
    let comlums = Array(repeating: GridItem(.flexible(),spacing: 10), count: 2)
    @Binding var list : [DragItemData]
    var cardType : CharacterRule
    @State private var offset:CGFloat = 0.0
    var isShow : Bool
    var beAbleToUpdate : Bool = true
    var isOffsetting : Bool = false
    var offsetVal : CGFloat = 0


    var body : some View{
        DragRefreshableScrollView(
            dataType : cardType ,
            datas: self.$list,
            isLoading: self.$isLoading,
            beAbleToUpdate : beAbleToUpdate,
            isOffsetting : isOffsetting,
            offsetVal : offsetVal,
            content: {
                VStack{
                    LazyVGrid(columns: comlums){
                        if cardType == CharacterRule.Genre{
                            ForEach(self.list,id:\.id){ data in
                                if data.genreData!.describe_img != ""{ //here we are know that is genre type
                                    VStack(spacing:3){
                                        WebImage(url: data.genreData!.posterImg)
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.5))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height:200)
                                            .cornerRadius(25)
                                            .onDrag{
                                                EngineSuccess()
                                                return NSItemProvider(contentsOf: URL(string: data.id))! }
                                        //
                                        Text(data.genreData!.name)
                                            .frame(width:120,height:50,alignment:.center)
                                            .lineLimit(2)
                                    }
                                    .padding(.top)
                                }
                            }
                        }else{
                            ForEach(self.list,id:\.id){ data in
                                if data.personData!.profile_path != ""{ //here we are know that is genre type
                                    VStack(spacing:3){
                                        WebImage(url: data.personData!.ProfileImageURL)
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.5))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height:200)
                                            .cornerRadius(25)
                                            .onDrag{
                                                EngineSuccess()
                                                return NSItemProvider(contentsOf: URL(string: data.id))! }
                                        //
                                        Text(data.personData!.name)
                                            .frame(width:120,height:50,alignment:.center)
                                            .lineLimit(2)
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                    }
                    
                    if beAbleToUpdate && self.isLoading {
                        VStack{
                            ActivityIndicatorView()
                        }
                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom,self.isShow ? 220 : 100)
            }, onRefresh: {control in
                
                if beAbleToUpdate{
                    self.isLoading = true
                    switch self.cardType {
                    case .Actor:
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                            dragPreviewModel.getActorsList(updateDataAt: .front, succeed: {
                                self.isLoading = false
                                control.endRefreshing()
                            }, failed: {
                                self.isLoading = false
                                control.endRefreshing()
                                print("Data fetching error")
                            })
                        }
                        break
                    case .Director:
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                            dragPreviewModel.getDirectorList(updateDataAt: .front, succeed: {
                                self.isLoading = false
                                control.endRefreshing()
                            }, failed: {
                                self.isLoading = false
                                control.endRefreshing()
                                print("Data fetching error")
                            })
                        }
                        break
                    default:
                        break
                    }
                    
                }
                
            })

        
        .onAppear(perform: initEngine)
    }

    private func initEngine(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        do {
            self.coreHaptics = try CHHapticEngine()
            try coreHaptics?.start()
        }catch {
            print("Engine Start Error:\(error.localizedDescription)")
        }
    }

    private func EngineSuccess(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        var engineEvent = [CHHapticEvent]()

        let intensitySetting = CHHapticEventParameter(parameterID: .hapticIntensity, value: 100)
        let sharpnessSetting = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensitySetting,sharpnessSetting], relativeTime: 0)

        engineEvent.append(event)

        do{
            let pattern = try CHHapticPattern(events: engineEvent, parameters: [])
            let player = try self.coreHaptics?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        }catch{
            print("Failed to player pattern")
        }
    }
}
