//
//  ProfileViewController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ProfileHeaderCollectionReusableViewDelegate {
    
    var user: User!
    var userPosts: [Post] = []
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(user?.username)")
        // Do any additional setup after loading the view.
        if self.user == nil {
            self.user = UserController.sharedController.currentUser
            editBarButton.enabled = true
        }
    }
    
    func updateBasedOnUser(user: User) {
        PostController.postsForUser(user) { (posts) -> Void in
            if let posts = posts {
                self.userPosts = posts
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if userPosts.count != 0 {
            
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        let post = userPosts[indexPath.item]
        cell.updateWithImageIdentifier(post.imageEndPoint)
        return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // ProfileHeaderCollectionReusableView
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "infoCell", forIndexPath: indexPath) as! ProfileHeaderCollectionReusableView
        header.delegate = self
        header.updateWithUser(user)
        
        return header
    }
    
    func userTappedURLButton(sender: UIButton) {
        if let profileURL = NSURL(string: user.url!) {
            let safariVC = SFSafariViewController(URL: profileURL)
            presentViewController(safariVC, animated: true, completion: nil)
        }
    }
    
    func userTappedFollowActionButton(sender: UIButton) {
        if user == UserController.sharedController.currentUser {
            UserController.logoutCurrentUser()
            tabBarController?.selectedViewController = tabBarController?.viewControllers![0]
        } else {
            UserController.userFollowsUser(UserController.sharedController.currentUser, followsUser: user) {( follows) -> Void in
                if follows {
                    UserController.unfollowUser(self.user, completion: { (success) -> Void in
                        self.updateBasedOnUser(self.user)
                    })
                } else {
                    UserController.followUser(self.user, completion: { (success) -> Void in
                        self.updateBasedOnUser(self.user)
                    })
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEditProfile" {
            if let destinationViewController = segue.destinationViewController as? LoginSignupViewController {
                _ = destinationViewController.view
                destinationViewController.updateWithUser()
            }
        }
    }
}
