//
//  FollowTableViewCell.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-04-08.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    
    private var userId : Int = 0
    var user : TriprUser? = nil
    @IBOutlet weak var profileImage: RoundedImage!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followUserButton: UIButton!
    
    
    
    @IBAction func followUser(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initFromUserId( id _id : Int) {
        
        do {
            try api.getUserInformation(user_id: _id) { (response, user) in
                if response.status.code == .error {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failed to get user information", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    }
                }else {
                    do {
                        guard let usr = user else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Failed to get user information", message: "Failed to get user information", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self.user = usr
                            self.username.text = usr.username
                            self.name.text = "\(usr.firstname) \(usr.lastname)"
                            self.userId = _id
                        }
                        try api.getImageDataFromAPI(url: (user!.profileImage.path), completionHandler: { (data) in
                            DispatchQueue.main.async() {
                                let image = UIImage.init(data: data)
                                self.profileImage.image = image
                            }
                        })
                    }catch {}
                }
            }
        }catch{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Failed to get user information", message: "Failed to get user information", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
