//
//  TriprAPI.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

enum APIEnviroment {
    case PROD, TEST, DEV
}
struct TriprAPIDataResponse {
    var data : Data?
    var response : TriprAPIStatusResponse
}

struct TriprAPIStatusResponse : Codable{
    var status : httpResponseStatusCode
    var error : String?
}

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

enum triprAPIEndpointURLs {
    case user_login(baseURL : String),
         user_register(baseURL : String),
         error_test_get(baseURL : String),
         error_test_put(baseURL : String),
         error_test_delete(baseURL : String),
         error_test_post(baseURL : String)
    
    var method : httpMethod {
        switch self {
        case .user_login:
            return .POST
        case .user_register:
            return .POST
        case .error_test_post:
            return .POST
        case .error_test_delete:
            return .DELETE
        case .error_test_put:
            return .PUT
        default:
            return .GET
        }
    }
    
    var url : String {
        switch self {
        case .user_login(let baseURL):
            return "\(baseURL)/user/login"
        case .user_register(let baseURL):
            return "\(baseURL)/user/register"
        case .error_test_get(let baseURL):
            return "\(baseURL)/error"
        case .error_test_post(let baseURL) :
            return "\(baseURL)/error"
        case .error_test_put(let baseURL):
            return "\(baseURL)/error"
        case .error_test_delete(let baseURL):
            return "\(baseURL)/error"
        }
    }
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
    
    func loginUser(username: String, password: String, completionHandler: (TriprAPIStatusResponse, TriprUser?)->Void ) throws {
        
        let bodyLoginUser = triprMessageUserLogin.init(email: username, password: password)
        
    
        guard let message = triprAPIMessage.init(payload: bodyLoginUser, httpMethod: triprAPIEndpointURLs.user_login(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_login(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.outOfStock
        }
        try message.sendMessage(response: { (response) in
             print(response.response.status)
            })
    }
    
    func registerUser(username _username: String, email _email : String, firstname _firstname : String, lastname _lastname : String, password _password : String, completionHandler: @escaping (TriprAPIStatusResponse, TriprUser?)->Void) throws {
        
        let bodyRegisterUser = triprMessageUserRegister.init(username: _username, firstname: _firstname, lastname: _lastname, password: _password, email: _email)
        
        guard let message = triprAPIMessage.init(payload: bodyRegisterUser, httpMethod: triprAPIEndpointURLs.user_register(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_register(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage { (apiResponse) in
            
        }
        
    }
    
    func testError(httpMethod : httpMethod = .POST) throws {
        switch httpMethod {
        case .GET:
            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_get(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_get(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
                guard let data = response.data else {
                    return
                }
                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
            })
           
        case .POST:
            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_post(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_post(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
                guard let data = response.data else {
                    return
                }
                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
            })
        case .PUT:
            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_put(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_put(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
                guard let data = response.data else {
                    return
                }
                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
                
            })
        case .DELETE:
            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_delete(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_delete(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
                guard let data = response.data else {
                    return
                }
                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
                
            })
        }

    }
    
}


