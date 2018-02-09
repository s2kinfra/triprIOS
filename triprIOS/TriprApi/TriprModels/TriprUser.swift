//
//  TriprUser.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//



struct TriprUser : Codable{
    
    var username: String = ""
    var email : String = ""
    var firstname : String = ""
    var lastname : String = ""
    var id : Int
    var isPrivate : Int = 0
    
    var followers : [Follow] = [Follow]()
    var following : [Follow] = [Follow]()
    var followerRequests : [Follow] = [Follow]()
    var followingRequests : [Follow] = [Follow]()
    
    var profileImage : TriprFile = TriprFile()
   
    init(username _username : String, email _email : String, firstName _firstName : String, lastName _lastname : String, Id _id : Int){
        
        self.username = _username
        self.email = _email
        self.firstname = _firstName
        self.lastname = _lastname
        self.id = _id
        
    }
    
   
}

