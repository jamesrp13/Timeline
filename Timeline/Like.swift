//
//  Like.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

struct Like: Equatable, FirebaseType {
    
    private let kPost = "post"
    private let kUsername = "username"
    
    let username: String
    let postIdentifier: String
    var identifier: String?
    
    var endpoint: String {
        return "/posts/\(self.postIdentifier)/likes/"
    }
    
    var jsonValue: [String: AnyObject] {
    return [kPost:postIdentifier, kUsername: username]
    }
    
    init(username: String, postIdentifier: String, identifier: String? = nil) {
        self.username = username
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
    
    init?(json: [String : AnyObject], identifier: String) {
        guard let username = json[kUsername] as? String,
            postIdentifier = json[kPost] as? String else {return nil}
        
        self.username = username
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
}

func == (lhs: Like, rhs: Like) -> Bool {
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}