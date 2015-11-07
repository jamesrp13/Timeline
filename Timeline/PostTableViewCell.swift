//
//  PostTableViewCell.swift
//  Timeline
//
//  Created by James Pacheco on 11/7/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithPost(post: Post) {
        ImageController.imageForIdentifier(post.imageEndPoint) { (image) -> Void in
            self.postImageView.image = image
        }
        likesLabel.text = "\(post.likes.count) likes"
        commentsLabel.text = "\(post.comments.count) comments"
    }

}
