//
//  Post.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

struct Post: Equatable {
    
    let imageEndPoint: String
    var caption: String?
    let username: String
    let comments: [Comment]
    let likes: [Like]
    var identifier: String?
    
    init(imageEndPoint: String, caption: String? = nil, username: String = UserController.sharedController.currentUser.username, comments: [Comment] = [], likes: [Like] = [], identifier: String? = nil) {
        self.imageEndPoint = imageEndPoint
        self.caption = caption
        self.username = username
        self.comments = comments
        self.likes = likes
        self.identifier = identifier
    }
    
}

func == (lhs: Post, rhs: Post) -> Bool {
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}
