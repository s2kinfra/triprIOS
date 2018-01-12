//
//  TriprAPIPayloadMessages.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-12.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

protocol triprPayloadMessage : Codable{
    func getPayloadString() throws -> String
}
extension triprPayloadMessage {
    func getPayloadString() throws -> String {
        let encoder = JSONEncoder()
        return String(data: try encoder.encode(self), encoding: .utf8)!
    }
}

struct triprMessageDummy: triprPayloadMessage {
    
}

struct triprMessageUserRegister : triprPayloadMessage {
    
    var username : String
    var firstname : String
    var lastname : String
    var password : String
    var email : String
    
}

struct triprMessageUserLogin: triprPayloadMessage {
    
    var username : String
    var email : String
    var password : String
    
    init(username: String, password : String) {
        self.email = ""
        self.username = username
        self.password = password
    }
    
    init(email: String, password : String) {
        self.email = email
        self.password = password
        self.username = ""
    }
}


