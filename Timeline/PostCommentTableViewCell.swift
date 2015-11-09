//
//  PostCommentTableViewCell.swift
//  Timeline
//
//  Created by James Pacheco on 11/8/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithComment(comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.text
    }

}
