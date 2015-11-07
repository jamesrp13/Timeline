//
//  ProfileHeaderCollectionResuableView.swift
//  Timeline
//
//  Created by James Pacheco on 11/5/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var urlButton: UIButton!
    
    @IBOutlet weak var followUserButton: UIButton!
    
    var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    @IBAction func urlButtonTapped(sender: UIButton) {
        self.delegate?.userTappedURLButton(sender)
    }

    @IBAction func followButtonTapped(sender: UIButton) {
        self.delegate?.userTappedFollowActionButton(sender)
        
        
    }

   
    
    func updateWithUser(user: User) {
        if let bio = user.bio {
            bioLabel.text = bio
        } else {
            if bioLabel != nil {
                bioLabel.removeFromSuperview()
            }
        }
        
        if let url = user.url {
            urlButton.setTitle(url, forState: .Normal)
        } else {
            if urlButton != nil {
                urlButton.removeFromSuperview()
            }
        }
        
        if user == UserController.sharedController.currentUser {
            if followUserButton != nil {
                followUserButton.setTitle("Log Out", forState: .Normal)
            } else {
                UserController.userFollowsUser(UserController.sharedController.currentUser, followsUser: user, completion: { (follows) -> Void in
                    if follows {
                        self.followUserButton.setTitle("Unfollow", forState: .Normal)
                    } else {
                        self.followUserButton.setTitle("Follow", forState: .Normal)
                    }
                })
            }
        }
    }
}

protocol ProfileHeaderCollectionReusableViewDelegate {
    func userTappedFollowActionButton(sender: UIButton)
    func userTappedURLButton(sender: UIButton)
}
