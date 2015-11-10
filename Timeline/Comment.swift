//
//  Comment.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

struct Comment: Equatable, FirebaseType {
    
    private let kPost = "post"
    private let kUsername = "username"
    private let kText = "text"
    
    let username: String
    var text: String
    let postIdentifier: String
    var identifier: String?
    
    var endpoint: String {
        return "/posts/\(self.postIdentifier)/comments/"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kPost: postIdentifier, kUsername:username, kText: text]
    }
    
    init(username: String, text: String, postIdentifier: String, identifier: String? = nil) {
        self.username = username
        self.text = text
        self.postIdentifier = postIdentifier
        self.identifier = identifier
    }
    
    init?(json: [String : AnyObject], identifier: String) {
        guard let postIdentifier = json[kPost] as? String,
        username = json[kUsername] as? String,
            text = json[kText] as? String else {return nil}
        self.postIdentifier = postIdentifier
        self.username = username
        self.text = text
        self.identifier = identifier
    }
    
}

func == (lhs: Comment, rhs: Comment) -> Bool {
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}