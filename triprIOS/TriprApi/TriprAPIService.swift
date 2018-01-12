//
//  TriprAPIService.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-11.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation
import SystemConfiguration

enum httpMethod : String {
    case POST = "POST", GET = "GET", PUT = "PUT", DELETE = "DELETE"
}

enum httpContentTypes : String {
    case json = "application/json",
         www_form = "application/x-www-form-urlencoded",
         form_data = "multipart/form-data"
    
    var string : String { get { return self.rawValue } }
}

enum TriprAPIMessagePriority : Int {
    case low = 0, medium, high
}

protocol TriprAPIServiceMessage {
    
    var queable : Bool {get}
    var priority : TriprAPIMessagePriority { get }
    var sent : Bool { get set }
    var timestamp : Double { get }
    var payload : String { get }
    var URL : String { get }
    var httpMethod : httpMethod { get }
    var contentType : httpContentTypes { get }
    
    
}

class TriprAPIService {
    
    static let sharedInstance = TriprAPIService.init()
    let reachability = Reachability()!
    var isInternetAvailable : Bool = false
    var messageQueue = [TriprAPIServiceMessage]()
    
    private init() {
        
        reachability.whenReachable = { reachability in
            self.isInternetAvailable = true
        }
        reachability.whenUnreachable = { _ in
           self.isInternetAvailable = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func sendMessage(message: TriprAPIServiceMessage, APIresponse : @escaping (TriprAPIDataResponse)->Void) throws
    {
        
        if !self.isInternetAvailable {
            if message.queable {
                self.messageQueue.append(message)
                return
            }
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: message.URL)! as URL)
        request.httpMethod = message.httpMethod.rawValue
        request.setValue(message.contentType.string, forHTTPHeaderField: "Content-Type")
        request.httpBody = message.payload.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            let httpResponse = response as? HTTPURLResponse
            
            if (httpResponse?.statusCode != 200) {
                do{
                    let decoder = JSONDecoder.init()
                    let apiresponse = try decoder.decode(TriprAPIStatusResponse.self, from: data!)
                    APIresponse(TriprAPIDataResponse.init(data: nil, response: apiresponse))
                }catch{
                }
                return
            }
            let resp = TriprAPIDataResponse.init(data: data!,response: TriprAPIStatusResponse.init(status: 200, error: ""))
            APIresponse(resp)
        }
        task.resume()
    }
}
