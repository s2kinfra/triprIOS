//
//  TriprFollow.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct Follow : Codable {
    var object : String = ""
    var objectId : Int = 0
    var follower : Int = 0
    var accepted : Bool = false
}
