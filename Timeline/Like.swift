//
//  Like.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

struct Like: Equatable {
    let username: String
    let postIdentifier: String
    var identifier: String?
    
    init(username: String, postIdentifier: String, identifier: String? = nil) {
        self.username = username
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
}

func == (lhs: Like, rhs: Like) -> Bool {
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}