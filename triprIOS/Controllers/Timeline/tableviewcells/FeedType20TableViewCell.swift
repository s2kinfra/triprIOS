//
//  FeedType20TableViewCell.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-03-06.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class FeedType20TableViewCell: FeedTypeSuperTableViewCell {
    
    var entryObject : TriprTrip?
    var feedObject : TriprComment?
    var feedId : Int = 0
    var feedTimestamp : Double = 0
    
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var commentBy: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(fromTimeline timeline: TriprTimeline) throws {
        self.feedId  = timeline.id
        self.feedTimestamp = timeline.timestamp
        guard let trip : TriprTrip = timeline.entryObject.trip else {
            abort()
        }
        guard let comment : TriprComment = timeline.feedObject.comment else {
            abort()
        }
        self.entryObject = trip
        self.feedObject = comment
        
        self.tripName.text = self.entryObject!.name
        self.commentBy.text = self.feedObject!.writtenBy.firstname
        self.commentText.text = self.feedObject!.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
