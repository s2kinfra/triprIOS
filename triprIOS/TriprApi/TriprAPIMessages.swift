//
//  TriprAPIMessages.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct triprMessageUserRegister : Codable {
    
    var username : String
    var firstname : String
    var lastname : String
    var password : String
    var email : String
    
}

struct triprMessageUserLogin: Codable {
    
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
