//
//  TriprAPIMessages.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct triprAPIMessage : TriprAPIServiceMessage {
    var messageId: String
    var contentType: httpContentTypes
    var timestamp: Double
    var payload: String
    var URL: String
    var queable: Bool
    var priority: TriprAPIMessagePriority
    var sent: Bool
    var reference : String?
    let apiService = TriprAPIService.sharedInstance
    var httpMethod : httpMethod
    var attachment : Data?
    
    init?(payload : triprPayloadMessage, httpMethod : httpMethod, contentType: httpContentTypes, URL : String, quable : Bool, priority : TriprAPIMessagePriority) {
        do {
            self.timestamp = Date().timeIntervalSince1970
            self.payload = try payload.getPayloadString()
            self.sent = false
            self.contentType = contentType
            self.httpMethod = httpMethod
            self.URL = URL
            self.queable = quable
            self.priority = priority
            self.messageId = UUID.init().uuidString
        } catch {
            return nil
        }
    }
    
    func sendMessage(response : @escaping (TriprAPIDataResponse)->Void) throws {
        try apiService.sendMessage(message: self, APIresponse: { (dataResponse) in
            
            response(dataResponse)
        })
    }
}

