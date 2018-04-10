//
//  SearchTableViewController.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-04-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    enum searchArea : Int {
        case user = 0, trip = 1
    }
    
    struct searchResult {
        var area : searchArea
        var user : TriprUser?
        var trip : TriprTrip?
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users : [TriprUser] = [TriprUser]()
    var trips : [TriprTrip] = [TriprTrip]()
    
    var total = [searchResult]()
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text changes (including clear)
        self.search(searchBar)
    }
    
    func reloadData() {
        print("reload data")
        total.removeAll()
        for user in self.users {
            let searchRes = searchResult.init(area: .user, user: user, trip: nil)
            total.append(searchRes)
        }
        for trip in self.trips {
            let searchRes = searchResult.init(area: .trip, user: nil, trip: trip)
            total.append(searchRes)
        }
        
        self.tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.search(searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func search(_ searchBar : UISearchBar) {
        if let searchTerm = searchBar.text {
            if searchTerm == "" {
                users.removeAll()
                trips.removeAll()
                reloadData()
            }
            if searchTerm.count > 2 {
                do {
                    
                    try api.searchForAll(searchTerm: searchTerm) { (response, trips, users) in
                        if response.status.code == .error {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Failed to search", message: response.status.text, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                self.present(alert, animated: true, completion: nil)
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            if let foundUsers = users {
                                self.users = foundUsers
                            }
                            if let foundTrips = trips {
                                self.trips = foundTrips
                            }
                            self.reloadData()
                        }
                    }
                }catch {
                    let alert = UIAlertController(title: "Failed to search", message: "Failed to get a search result from server", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return users.count
        case 1:
            return trips.count
        default:
            return 0
        }
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        switch indexPath.section {
        case 0:
            let user = users[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! SearchResultUserTableViewCell
            cell.user = user
            cell.setCellData()
            return cell
        case 1:
            let trip = trips[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "trip", for: indexPath) as UITableViewCell
            cell.textLabel?.text = trip.name
            if trip.isPrivate == 0 {
                cell.detailTextLabel?.text = "Public"
            }else {
                cell.detailTextLabel?.text = "Private"
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "trip", for: indexPath) as UITableViewCell
            return cell
        }
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = self.tableView.indexPathForSelectedRow
        switch indexPath?.section {
        case 0:
            //            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            //            let vc : ProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            //
            //            let user = users[(indexPath?.row)!]
            //            vc.displayedUser = user
            //            self.present(vc, animated: true, completion: nil)
            let user = users[(indexPath?.row)!]
            self.tabBarController!.present(ProfileViewController.displayUser(user: user), animated: true, completion: nil) 
        case 1:
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if users.count > 0{
                return "Users"
            }else {
                return ""
            }
        case 1:
            if trips.count > 0{
                return "Trips"
            }else {
                return ""
            }
        default:
            return "Unknown"
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
    
    
    
}
