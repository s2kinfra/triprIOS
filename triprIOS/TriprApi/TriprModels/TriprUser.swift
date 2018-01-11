//
//  TriprUser.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct Comment : Codable {
    
}

struct Envy : Codable {
    
}

struct Followers : Codable {
//    followers =     (
//    {
//    accepted = 1;
//    follower = 2;
//    object = "App.User";
//    objectId = 1;
//    }
//    );
}

struct Following : Codable {
//    following =     (
//    {
//    accepted = 1;
//    follower = 1;
//    object = "App.User";
//    objectId = 2;
//    }
//    );
}

struct FollowRequest: Codable {
//    followingRequests =     (
//    );

}

struct TriprNotification : Codable {
//    notifications =     (
//    {
//    comment = "Karin Steweee Requested to follow you";
//    createdAt = 1514458852;
//    id = 2;
//    read = 0;
//    receiver = 1;
//    relatedObject = "App.User";
//    relatedObjectId = 2;
//    sender = 2;
//    }
//    );
}
struct TriprFile : Codable {
//    profileCover =     {
//    absolutePath = "/Users/infra/Desktop/git/tripr/public/img/login_back.jpg";
//    comments =         (
//    );
//    filetype = 1;
//    id = "<null>";
//    name = defaultProfileCover;
//    path = "/img/login_back.jpg";
//    userId = 1;
//    };
}



struct TriprUser : Codable{
    
    var username: String = ""
    var email : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullname : String?
    var id : Int
    
    var feeds : [Feed]?
    
    var followerRequests : [FollowRequest]?
    var followers : [Followers]?
    var following : [Following]?
    var notifications : [TriprNotification]?
    var profileCover : TriprFile?
    var profilePicture : TriprFile?
    var unreadNotifications : [TriprNotification]?
   
    init(username _username : String, email _email : String, firstName _firstName : String, lastName _lastname : String, Id _id : Int){
        
        self.username = _username
        self.email = _email
        self.firstName = _firstName
        self.lastName = _lastname
        self.id = _id
        
    }
    
   
}

