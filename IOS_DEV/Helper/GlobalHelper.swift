//
//  GlobalHelper.swift
//  IOS_DEV
//
//  Created by Jackson on 10/4/2021.
//

import Foundation
import SwiftUI
import AVKit


let SERVER_HOST = "http://0.0.0.0:8000"
//USE FOR FAKE DATA TO TEST UI

//USE LOCAL VIDEO URL


var ActorLists = [
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/k1ALgZkOApYt7PIUBkUitmknXQC.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Tommy.TR", actorAvatorImage: "https://www.themoviedb.org/t/p/original/eLaZrxKKIbYTEAtGMebvETM688w.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/vJAUHFDb6Md0b38RrKN52FW99xI.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/jqMBPYP8qw3bZZ5Yx1hdDAekPY.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/gnjhCg36OlcUpXyUPbtNSBavoim.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/7g8md7KfgVfP6gAFB2mqt2cnUNY.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/nRNMJlqR33j84cGdB0RxstV3NYm.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/8Jh7IFVByBuZSYRtcqC7us36QVB.jpg", actorCharactorName: "Iron Man"),
    MovieActor(actorName: "Jackson", actorAvatorImage: "https://www.themoviedb.org/t/p/original/jnQTP4RRkoWnyO3yL2PgRHZi0tK.jpg", actorCharactorName: "Iron Man")
]

var CaptureLists = [
    MovieCapture(CaptureImage:"https://www.themoviedb.org/t/p/original/gzJnMEMkHowkUndn9gCr8ghQPzN.jpg"),
    MovieCapture(CaptureImage:"https://www.themoviedb.org/t/p/original/3ombg55JQiIpoPnXYb2oYdr6DtP.jpg"),
    MovieCapture(CaptureImage:"https://www.themoviedb.org/t/p/original/3WQqRrrctYQZC1Ub7OhI8BybScM.jpg"),
    MovieCapture(CaptureImage:"https://www.themoviedb.org/t/p/original/jxYROBerNLUExmqFb2yArglwIHd.jpg"),
    MovieCapture(CaptureImage:"https://www.themoviedb.org/t/p/original/bJCb1wNJ2EMMFIsWeixRlF7XDHA.jpg"),
    MovieCapture(CaptureImage:"https://www.themoviedb.org/t/p/original/7cGsa6sqTFsrws322p0QaIe7GUX.jpg")
]
//
//var MovieList:[MovieInfo] = [
//    MovieInfo(movieName: "Iron Mane", adult: false, desscription: "is a movie", movieLanguage: "english", releaseDate: Date(timeIntervalSince1970: .leastNormalMagnitude), movireTrainer: VideoList, moviePoster: [], movieBackDrop: [], movieType: ["Action",""], movieActor: <#T##[MovieActor]#>, movieRank: <#T##Float?#>),
//]
