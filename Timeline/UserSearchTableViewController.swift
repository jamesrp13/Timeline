//
//  UserSearchTableViewController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class UserSearchTableViewController: UITableViewController, UISearchResultsUpdating {

    enum ViewMode: Int {
        case Friends
        case All
        
        func users(completion: (users: [User]?)->Void) {
            switch self {
            case .Friends:
                UserController.followedByUser(UserController.sharedController.currentUser, completion: { (followed) -> Void in
                    completion(users: followed)
                })
            case .All:
                UserController.fetchAllUsers({ (users) -> Void in
                completion(users: users)
                })
            }
        }
    }
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    var usersDataSource = [User]()
    
    var searchController: UISearchController!
    
    var mode: ViewMode {
        return ViewMode(rawValue: modeSegmentedControl.selectedSegmentIndex)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViewBasedOnMode()
        setupSearchController()
    }

    @IBAction func selectedIndexChanged(sender: AnyObject) {
        updateViewBasedOnMode()
    }

    func updateViewBasedOnMode() {
        self.mode.users { (users) -> Void in
            if let users = users {
                self.usersDataSource = users
            } else {
                self.usersDataSource = []
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersDataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)

        cell.textLabel?.text = usersDataSource[indexPath.row].username

        return cell
    }
    
    // Mark: Search Controller
    
    func setupSearchController() {
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("userSearchResults")
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text!.lowercaseString
        let resultsViewController = searchController.searchResultsController as! UserSearchResultsTableViewController
        
        resultsViewController.userSearchResultsDataSource = self.usersDataSource.filter({$0.username.lowercaseString.containsString(searchTerm)})
        resultsViewController.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "toProfileView" else {return}
        guard let destinationViewController = segue.destinationViewController as? ProfileViewController else {return}
        
        if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
            destinationViewController.user = usersDataSource[indexPath.row]
        } else {
            let resultsController = searchController.searchResultsController as! UserSearchResultsTableViewController
            if let indexPath = resultsController.tableView.indexPathForCell(sender as! UITableViewCell) {
                destinationViewController.user = resultsController.userSearchResultsDataSource[indexPath.row]
            }
        }
    }
    

}
