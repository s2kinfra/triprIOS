//
//  TimelineTableViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-20.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    
    var timelineData = [TriprTimeline]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do{
            try api.getUserTimeline(startIndex: 0, numberOfFeeds: 20) { timelines in
                
                self.timelineData.removeAll()
                for timeline in timelines {
                    self.timelineData.append(timeline)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    func fillTableCellForTimelineType(timeline: TriprTimeline, indexPath : IndexPath) throws -> UITableViewCell {
        switch timeline.feedType {
            
        case .followAccepted :
            print("followAccepted")
            return UITableViewCell()
        case .followDeclined :
            print("followDeclined")
            return UITableViewCell()
        case .followRequest :
            print("followRequest")
            return UITableViewCell()
        case .tripCreated :
            /*
             FT10
             Entry object User
             Feed object Trip
             */
            print("tripCreated")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ft10", for: indexPath) as! FeedType10TableViewCell
            try cell.setData(fromTimeline: timeline)
            return cell
        case .tripFollowed :
            print("tripFollowed")
            return UITableViewCell()
        case .tripUpdated :
            print("tripUpdated")
            return UITableViewCell()
        case .commentAdded :
            /*
             FT20
             Entry object Trip
             feed object Comment
             */
            print("commentAdded")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ft20", for: indexPath) as! FeedType20TableViewCell
            try cell.setData(fromTimeline: timeline)
            
            return cell
        case .photoAdded :
            print("photoAdded")
            return UITableViewCell()
        case .destinationCreated :
            print("destinationCreated")
            return UITableViewCell()
        case .destinationUpdated:
            print("destinationUpdated")
            return UITableViewCell()
        case .unknown :
            print("unknown feed type")
            return UITableViewCell()
        default :
            print("undefined feed type")
            return UITableViewCell()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelineData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        do{
            let data = timelineData[indexPath.row]
            let cell = try self.fillTableCellForTimelineType(timeline: data, indexPath: indexPath)
            
            return cell
        }catch let error {
            print(error.localizedDescription)
            return UITableViewCell()
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
