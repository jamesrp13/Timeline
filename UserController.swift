//
//  UserController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

class UserController {
    
    static let sharedController = UserController()
    
    var currentUser: User!
    
    init(currentUser: User! = UserController.mockUsers().first) {
        
    }
    
    static func userForIdentifier (identifier: String, completion: (user: User?) -> Void) {
        
        completion(user: mockUsers().first)
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        
        completion(users: mockUsers())
    }
    
    static func followUser(user: User, completion: (success: Bool) -> Void) {
        
        completion(success: true)
    }
    
    static func userFollowsUser(user: User, followsUser: User, completion: (follows: Bool) -> Void) {
        
        completion(follows: true)
    }
    
    static func followedByUser(user: User, completion: (followed: [User]?) -> Void) {
     
        completion(followed: mockUsers())
    }
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        
        completion(success: true, user: mockUsers().first)
    }
    
    static func createUser(email: String, username: String, password: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        
        completion(success: true, user: mockUsers().first)
    }
    
    static func updateUser(user: User, username: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        
        completion(success: true, user: mockUsers().first)
    }
    
    static func logoutCurrentUser() {
        
    }
    
    static func mockUsers() -> [User] {
        let user1 = User(username: "hansolo", identifier: "1234")
        let user2 = User(username: "ob1kenob", identifier: "1235")
        let user3 = User(username: "3po", identifier: "1236")
        
        return [user1, user2, user3]
    }
}