//
//  TriprAPIPayloadMessages.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-12.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct triprMessageDummy: triprPayloadMessage {
    
}

// MARK : Trip Create
class triprMessageTripCreate : triprAPIRequestMessage {
    
    struct triprMessageTripCreatePayload : Codable {
        var isPrivate : Bool = false
        var startDate : Double = 0
        var endDate : Double = 0
        var name : String = ""
        
        init(isPrivate _private : Bool, startDate _start : Double, endDate _end : Double, name _name : String) {
            self.isPrivate = _private
            self.startDate = _start
            self.endDate = _end
            self.name = _name        }
    }
    
    var payload : triprMessageTripCreatePayload
    
    init(isPrivate _private : Bool, startDate _start : Double, endDate _end : Double, name _name : String) {
        self.payload = triprMessageTripCreatePayload.init(isPrivate: _private, startDate: _start, endDate: _end, name: _name)
        super.init()
    }
    
    private enum CodingKeys : String, CodingKey {
        case payload
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try container.decode(triprMessageTripCreatePayload.self, forKey: .payload)
        try super.init(from: decoder)
        
    }
    
}

// MARK : User Timeline
class triprMessageUserTimeline : triprAPIRequestMessage {
    
    struct triprMessageUserTimelinePayload : Codable {
        var startIndex : Int = 0
        var numberOfFeeds : Int = 25
        
        init(startIndex _index : Int, numberOfFeeds _feeds : Int) {
            self.startIndex = _index
            self.numberOfFeeds = _feeds
        }
    }
    
    var payload : triprMessageUserTimelinePayload
    
    init(startIndex _index : Int, numberOfFeeds _feeds : Int) {
        self.payload = triprMessageUserTimelinePayload.init(startIndex: _index, numberOfFeeds: _feeds)
        
        super.init()
    }
    
    private enum CodingKeys : String, CodingKey {
        case payload
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try container.decode(triprMessageUserTimelinePayload.self, forKey: .payload)
        try super.init(from: decoder)
        
    }
    
}

// MARK : User Register
class triprMessageUserRegister : triprAPIRequestMessage {
    
    struct triprMessageUserRegisterPayload : Codable{
        var username : String = ""
        var firstname : String = ""
        var lastname : String = ""
        var password : String = ""
        var email : String = ""
        
        init(username: String, firstname: String, lastname : String, password: String, email:String){
            self.username = username
            self.firstname = firstname
            self.lastname = lastname
            self.password = password
            self.email = email
        }
    }
    
    var payload : triprMessageUserRegisterPayload
    
    init(username: String, firstname: String, lastname : String, password: String, email:String) {
        
        self.payload = triprMessageUserRegisterPayload.init(username: username,
                                                            firstname: firstname,
                                                            lastname: lastname,
                                                            password: password,
                                                            email: email)
        super.init()
    }
    
    private enum CodingKeys : String, CodingKey {
        case payload
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try container.decode(triprMessageUserRegisterPayload.self, forKey: .payload)
        try super.init(from: decoder)
        
    }
    
}

/// MARK : User login
class triprMessageUserLogin: triprAPIRequestMessage {
    
    struct triprMessageUserLoginPayload: Codable {
        var username : String = ""
        var password : String = ""
    }
    
    var payload : triprMessageUserLoginPayload
    
    private enum CodingKeys : String, CodingKey {
        case payload
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try container.decode(triprMessageUserLoginPayload.self, forKey: .payload)
        try super.init(from: decoder)
        
    }
    
    init(username: String, password : String) {
        self.payload = triprMessageUserLoginPayload.init(username: username, password: password)
        super.init()
    }
}

///MARK : User set profile image
class triprMessageUserProfileImage: triprAPIRequestMessage {
    
    struct triprMessageUserSetProfileImagePayload: Codable {
        var profileImage : TriprFileData
        
        init(profileImage _image : TriprFileData) {
            self.profileImage = _image
        }
    }
    
    var payload : triprMessageUserSetProfileImagePayload
    
    private enum CodingKeys : String, CodingKey {
        case payload
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try container.decode(triprMessageUserSetProfileImagePayload.self, forKey: .payload)
        try super.init(from: decoder)
        
    }
    
    init(base64 _base64 : String, filename _filename : String) {
        self.payload = triprMessageUserSetProfileImagePayload.init(profileImage: TriprFileData.init(base64: _base64, filename: _filename))
        super.init()
    }
}

///MARK : Search
class triprMessageSearchRequest: triprAPIRequestMessage {
    struct triprMessageSearchRequestPayload: Codable {
        var searchTerm : String
        
        init(searchTerm _term : String) {
            self.searchTerm = _term
        }
    }
    
    var payload : triprMessageSearchRequestPayload
    
    private enum CodingKeys : String, CodingKey {
        case payload
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payload, forKey: .payload)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try container.decode(triprMessageSearchRequestPayload.self, forKey: .payload)
        try super.init(from: decoder)
        
    }
    
    init(searchTerm _term : String) {
        self.payload = triprMessageSearchRequestPayload.init(searchTerm: _term)
        super.init()
    }
}

