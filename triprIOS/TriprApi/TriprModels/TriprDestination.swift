//
//  TriprDestination.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-03-13.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation


struct TriprDestination : Codable {
    
    var name : String
    var arrivalDate : Double
    var departureDate : Double
    var isPrivate : Int
    var creator : TriprUser
    var id : Int
    var destinationImage: TriprFile?
    var timestamp : Double
    
}


