//
//  TriprFile.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation


enum fileType : Int {
    case image = 1, movie = 2
}

struct TriprFile : Codable {
    var id : Int = 0
    var name : String = ""
    var userId : Int = 0
    var path : String = ""
    var absolutePath : String = ""
    var filetype : Int = 0
}

