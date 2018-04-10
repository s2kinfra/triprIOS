//
//  ProfileViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    typealias bufferedImage = (image: UIImage, id : Int)
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userid: UILabel!
//    @IBOutlet weak var follows: UILabel!
//    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var follows: UIButton!
    @IBOutlet weak var followers: UIButton!
    
    var displayedUser : TriprUser?
    var storedImage : bufferedImage?
    let defaults = UserDefaults.standard
    var imagePicker = UIImagePickerController()
    
    
    static func displayUser(user _user : TriprUser) -> UINavigationController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let nc : UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewNavigationController") as! UINavigationController
        
        let vc : ProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.displayedUser = _user
        let nc = UINavigationController(rootViewController: vc)
        return nc
        
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
       
         let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.storedImage?.image = pickedImage
            do {
                try api.setUserProfileImage(imageData: UIImagePNGRepresentation(pickedImage)!, filename: "profilePicture.png") { response in
                    if response.status.code == .error {
                        DispatchQueue.main.async {
                            self.storedImage?.id = -1
                            let alert = UIAlertController(title: "Failed to upload profile picture", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }catch {
                self.storedImage?.id = -1
                let alert = UIAlertController(title: "Failed to upload profile picture", message: "Couldn´t upload profile picture", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openCamera()
    {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
        }else{
//            we are comming from some other way
            
            let backButton2 = UIBarButtonItem()
            backButton2.title = "Back"
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton2
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
            self.followers.setTitle(String(followerCount), for: .normal)
        }else {
            self.followers.setTitle("0", for: .normal)
        }
        
        if let followingCount = duser.following?.count {
            self.follows.setTitle(String(followingCount), for: .normal)
        }else{
            self.follows.setTitle("0", for: .normal)
        }
        
        updateProfilePicture()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followers" {
            if let destinationVC = segue.destination as? FollowTableViewController {
                destinationVC.follow = (displayedUser?.followers)!
                destinationVC.title = "Followers"
            }
        }
        
        if segue.identifier == "follows" {
            if let destinationVC = segue.destination as? FollowTableViewController {
                destinationVC.follow = (displayedUser?.following)!
                destinationVC.title = "Follows"
            }
        }
    }
    func updateProfilePicture() {
        guard let duser = displayedUser else {
            return
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
