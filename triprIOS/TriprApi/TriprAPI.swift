//
//  TriprAPI.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

enum httpMethod : String {
    case POST = "POST", GET = "GET", PUT = "PUT", DELETE = "DELETE"
}

enum APIEnviroment {
    case PROD, TEST, DEV
}
struct TriprAPIDataResponse {
    var data : Data?
    var response : TriprAPIStatusResponse
}

struct TriprAPIStatusResponse : Codable{
    var status : Int
    var error : String?
}

final class TriprAPI {
    
    static let sharedInstance = TriprAPI.init(apikey: "ios")
    
    var baseURL : String
    // Initialization
    private init(apikey: String, enviroment: APIEnviroment = .DEV) {
        switch enviroment {
        case .PROD:
           baseURL = "http://fabularis.dk:8081/api/v1"
        default:
           baseURL = "http://localhost:8080/api/v1"
        }
        self.apiKey = apikey
    }
    
    private var enviroment : APIEnviroment {
        get {
            return self.enviroment
        }set {
            switch newValue {
            case .PROD:
                baseURL = "http://fabularis.dk:8081/api/v1"
            default:
                baseURL = "http://localhost:8080/api/v1"
            }
        }
    }
    var apiKey : String
    var currentUser : TriprUser?
    var logging : Bool = false
    func setEnviroment(_ env: APIEnviroment) {
        self.enviroment = env
    }
    func getEnviroment() -> APIEnviroment {
        return self.enviroment
    }
    
    func toggleLogging() {
        self.logging = !self.logging
        print("API logging active \(logging)")
    }
    
    func loginUser(username: String, password: String, completionHandler: (TriprAPIStatusResponse, TriprUser?)->Void ) throws {
        
        let bodyLoginUser = triprMessageUserLogin.init(email: username, password: password)
        
        let encoder = JSONEncoder()
        
        try callAPI(url: "\(baseURL)/user/login", body: String(data: encoder.encode(bodyLoginUser), encoding: .utf8)!, contentType: "application/json", httpMethod : .POST, result: { (response) in
            do{
                let decoder = JSONDecoder.init()
                let user = try decoder.decode(TriprUser.self, from: response.data!)
                self.currentUser = user
            }catch let postError{
                print(postError.localizedDescription)
            }
        })
        
        
    }
    
    func registerUser(username _username: String, email _email : String, firstname _firstname : String, lastname _lastname : String, password _password : String, completionHandler: @escaping (TriprUser?)->Void) throws {
        
        let bodyRegisterUser = triprMessageUserRegister.init(username: _username, firstname: _firstname, lastname: _lastname, password: _password, email: _email)
        
        let encoder = JSONEncoder()
        
        try callAPI(url: "\(baseURL)/user/register", body: String(data: encoder.encode(bodyRegisterUser), encoding: .utf8)!, httpMethod : .POST ) { response in
            
        }
        
    }
    
    func testError(httpMethod : httpMethod = .POST) throws {
        switch httpMethod {
        case .GET:
            try callAPI(url: "\(baseURL)/error", body: "", httpMethod : .GET ,result: { (response) in
                
            })
        case .POST:
            try callAPI(url: "\(baseURL)/error", body: "", httpMethod : .POST, result: { (response) in
                
            })
        default:
            try callAPI(url: "\(baseURL)/error", body: "", httpMethod : .POST, result: { (response) in
                
            })
        }
        
    }
    
    private func callAPI(url: String, body: String, contentType : String = "", httpMethod _httpMethod : httpMethod, result : @escaping (TriprAPIDataResponse)->Void) throws
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = _httpMethod.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        if self.logging {
            print("Sending \(_httpMethod.rawValue) request to endpoint \(url)")
            print("ContentType : \(contentType)")
            print("Body: \(body)")
        }
        
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
                    if self.logging {
                        do{
                            print("Retreived response for endpoint \(url)")
                            print("Response code: \(apiresponse.status) error: \(String(describing: apiresponse.error))")
                            print("Body: \(try JSONSerialization.jsonObject(with: data!))")
                        }catch{
                        }
                    }
                    result(TriprAPIDataResponse.init(data: nil, response: apiresponse))
                }catch{
                }
                return
            }
            do{
            if self.logging {
                print("Retreived response for endpoint \(url)")
                print("Response code \(String(describing: httpResponse!.statusCode))")
                print("Body: \(try JSONSerialization.jsonObject(with: data!))")
            }
            }catch{
            }
            let resp = TriprAPIDataResponse.init(data: data!,response: TriprAPIStatusResponse.init(status: 200, error: ""))
            result(resp)
            
            
        }
        task.resume()
    }
    
}


