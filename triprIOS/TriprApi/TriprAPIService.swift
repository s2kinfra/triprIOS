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

enum httpResponseStatusCode : Int, Codable {
    case success_ok = 200, success_created = 201, success_accepted = 202, success_no_content = 204,
         redirect_moved_perm = 301,
         client_error_bad_reequest = 400, client_error_unauthorized = 401, client_error_forbidden = 403, client_error_not_found = 404, client_error_to_many_requests = 429,
        server_error_internal_error = 500, server_error_not_implemented = 501, server_error_bad_gateway = 502, server_error_service_unavailble = 503
    
    var isErrorCode : Bool {
        if self.rawValue >= 300 {
            return true
        }else {
            return false
        }
    }
    
    var code_text : String {
        switch self {
        case .success_ok:
            return "OK"
        case .success_created:
            return "Created"
        case .success_accepted:
            return "Accepted"
        case .success_no_content:
            return "No Content"
        case .redirect_moved_perm:
            return "Moved Permanently"
        case .client_error_bad_reequest:
            return "Bad Request"
        case .client_error_unauthorized:
            return "Unauthorized"
        case .client_error_forbidden:
            return "Forbidden"
        case .client_error_not_found:
            return "Not Found"
        case .client_error_to_many_requests:
            return "To many requests"
        case .server_error_internal_error:
            return "Internal server error"
        case .server_error_not_implemented:
            return "Not implemented"
        case .server_error_bad_gateway:
            return "Bad gateway"
        case .server_error_service_unavailble:
            return "Service Unavailable"
        }
    }
    
}

enum TriprAPIMessagePriority : Int {
    case low = 0, medium, high
}

protocol TriprAPIServiceMessage {
    
    var queable : Bool {get}
    var messageId : String { get set }
    var reference : String? {get set}
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
           // let httpResponse = response as? HTTPURLResponse
            guard let status = httpResponseStatusCode.init(rawValue: ((response as? HTTPURLResponse)?.statusCode)!) else {
                return
            }
            
            if status.isErrorCode {
                do{
                    let decoder = JSONDecoder.init()
                    let apiresponse = try decoder.decode(TriprAPIStatusResponse.self, from: data!)
                    APIresponse(TriprAPIDataResponse.init(data: nil, response: apiresponse))
                }catch{
                }
                return
            }
            
            let resp = TriprAPIDataResponse.init(data: data!,response: TriprAPIStatusResponse.init(status: status, error: ""))
            APIresponse(resp)
        }
        task.resume()
    }
}
