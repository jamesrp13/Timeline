//
//  PostController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class PostController {
    
    static func fetchTimelineForUser(user: User, completion: (posts: [Post]) -> Void) {
        
        completion(posts: mockPosts())
    }
    
    static func addPost(image: UIImage, caption: String?, completion: (success: Bool, post: Post?) -> Void) {

        ImageController.uploadImage(image) { (identifier) -> Void in
            if let identifier = identifier {
                var post = Post(imageEndPoint: identifier, caption: caption, username: UserController.sharedController.currentUser.username)
                post.save()
                completion(success: true, post: post)
            } else {
                completion(success: false, post: nil)
            }
        }
        completion(success: true, post: mockPosts().first)
    }
    
    static func postFromIdentifier(identifier: String, completion: (post: Post?) -> Void) {
        FirebaseController.dataAtEndpoint("/posts/\(identifier)") { (data) -> Void in
            if let data = data as? [String:AnyObject] {
                let post = Post(json: data, identifier: identifier)
                completion(post: post)
            } else {
                completion(post: nil)
            }
        }
    }
    
    static func postsForUser(user: User, completion: (posts: [Post]?) -> Void) {
        FirebaseController.base.childByAppendingPath("posts").queryOrderedByChild("username").queryEqualToValue(user.username).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if let postDictionaries = snapshot.value as? [String:AnyObject] {
                let posts = postDictionaries.flatMap({Post(json: $0.1 as! [String:AnyObject], identifier: $0.0) })
                let orderedPosts = orderPosts(posts)
                completion(posts: orderedPosts)
            } else {
                completion(posts: nil)
            }
        })
    }
    
    static func deletePost(post: Post) {
        post.delete()
    }
  
//    Implement the addCommentWithTextToPost to check for a postIdentifier (if none, save the post, thereby getting a postIdentifier), initialize a Comment, save the comment, fetch the updated post using the identifier, and calling the completion closure with the newly fetched Post.
    
    static func addCommentWithTextToPost(text: String, post: Post, completion: (success: Bool, post: Post?) -> Void) {
        if let identifier = post.identifier {
            var comment = Comment(username: UserController.sharedController.currentUser.username, text: text, postIdentifier: identifier)
            comment.save()
            PostController.postFromIdentifier(comment.postIdentifier, completion: { (post) -> Void in
                completion(success: true, post: post)
            })
        } else {
            var post = post
            post.save()
            var comment = Comment(username: UserController.sharedController.currentUser.username, text: text, postIdentifier: post.identifier!)
            comment.save()
            PostController.postFromIdentifier(comment.postIdentifier, completion: { (post) -> Void in
                completion(success: true, post: post)
            })
        }
    }
 
    static func deleteComment(comment: Comment, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func addLikeToPost(post: Post, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func deleteLike(like: Like, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func orderPosts(posts: [Post]) -> [Post] {
        return []
    }
    
    static func mockPosts() -> [Post] {
        let sampleImageIdentifier = "-K1l4125TYvKMc7rcp5e"
        
        let like1 = Like(username: "darth", postIdentifier: "1234")
        let like2 = Like(username: "look", postIdentifier: "4566")
        let like3 = Like(username: "em0r0r", postIdentifier: "43212")
        
        let comment1 = Comment(username: "ob1kenob", text: "use the force", postIdentifier: "1234")
        let comment2 = Comment(username: "darth", text: "join the dark side", postIdentifier: "4566")
        
        let post1 = Post(imageEndPoint: sampleImageIdentifier, caption: "Nice shot!", comments: [comment1, comment2], likes: [like1, like2, like3])
        let post2 = Post(imageEndPoint: sampleImageIdentifier, caption: "Great lookin' kids!")
        let post3 = Post(imageEndPoint: sampleImageIdentifier, caption: "Love the way she looks when she smiles like that.")
        
        return [post1, post2, post3]
    }
}