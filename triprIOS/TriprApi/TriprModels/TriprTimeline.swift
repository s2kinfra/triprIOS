//
//  TriprTimeline.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-20.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation


enum FeedType : Int, Codable {
    case followAccepted = 1,
    followDeclined = 2,
    followRequest = 3,
    tripCreated = 10,
    tripFollowed = 11,
    tripUpdated = 12,
    commentAdded = 20,
    photoAdded = 30,
    destinationCreated = 40,
    destinationUpdated = 41,
    unknown = 9999
}

struct timelineEntryObject : Codable {
    var trip : TriprTrip?
    var comment : TriprComment?
    var user : TriprUser?
    
    init(trip _trip : TriprTrip? , comment _comment : TriprComment?, user _user : TriprUser?) {
        self.trip = _trip
        self.comment = _comment
        self.user = _user
    }
}

struct timelineFeedObject : Codable {
    var trip : TriprTrip?
    var comment : TriprComment?
    var user : TriprUser?
    
    init(trip _trip : TriprTrip? , comment _comment : TriprComment?, user _user : TriprUser?) {
        self.trip = _trip
        self.comment = _comment
        self.user = _user
    }
}

struct TriprTimeline : Codable{
    
    var feedObject: timelineFeedObject
    var entryObject : timelineEntryObject
    var feedType : FeedType = .unknown
    var id : Int = 0
    var timestamp : Double = 0
    
    init(feedObject _fobject : timelineFeedObject, feedType _type : Int, id _id : Int, timestamp _stamp : Double, entryObject _eobject: timelineEntryObject) {
        
        self.feedType = FeedType.init(rawValue: _type)!
        self.id = _id
        self.timestamp = _stamp
        self.entryObject = _eobject
        self.feedObject = _fobject
    }
    
    
}
