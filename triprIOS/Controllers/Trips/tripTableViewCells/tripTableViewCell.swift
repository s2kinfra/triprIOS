//
//  tripTableViewCell.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-03-06.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class tripTableViewCell: UITableViewCell {

    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var numberOfTravellers: UILabel!
    
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
        if trip.followers != nil {
            self.numberOfTravellers.text = String(trip.followers!.count)
        }else {
            self.numberOfTravellers.text = "0"
        }
        
    }
    
}
