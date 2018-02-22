//
//  TriprTrip.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-21.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct TriprTrip : Codable {
    
    var name : String
    var startDate : Double
    var endDate : Double
    var isPrivate : Int
    var followers : [TriprUser]?
    var following : [TriprUser]?
    var creator : TriprUser
    var id : Int
    var timestamp : Double
    
}
