//
//  Comment.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

struct Comment: Equatable {
    
    let username: String
    var text: String
    let postIdentifier: String
    var identifier: String?
    
    init(username: String, text: String, postIdentifier: String, identifier: String? = nil) {
        self.username = username
        self.text = text
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
}

func == (lhs: Comment, rhs: Comment) -> Bool {
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}