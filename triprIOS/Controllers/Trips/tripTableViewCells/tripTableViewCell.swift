//
//  tripTableViewCell.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-03-06.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class tripTableViewCell: UITableViewCell {
    
    typealias bufferedImage = (image: UIImage, id : Int)
    var storedImage : bufferedImage?
    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var numberOfTravellers: UILabel!
    @IBOutlet weak var tripImage: UIImageView!
    var trip : TriprTrip?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(fromTrip trip: TriprTrip) throws {
        self.tripDate.text = Date.init(timeIntervalSince1970: trip.timestamp).timeAgo(numericDates: true)
        self.tripName.text = trip.name
        if let tripImage = trip.tripImage {
            if tripImage.id != storedImage?.id {
                try api.getImageDataFromAPI(url: (tripImage.path), completionHandler: { (data) in
                    DispatchQueue.main.async() {
                        self.tripImage.image = UIImage(data: data)
                        let buffer = bufferedImage(image: UIImage(data: data)!, id:tripImage.id )
                        self.storedImage = buffer
                    }
                })
            }else{
                self.tripImage.image = self.storedImage?.image
            }
        }else{
            self.tripImage.image = nil
        }
        print(trip.destinations)
        if trip.followers != nil {
            self.numberOfTravellers.text = String(trip.followers!.count)
        }else {
            self.numberOfTravellers.text = "0"
        }
        
    }
    
}
