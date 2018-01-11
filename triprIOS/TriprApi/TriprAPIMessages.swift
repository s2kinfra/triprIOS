//
//  TriprAPIMessages.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

enum httpMethod : String {
    case POST = "POST", GET = "GET", PUT = "PUT", DELETE = "DELETE"
}

struct triprAPIMessage {
    
    var timestamp : Double
    var payload : String
    var URL : String
    var contentType : String
    var httpMethod : httpMethod
    private var sent : Bool
    private var confirmed : Bool
    var attachment : Data?
    
    init(payload : String, httpMethod : httpMethod, contentType: String, URL : String) {
        self.timestamp = Date().timeIntervalSince1970
        self.payload = payload
        self.sent = false
        self.confirmed = false
        self.contentType = contentType
        self.httpMethod = httpMethod
        self.URL = URL
    }
    
    func sendMessage(response : @escaping (TriprAPIDataResponse)->Void) throws {
        try self.callAPI { (APIResponse) in
            response(APIResponse)
        }
    }
    
    func queueMessage() {
        
    }
    
    mutating func setToSent() {
        self.sent = true
    }
    
    func isSent() -> Bool {
        return self.sent
    }
    
    mutating func setConfirmed() {
        self.confirmed = true
    }
    
    func isConfirmed() -> Bool {
        return self.confirmed
    }
    
    private func callAPI(APIresponse : @escaping (TriprAPIDataResponse)->Void) throws
    {
        let request = NSMutableURLRequest(url: NSURL(string: self.URL)! as URL)
        request.httpMethod = self.httpMethod.rawValue
        request.setValue(self.contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = self.payload.data(using: String.Encoding.utf8)
        
//        if self.logging {
//            print("Sending \(_httpMethod.rawValue) request to endpoint \(url)")
//            print("ContentType : \(contentType)")
//            print("Body: \(body)")
//        }
        
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
//                    if self.logging {
//                        do{
//                            print("Retreived response for endpoint \(url)")
//                            print("Response code: \(apiresponse.status) error: \(String(describing: apiresponse.error))")
//                            print("Body: \(try JSONSerialization.jsonObject(with: data!))")
//                        }catch{
//                        }
//                    }
                    APIresponse(TriprAPIDataResponse.init(data: nil, response: apiresponse))
                }catch{
                }
                return
            }
//            do{
//                if self.logging {
//                    print("Retreived response for endpoint \(url)")
//                    print("Response code \(String(describing: httpResponse!.statusCode))")
//                    print("Body: \(try JSONSerialization.jsonObject(with: data!))")
//                }
//            }catch{
//            }
            let resp = TriprAPIDataResponse.init(data: data!,response: TriprAPIStatusResponse.init(status: 200, error: ""))
            APIresponse(resp)
            
            
        }
        task.resume()
    }
    
    
}

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
