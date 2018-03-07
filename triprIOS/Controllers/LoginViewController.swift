//
//  ViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-01-02.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "username") != nil {
            self.username.text = defaults.string(forKey: "username")
            self.password.text = defaults.string(forKey: "password")
            self.login(self)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func login(_ sender: Any) {
        do {
            self.activityIndicator.startAnimating()
            try api.loginUser(username: username.text!, password: password.text!, completionHandler: { (response, user) in
                if response.status.code == .error {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Failed to login user", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else {
                    api.currentUser = user
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let defaults = UserDefaults.standard
                        defaults.set(self.username.text!, forKey : "username")
                        defaults.set(self.password.text!, forKey : "password")
                        let alert = UIAlertController(title: "User logged in", message: "Welcome back \(api.currentUser!.firstname) \(api.currentUser!.lastname)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                    }
                }
                
            })
        }catch{

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedIn"
        {
            if let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.displayedUser = api.currentUser
            }
        }
    }
}

