//
//  TriprAPIService.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-11.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation
import SystemConfiguration



class TriprAPIService {
    
    
    let reachability = Reachability()!
    var isInternetAvailable : Bool = false
    
    init() {
        
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
    
    
}
