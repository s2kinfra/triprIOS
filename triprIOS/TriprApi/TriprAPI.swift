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



enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

enum triprAPIEndpointURLs {
    case user_login(baseURL : String),
    user_is_logged_in(baseURL : String),
    user_register(baseURL : String),
    user_get(baseURL: String,username: String),
    user_get_by_id(baseURL: String, id: Int),
    user_logout(baseURL : String),
    user_timeline(baseURL : String),
    user_profileImage(baseURL: String),
    trip_get_users(baseURL : String, username: String),
    search_find_all(baseURL : String),
    search_find_user(baseURL : String),
    search_find_trip(baseURL : String),
    error_test_get(baseURL : String),
    error_test_put(baseURL : String),
    error_test_delete(baseURL : String),
    error_test_post(baseURL : String),
    public_img_get(baseURL: String)
    
    
    var method : httpMethod {
        switch self {
        case .user_login:
            return .POST
        case .user_is_logged_in:
            return .GET
        case .user_register:
            return .POST
        case .user_get:
            return .GET
        case .user_logout:
            return .GET
        case .user_timeline:
            return .POST
        case .user_profileImage:
            return .POST
        case .trip_get_users:
            return .GET
        case .search_find_all:
            return .POST
        case .search_find_user:
            return .POST
        case .search_find_trip:
            return .POST
        case .error_test_post:
            return .POST
        case .error_test_delete:
            return .DELETE
        case .error_test_put:
            return .PUT
        case .public_img_get:
            return .GET
        default:
            return .GET
        }
    }
    
    var url : String {
        switch self {
        case .user_login(let baseURL):
            return "\(baseURL)/user/login"
        case .user_is_logged_in(let baseURL):
            return "\(baseURL)/user/login"
        case .user_logout(let baseURL):
            return "\(baseURL)/user/logout"
        case .user_register(let baseURL):
            return "\(baseURL)/user/register"
        case .user_get(let baseURL, let username):
            return "\(baseURL)/user/\(username)"
        case .user_get_by_id(let baseURL, let uid):
            return "\(baseURL)/user/id/\(uid)"
        case .user_timeline(let baseURL):
            return "\(baseURL)/user/timeline"
        case .user_profileImage(let baseURL):
            return "\(baseURL)/user/profileImage"
        case .trip_get_users(let baseURL, let username):
            return "\(baseURL)/trip/forUser/\(username)"
        case .search_find_all(let baseURL):
            return "\(baseURL)/search/all"
        case .search_find_user(let baseURL):
            return "\(baseURL)/search/all"
        case .search_find_trip(let baseURL):
            return "\(baseURL)/search/all"
        case .error_test_get(let baseURL):
            return "\(baseURL)/error"
        case .error_test_post(let baseURL) :
            return "\(baseURL)/error"
        case .error_test_put(let baseURL):
            return "\(baseURL)/error"
        case .error_test_delete(let baseURL):
            return "\(baseURL)/error"
        case .public_img_get(let baseURL):
            return "\(baseURL)"
        }
    }
}

final class TriprAPI {
    
    static let sharedInstance = TriprAPI.init(apikey: "ios")
    
