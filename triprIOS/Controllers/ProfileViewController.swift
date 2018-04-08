//
//  ProfileViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    typealias bufferedImage = (image: UIImage, id : Int)
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userid: UILabel!
    @IBOutlet weak var follows: UILabel!
    @IBOutlet weak var followers: UILabel!
    
    var displayedUser : TriprUser?
    var storedImage : bufferedImage?
    let defaults = UserDefaults.standard
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        do{
            try api.logoutUset(completionHandler: { apiresponse in
                if apiresponse.status.code == .ok {
                    DispatchQueue.main.async {
                        self.defaults.set("", forKey: "password")
                        //Remove user credentials
                        let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
                        self.present(rootController, animated: true, completion: nil)
                    }
                }
            })
        }catch let error {
            print(error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if displayedUser == nil {
            displayedUser = api.currentUser!
        }
        
        guard let duser = displayedUser else {
            return
        }
        
        self.fullname.text = "\(duser.firstname) \(duser.lastname)"
        if self.fullname.text == "" {
            self.fullname.text = "@\(duser.username)"
        }
        self.title = duser.username
        self.userid.text = String(describing: duser.id)
        
        if let followerCount = duser.followers?.count {
            self.followers.text = String(followerCount)
        }else {
             self.followers.text = "0"
        }
        
        if let followingCount = duser.following?.count {
            self.follows.text = String(followingCount)
        }else{
            self.follows.text = "0"
        }
        
        do{
            if duser.profileImage.id != storedImage?.id {
                try api.getImageDataFromAPI(url: (duser.profileImage.path), completionHandler: { (data) in
                    DispatchQueue.main.async() {
                        self.profileImage.image = UIImage(data: data)
                        _ = self.profileImage.image?.saveImage(filename: duser.username)
                        self.defaults.set(duser.username, forKey: "profilePicture")
                        let buffer = bufferedImage(image: UIImage(data: data)!, id:duser.profileImage.id )
                        self.storedImage = buffer
                    }
                })
            }else{
                self.profileImage.image = self.storedImage?.image
            }
        }catch{
            
        }
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
