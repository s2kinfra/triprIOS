//
//  FeedType10TableViewCell.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-03-06.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class FeedType10TableViewCell: FeedTypeSuperTableViewCell {

    var entryObject : TriprUser?
    var feedObject : TriprTrip?
    var feedId : Int = 0
    var feedTimestamp : Double = 0
    
    
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(fromTimeline timeline: TriprTimeline) throws {
        self.feedId  = timeline.id
        self.feedTimestamp = timeline.timestamp
        guard let user : TriprUser = timeline.entryObject.user else {
            abort()
        }
        guard let trip : TriprTrip = timeline.feedObject.trip else {
            abort()
        }
        self.entryObject = user
        self.feedObject = trip
        
        self.createdBy.text = self.entryObject!.username
        self.createdAt.text = Date.init(timeIntervalSince1970: self.feedTimestamp).timeAgo(numericDates: true)
        self.tripName.text = self.feedObject!.name
    }
}
