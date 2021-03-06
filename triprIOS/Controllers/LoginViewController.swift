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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.text = defaults.string(forKey: "username")
        if self.username.text != "" && self.username.text != nil && defaults.string(forKey: "profilePicture") != nil && defaults.string(forKey: "profilePicture") != "" {
            self.profilePicture.image = UIImage.getSavedImage(named: self.username.text!)
        }
        
        if defaults.string(forKey: "password") != nil && defaults.string(forKey: "password") != ""{
            self.password.text = defaults.string(forKey: "password")
            self.login(self)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doRealLoggin() {
        do {
            try api.loginUser(username: self.username.text!, password: self.password.text!, completionHandler: { (response, user) in
                if response.status.code == .error {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Failed to login user", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                        self.loginButton.isEnabled = true
                    }
                }else {
                    api.currentUser = user
                    do {
                        try api.getImageDataFromAPI(url: (user!.profileImage.path), completionHandler: { (data) in
                            DispatchQueue.main.async() {
                                let image = UIImage.init(data: data)
                                _ = image?.saveImage(filename: user!.username)
                                self.defaults.set(user!.username, forKey: "profilePicture")
                            }
                        })
                    }catch {}
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let defaults = UserDefaults.standard
                        defaults.set(self.username.text!, forKey : "username")
                        defaults.set(self.password.text!, forKey : "password")
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                        self.loginButton.isEnabled = true
                    }
                }
            })
        }catch{
            loginButton.isEnabled = true
        }
    }
    @IBAction func login(_ sender: Any) {
        loginButton.isEnabled = false
        do {
            self.activityIndicator.startAnimating()
            try api.isLoggedIn(completionHandler: { (response, user) in
                if let loggedinuser = user {
                    api.currentUser = loggedinuser
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                        self.loginButton.isEnabled = true
                    }
                }else{
                    DispatchQueue.main.async {
                        self.doRealLoggin()
                    }
                }
            })
        }catch{
            loginButton.isEnabled = true
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

