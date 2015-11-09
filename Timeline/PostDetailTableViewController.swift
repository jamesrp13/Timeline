//
//  PostDetailTableViewController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            updateBasedOnPost(post)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func updateBasedOnPost(post: Post) {
        self.post = post
            ImageController.imageForIdentifier(post.imageEndPoint, completion: { (image) -> Void in
                self.headerImageView.image = image
            })
            likesLabel.text = "\(post.likes.count) likes"
            commentsLabel.text = "\(post.comments.count) comments"
    }

    @IBAction func likeTapped(sender: AnyObject) {
        if let post = post {
            PostController.addLikeToPost(post, completion: { (success, post) -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func addCommentTapped(sender: AnyObject) {
        let commentAlert = UIAlertController(title: "Write your comment below", message: "", preferredStyle: .Alert)
        
        commentAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Comment"
        }
        
        commentAlert.addAction(UIAlertAction(title: "Add Comment", style: .Default, handler: { (_) -> Void in
            if let text = commentAlert.textFields?.first?.text {
                PostController.addCommentWithTextToPost(text, post: self.post, completion: { (success, post) -> Void in
                    if let post = post {
                        self.updateBasedOnPost(post)
                    }
                })
            }
        }))
        commentAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(commentAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.comments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! PostCommentTableViewCell
        cell.updateWithComment(self.post.comments[indexPath.row])
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
