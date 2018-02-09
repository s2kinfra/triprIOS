//
//  RegisterUserViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-08.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func registerUser(_ sender: Any) {
        do{
            loading.startAnimating()
            try api.registerUser(username: username.text!, email: email.text!, firstname: firstname.text!, lastname: lastname.text!, password: password.text!) { (response, user) in
                DispatchQueue.main.async {
                    self.loading.stopAnimating()
                }
                
                if response.status.code == .error {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failed to register user", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    api.currentUser = user
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "User Registered", message: "Welcome \(api.currentUser!.firstname) \(api.currentUser!.lastname)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            switch action.style{
                            case .default :
                                self.cancel(self)
                                
                            case .cancel:
                                self.cancel(self)
                                
                            case .destructive:
                                self.cancel(self)
                            }
                            
                        }))
                        self.present(alert, animated: true,completion:nil)
                    }
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
