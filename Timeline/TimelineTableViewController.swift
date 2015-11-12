//
//  TimelineTableViewController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let currentUser = UserController.sharedController.currentUser {
//            if posts.count == 0 {
//                loadTimeLineForUser(currentUser)
//            }
//        } else {
//            performSegueWithIdentifier("toLoginSignup", sender: nil)
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let currentUser = UserController.sharedController.currentUser {
            if posts.count == 0 {
                loadTimeLineForUser(currentUser)
            }
        } else {
            performSegueWithIdentifier("toLoginSignup", sender: nil)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func loadTimeLineForUser(user: User) {
        PostController.fetchTimelineForUser(user) { (posts) -> Void in
            self.posts = posts
            self.tableView.reloadData()
        }
    }

    @IBAction func userRefreshedTable(sender: AnyObject) {
        PostController.fetchTimelineForUser(UserController.sharedController.currentUser) { (posts) -> Void in
            self.posts = posts
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timelineImageCell", forIndexPath: indexPath) as! PostTableViewCell

        cell.updateWithPost(posts[indexPath.row])

        return cell
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPostDetailView" {
            let cell = sender as! UITableViewCell
            let index = tableView.indexPathForCell(cell)
            if let destinationViewController = segue.destinationViewController as? PostDetailTableViewController {
                destinationViewController.post = posts[(index?.row)!]
            }
        }
    }

}
