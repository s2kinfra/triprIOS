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


