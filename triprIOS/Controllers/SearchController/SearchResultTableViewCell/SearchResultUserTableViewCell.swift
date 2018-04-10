//
//  SearchResultUserTableViewCell.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-04-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class SearchResultUserTableViewCell: UITableViewCell {
    
    var user : TriprUser? = nil
    @IBOutlet weak var profileImage: RoundedImage!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followUserButton: UIButton!
    
    
    @IBAction func followUser(_ sender: Any) {
        
    }
    
    func setCellData() {
        if let usr = user {
            self.username.text = usr.username
            self.name.text = "\(usr.firstname) \(usr.lastname)"
            do{
                try api.getImageDataFromAPI(url: (user!.profileImage.path), completionHandler: { (data) in
                    DispatchQueue.main.async() {
                        let image = UIImage.init(data: data)
                        self.profileImage.image = image
                    }
                })
            }catch {
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
