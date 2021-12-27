//
//  ChartView.swift
//  IOS_DEV
//
//  Created by Kao Li Chi on 2021/12/19.
//


import SwiftUI

struct ContentChartView: View {
    @StateObject var dramaData=dramaInfoData()
    let MovieData:[LikeMovie]
    let ArticleData:[LikeArticle]
    var body: some View {
        chartView(dramaData:dramaData,MovieData:MovieData,ArticleData:ArticleData)
    }
}

class dramaInfoData:ObservableObject{
    @AppStorage("MovieGenre") var dramaInfoData:Data?
    @Published var mydramaInfo=[MovieGenre](){
        didSet{ //property observer
            let encoder=JSONEncoder()
            do{
                let data=try encoder.encode(mydramaInfo)
                dramaInfoData=data
            }catch{
                
            }
        }
    }
    init(){
        if let dramaInfoData=dramaInfoData{
            let decoder=JSONDecoder()
            if let decodedData=try? decoder.decode([MovieGenre].self, from: dramaInfoData){
                mydramaInfo=decodedData
            }
        }
    }
}




struct typeLabel:View{
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var body: some View{
        VStack(alignment:.leading){
            ForEach(someDramaTypes.indices){(index) in
                HStack{
                    Circle()
                        .fill(pieChartColor[index])
                        .frame(width:10, height:10)
                    Text("\(someDramaTypes[index])")
                }
            }
        }
    }
}


struct typeLabelWithPercentage:View{
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var percentages:[Double]
    var columns = Array(repeating: GridItem(.flexible(),spacing:15), count: 2)
    var body: some View{
        VStack(alignment:.leading){
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(someDramaTypes.indices){(index) in
                    HStack{
                        Circle()
                            .fill(pieChartColor[index])
                            .frame(width:10, height:10)
                        Text("\(someDramaTypes[index])")
                        Text("\(percentages[index], specifier: "%.1f")%")
                    }.padding(5)
                    
                }
            }
        }
    }
}

struct chartView: View {
    @State private var chartType=0
    let someChartType=["為您分析", "電影", "文章"]
    @ObservedObject var dramaData=dramaInfoData()
    let MovieData:[LikeMovie]
    let ArticleData:[LikeArticle]
    var dramaTypeNumPercentage:[Double]=[0, 0, 0, 0, 0, 0, 0, 0]
    var dramaTypeNum:[Double]=[0, 0, 0, 0, 0, 0, 0, 0]
    var completePercentage:Double=0
    var body: some View {
        VStack(alignment:.center){
            Spacer()
            Text("喜愛項目")
                .bold()
                .padding([.top],5)
            Picker(selection: $chartType, label: Text(""), content: {
                ForEach(someChartType.indices){(index) in
                    Text("\(someChartType[index])")
                }
            }).pickerStyle(SegmentedPickerStyle())
            .padding(10)
            
            if chartType==0{
                pieChartView(percentages:dramaTypeNumPercentage)
                    .frame(width:250, height:250)
                    .padding(.bottom, 20)
                typeLabelWithPercentage(percentages:dramaTypeNumPercentage)
                    .frame(height:200)
            }else if chartType==1{
                VStack{
                    movieRecord(movies: MovieData)
                }
            }else if chartType==2{
                VStack{
                    articleRecord(articles: ArticleData)
                }
            }
            
        }
        
        Spacer()
        
        
    }
    //算各類型電影數量
    init(dramaData:dramaInfoData,MovieData:[LikeMovie],ArticleData:[LikeArticle]){
        self.dramaData=dramaData
        self.MovieData=MovieData
        self.ArticleData=ArticleData
        let total=dramaData.mydramaInfo.count
        dramaTypeNum=[0, 0, 0, 0, 0, 0, 0, 0]
        for index in 0..<total{
            if dramaData.mydramaInfo[index].name=="動作"{
                dramaTypeNum[0]+=1
            }else if dramaData.mydramaInfo[index].name=="冒險"{
                dramaTypeNum[1]+=1
            }else if dramaData.mydramaInfo[index].name=="動畫"{
                dramaTypeNum[2]+=1
            }else if dramaData.mydramaInfo[index].name=="喜劇"{
                dramaTypeNum[3]+=1
            }else if dramaData.mydramaInfo[index].name=="犯罪"{
                dramaTypeNum[4]+=1
            }else if dramaData.mydramaInfo[index].name=="紀錄"{
                dramaTypeNum[5]+=1
            }else if dramaData.mydramaInfo[index].name=="劇情"{
                dramaTypeNum[6]+=1
            }else{
                dramaTypeNum[7]+=1
            }
        }
        for index in 0...7{
            if dramaTypeNum[index] == 0 {
                dramaTypeNumPercentage[index]=0
            }else{
                dramaTypeNumPercentage[index] = dramaTypeNum[index] / Double(total) * 100
            }
            
        }
        for _ in 0..<total{
            completePercentage+=1
        }
        if completePercentage != 0{
            completePercentage=completePercentage/Double(total)
        }

    }
}


struct pieChart:Shape{
    var startangle:Angle
    var endangle:Angle
    
    func path(in rect: CGRect) -> Path {
        Path{(path) in
            let center=CGPoint(x:rect.midX, y:rect.midY)
            path.move(to: center)
            path.addArc(center:center, radius: rect.midX, startAngle: startangle, endAngle: endangle, clockwise: false)
        }
    }
}
struct pieChartView:View{
    var percentages:[Double]
    var angles:[Angle]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    init(percentages:[Double]){
        self.percentages=percentages
        angles=[Angle]()
        var startDegree:Double=0
        for percentage in percentages{
            angles.append(.degrees(startDegree))
            startDegree+=percentage*360/100
        }
    }
    var body: some View{
        ZStack{
            ForEach(angles.indices){(index) in
                if index==angles.count-1{
                    pieChart(startangle: angles[index], endangle: .zero)
                        .fill(pieChartColor[index])
                }else{
                    pieChart(startangle: angles[index], endangle: angles[index+1])
                        .fill(pieChartColor[index])
                }
            }
        }
    }
}

