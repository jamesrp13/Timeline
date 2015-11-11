//
//  UserController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

class UserController {
    
    private let kUser = "user"
    
    static let sharedController = UserController()
    
    var currentUser: User! {
        get{
            guard let uid = FirebaseController.base.authData?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else {return nil}
            
            return User(json: userDictionary, identifier: uid)
            
        }
        
        set{
            
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            
        }
    }
    
    init(currentUser: User! = nil) {
        
    }
    
    static func userForIdentifier (identifier: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        FirebaseController.observeDataAtEndpoint("users") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let users = json.flatMap({User(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                completion(users: users)
            } else {
                completion(users: [])
            }
        }
    }
    
    static func followUser(user: User, completion: (success: Bool) -> Void) {
        FirebaseController.base.childByAppendingPath("/users/\(sharedController.currentUser.identifier!)/follows/\(user.identifier!)").setValue(true)
        completion(success: true)
    }
    
    static func unfollowUser(user: User, completion: (success: Bool) -> Void) {
        FirebaseController.base.childByAppendingPath("/user/\(sharedController.currentUser.identifier!)/follows/\(user.identifier!)").removeValue()
        completion(success: true)
    }
    
    static func userFollowsUser(user: User, followsUser: User, completion: (follows: Bool) -> Void) {
        FirebaseController.dataAtEndpoint("/user/\(sharedController.currentUser.identifier!)/follows/\(user.identifier!)") { (data) -> Void in
            if let _ = data {
                completion(follows: true)
            } else {
                completion(follows: false)
            }
        }
    }
    
    static func followedByUser(user: User, completion: (followed: [User]?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(user.identifier!)/follows/") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                var followedUsers: [User] = []
                for userJson in json {
                    userForIdentifier(userJson.0, completion: { (user) -> Void in
                        if let user = user {
                            followedUsers.append(user)
                            completion(followed: followedUsers)
                        }
                    })
                }
            } else {
                completion(followed: [])
            }
        }
    }
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, authData) -> Void in
            if error != nil {
                completion(success: false, user: nil)
            } else {
                userForIdentifier(authData.uid, completion: { (user) -> Void in
                    if let user = user {
                        sharedController.currentUser = user
                    }
                    completion(success: true, user: user)
                })
            }
        }
    }
    
    static func createUser(email: String, username: String, password: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            if error != nil {
                completion(success: false, user: nil)
            } else {
                if let uid = response["uid"] as? String {
                    var user = User(username: username, bio: bio, url: url, identifier: uid)
                    user.save()
                    
                    authenticateUser(email, password: password, completion: { (success, user) -> Void in
                        print("Successful creation of user")
                        completion(success: true, user: user)
                    })
                } else {
                    print("Creating user didn't work")
                    completion(success: false, user: nil)
                }
            }
        }
    }
    
    static func updateUser(user: User, username: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        var updatedUser = User(username: username, bio: bio, url: url, identifier: user.identifier!)
        updatedUser.save()
  
        userForIdentifier(user.identifier!) { (user) -> Void in
            if let user = user {
                sharedController.currentUser = user
                completion(success: true, user: user)
            } else {
                completion(success: false, user: nil)
            }
        }
    }
    
    static func logoutCurrentUser() {
        FirebaseController.base.unauth()
        sharedController.currentUser = nil
    }
    
    static func mockUsers() -> [User] {
        let user1 = User(username: "hansolo", identifier: "1234")
        let user2 = User(username: "ob1kenob", identifier: "1235")
        let user3 = User(username: "3po", identifier: "1236")
        
        return [user1, user2, user3]
    }
}