//
//  TriprAPIMessages.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

struct triprAPIMessage {
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
    let api = TriprAPI.sharedInstance
    
    init?(payload : triprAPIRequestMessage?, httpMethod : httpMethod, contentType: httpContentTypes, URL : String, quable : Bool, priority : TriprAPIMessagePriority) {
        do {
            self.timestamp = Date().timeIntervalSince1970
            if let pay = payload {
                self.payload = try pay.getPayloadString()
            }else {
                self.payload = ""
            }
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
    
    func sendMessage(response : @escaping (TriprAPIResponseMessage)->Void) throws {
        if api.logging {
            print("------------------------------------------")
            print("Sending message to URL : \(self.URL)")
            print("timestamp: \(self.timestamp)")
            print("Payload:")
            if payload.count > 3000 {
                print("Large payload , above 3000 char so not displayed")
            }else{
                print("\(self.payload)")
            }
            print("------------------------------------------")
        }
        try apiService.sendMessage(message: self, APIresponse: { (dataResponse) in
            if self.api.logging {
                print("------------------------------------------")
                print("Response received")
                print("timestamp: \(dataResponse.timestamp)")
                print("status code: \(dataResponse.status.code)")
                print("status text: \(dataResponse.status.text)")
                print("Payload:")
                if dataResponse.payload.count > 3000 {
                    print("Large payload , above 3000 char so not displayed")
                }else{
                    print("\(dataResponse.payload)")
                }
                print("------------------------------------------")
            }
            response(dataResponse)
        })
    }
}


class triprAPIRequestMessage : triprPayloadMessage {
    var messageId: String = UUID().uuidString
    var timestamp: Double = Date().timeIntervalSince1970
//    var payload: String
    
    private enum CodingKeys : String, CodingKey {
        case messageId, timestamp
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

struct TriprAPIResponseMessage : Codable{
    var messageId: String
    var timestamp: Double
    var payload: String
    var URI: String
    var priority: TriprAPIMessagePriority
    var reference : String?
    var attachment : Data?
    var status : triprAPIResponseStatusMessageData
    
    init(messageId: String, timestamp : Double, payload : String, URI: String, priority: Int, reference : String?, attachment : Data?, status : triprAPIResponseStatusMessageData)
    {
        self.messageId = messageId
        self.timestamp = timestamp
        self.payload = payload
        self.URI = URI
        self.priority = TriprAPIMessagePriority.init(rawValue: priority)!
        self.reference = reference
        self.attachment = attachment
        self.status = status
    }
    
}


protocol triprPayloadMessage : Codable {
    func getPayloadString() throws -> String
}
extension triprPayloadMessage {
    func getPayloadString() throws -> String {
        let encoder = JSONEncoder()
        return String(data: try encoder.encode(self), encoding: .utf8)!
    }
}


enum responseStatusCode : Int, Codable {
    case ok = 100, error = 999, info = 200
}

struct triprAPIResponseStatusMessageData : Codable {
    var code: responseStatusCode = .ok
    var text : String = ""
    
    init(code : responseStatusCode, text : String) {
        self.code = code
        self.text = text
    }
}

enum TriprAPIMessagePriority : Int , Codable{
    case low = 0, medium, high
}
//
//
//protocol TriprAPIServiceMessage {
//
//    var queable : Bool {get}
//    var messageId : String { get set }
//    var reference : String? {get set}
//    var priority : TriprAPIMessagePriority { get }
//    var sent : Bool { get set }
//    var timestamp : Double { get }
//    var payload : String { get }
//    var URL : String { get }
//    var httpMethod : httpMethod { get }
//    var contentType : httpContentTypes { get }
//
//
//}

