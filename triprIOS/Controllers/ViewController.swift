//
//  ViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func login(_ sender: Any) {
        do {
            try api.loginUser(username: username.text!, password: password.text!, completionHandler: { (response, user) in
                if response.status.code == .error {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failed to login user", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else {
                    api.currentUser = user
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "User logged in", message: "Welcome back \(api.currentUser!.firstname) \(api.currentUser!.lastname)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            })
        }catch{

        }
    }
    
}

