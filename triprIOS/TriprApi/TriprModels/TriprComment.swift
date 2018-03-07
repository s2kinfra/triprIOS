//
//  TriprComment.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-21.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation


struct TriprComment : Codable {
    
    var text : String
    var writtenBy : TriprUser
    var commentedObject : String
    var commentedObjectId : Int
    var id : Int
    var attachments : [TriprAttachment]?
    
}