    var publicFolder : String
    var baseURL : String
    // Initialization
    private init(apikey: String, enviroment: APIEnviroment = .DEV) {
        switch enviroment {
        case .PROD:
            baseURL = "http://fabularis.dk:8081/api/v1"
            publicFolder = "http://fabularis.dk:8081"
        default:
            baseURL = "http://localhost:8080/api/v1"
            publicFolder = "http://localhost:8080"
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
                publicFolder = "http://fabularis.dk:8081"
            default:
                baseURL = "http://localhost:8080/api/v1"
                publicFolder = "http://localhost:8080"
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
    
    func logoutUset( completionHandler: @escaping (TriprAPIResponseMessage)->Void) throws {
        
        guard let message = triprAPIMessage.init(payload: nil, httpMethod: triprAPIEndpointURLs.user_logout(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_logout(baseURL: baseURL).url, quable: false, priority: .high) else {
            throw VendingMachineError.outOfStock
        }
        
        try message.sendMessage(response: { (apiResponse) in
            if apiResponse.status.code == .error {
                completionHandler(apiResponse)
            }else {
                completionHandler(apiResponse)
            }
        })
    }
    
    func loginUser(username: String, password: String, completionHandler: @escaping (TriprAPIResponseMessage, TriprUser?)->Void ) throws {
        
        let request = triprMessageUserLogin.init(username: username, password: password)
        
        guard let message = triprAPIMessage.init(payload: request, httpMethod: triprAPIEndpointURLs.user_login(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_login(baseURL: baseURL).url, quable: false, priority: .high) else {
            throw VendingMachineError.outOfStock
        }
        
        try message.sendMessage(response: { (apiResponse) in
            if apiResponse.status.code == .error {
                completionHandler(apiResponse, nil)
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let user = try decoder.decode(TriprUser.self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,user)
                }catch {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        })
    }
    
    func getUserInformation(username _username : String, completionHandler: @escaping (TriprAPIResponseMessage, TriprUser?)->Void) throws {
        
        guard let message = triprAPIMessage.init(payload: nil, httpMethod: triprAPIEndpointURLs.user_get(baseURL: baseURL, username: _username).method, contentType: .json, URL: triprAPIEndpointURLs.user_get(baseURL: baseURL, username: _username).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage(response: { (apiResponse) in
            if apiResponse.status.code == .error {
                completionHandler(apiResponse, nil)
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let user = try decoder.decode(TriprUser.self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,user)
                }catch {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        })
    }
    
    func getUserInformation(user_id _uid : Int, completionHandler: @escaping (TriprAPIResponseMessage, TriprUser?)->Void) throws {
        
        guard let message = triprAPIMessage.init(payload: nil, httpMethod: triprAPIEndpointURLs.user_get_by_id(baseURL: baseURL, id: _uid).method, contentType: .json, URL: triprAPIEndpointURLs.user_get_by_id(baseURL: baseURL, id: _uid).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage(response: { (apiResponse) in
            if apiResponse.status.code == .error {
                completionHandler(apiResponse, nil)
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let user = try decoder.decode(TriprUser.self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,user)
                }catch {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        })
    }
    
    
    func getUserTimeline(startIndex _index : Int, numberOfFeeds _feeds : Int,completionHandler: @escaping ([TriprTimeline])->Void) throws {
        
        let request = triprMessageUserTimeline.init(startIndex: _index, numberOfFeeds: _feeds)
        
        guard let message = triprAPIMessage.init(payload: request, httpMethod: triprAPIEndpointURLs.user_timeline(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_timeline(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage{ (apiResponse) in
            
            if apiResponse.status.code == .error {
                completionHandler([TriprTimeline]())
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let timelines = try decoder.decode([TriprTimeline].self, from: apiResponse.payload.data(using: .utf8)!)
                    
                    completionHandler(timelines)
                }catch let error {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                        print(error.localizedDescription)
                        let error2 : DecodingError = error as! DecodingError
                        print(error2)
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        }
        
    }
    
    func registerUser(username _username: String, email _email : String, firstname _firstname : String, lastname _lastname : String, password _password : String, completionHandler: @escaping (TriprAPIResponseMessage, TriprUser?)->Void) throws {
        let request = triprMessageUserRegister.init(username: _username, firstname: _firstname, lastname: _lastname, password: _password, email: _email)
        
        guard let message = triprAPIMessage.init(payload: request, httpMethod: triprAPIEndpointURLs.user_register(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_register(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage{ (apiResponse) in
            
            if apiResponse.status.code == .error {
                completionHandler(apiResponse, nil)
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let user = try decoder.decode(TriprUser.self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,user )
                }catch {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        }
        
    }
    
    func setUserProfileImage(imageData _imageData : Data, filename _filename : String, completionHandler: @escaping (TriprAPIResponseMessage)->Void) throws {
        let request = triprMessageUserProfileImage.init(base64: _imageData.base64EncodedString(), filename: _filename)
        
        
        guard let message = triprAPIMessage.init(payload: request, httpMethod: triprAPIEndpointURLs.user_profileImage(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_profileImage(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage{ (apiResponse) in
            
            if apiResponse.status.code == .error {
                completionHandler(apiResponse)
            }else {
                completionHandler(apiResponse )
            }
        }
    }
    
    func isLoggedIn(completionHandler: @escaping (TriprAPIResponseMessage, TriprUser?)->Void) throws {
        guard let message = triprAPIMessage.init(payload: nil, httpMethod: triprAPIEndpointURLs.user_is_logged_in(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.user_is_logged_in(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        
        try message.sendMessage{ (apiResponse) in
            
            if apiResponse.status.code == .error {
                completionHandler(apiResponse, nil)
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let user = try decoder.decode(TriprUser.self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,user )
                }catch let error {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                        print(error.localizedDescription)
                        let error2 : DecodingError = error as! DecodingError
                        print(error2)
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        }
    }
    
    func getUsersTrips(user _user : String, completionHandler: @escaping (TriprAPIResponseMessage, [TriprTrip])->Void) throws {
        guard let message = triprAPIMessage.init(payload: nil, httpMethod: triprAPIEndpointURLs.trip_get_users(baseURL: baseURL,username: _user).method, contentType: .json, URL: triprAPIEndpointURLs.trip_get_users(baseURL: baseURL, username: _user).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage{ (apiResponse) in
            
            if apiResponse.status.code == .error {
                completionHandler(apiResponse, [TriprTrip]())
            }else {
                do {
                    let decoder = JSONDecoder.init()
                    let trips = try decoder.decode([TriprTrip].self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,trips )
                }catch let error {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                        print(error.localizedDescription)
                        let error2 : DecodingError = error as! DecodingError
                        print(error2)
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        }
    }
    
    func getImageDataFromAPI(url : String,completionHandler: @escaping (Data)->Void) throws {
        URLSession.shared.dataTask(with: URL.init(string: "\(publicFolder)\(url)")!) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            completionHandler(data!)
            }.resume()
    }
    
    
    func searchForAll(searchTerm _term : String, completionHandler: @escaping (TriprAPIResponseMessage, [TriprTrip]? , [TriprUser]?)->Void) throws {
        let request = triprMessageSearchRequest.init(searchTerm: _term)
        
        guard let message = triprAPIMessage.init(payload: request, httpMethod: triprAPIEndpointURLs.search_find_all(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.search_find_all(baseURL: baseURL).url, quable: true, priority: .high) else {
            throw VendingMachineError.invalidSelection
        }
        try message.sendMessage{ (apiResponse) in
            
            if apiResponse.status.code == .error {
                completionHandler(apiResponse,nil,nil)
            }else {
                
                do {
                    let decoder = JSONDecoder.init()
                    let result = try decoder.decode(TriprSearchResult.self, from: apiResponse.payload.data(using: .utf8)!)
                    completionHandler(apiResponse,result.trips, result.users)
                }catch {
                    do {
                        print(try apiResponse.payload.prettyPrintJSONString())
                        print("something fucked up")
                    }catch {
                        print(apiResponse)
                    }
                }
            }
        }
    }
    
    func testError(httpMethod : httpMethod = .POST) throws {
        //        switch httpMethod {
        //        case .GET:
        //            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_get(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_get(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
        //                guard let data = response.data else {
        //                    return
        //                }
        //                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
        //            })
        //
        //        case .POST:
        //            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_post(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_post(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
        //                guard let data = response.data else {
        //                    return
        //                }
        //                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
        //            })
        //        case .PUT:
        //            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_put(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_put(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
        //                guard let data = response.data else {
        //                    return
        //                }
        //                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
        //
        //            })
        //        case .DELETE:
        //            try triprAPIMessage.init(payload: triprMessageDummy(), httpMethod: triprAPIEndpointURLs.error_test_delete(baseURL: baseURL).method, contentType: .json, URL: triprAPIEndpointURLs.error_test_delete(baseURL: baseURL).url, quable: false, priority: .low)?.sendMessage(response: { (response) in
        //                guard let data = response.data else {
        //                    return
        //                }
        //                print("\(String(describing: String.init(data: data, encoding: .utf8)))")
        //
        //            })
        //        }
        
    }
    
}


