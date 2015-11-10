//
//  FirebaseController.swift
//  Timeline
//
//  Created by James Pacheco on 11/9/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let base = Firebase(url: "https://fierytimeline.firebaseio.com/#-K2hFL-X6CgKAEU2pAo6|9b11fe976490dfc24b36c75ae97e33d0")
    
    static func dataAtEndpoint(endpoint: String, completion: (data:AnyObject?) -> Void)  {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        baseForEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    static func observeDataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        baseForEndpoint.observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
}

protocol FirebaseType {
    var identifier: String? {get set}
    var endpoint: String {get}
    var jsonValue: [String: AnyObject] {get}
    
    init?(json: [String:AnyObject], identifier: String)
    
    mutating func save()
    func delete()
}

extension FirebaseType {
    mutating func save() {
        var endpointBase: Firebase
        
        if let identifier = self.identifier {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(identifier)
        } else {
            endpointBase = FirebaseController.base.childByAutoId()
            self.identifier = endpointBase.key
        }
        endpointBase.updateChildValues(jsonValue)
    }
    
    func delete() {
        if let identifier = self.identifier {
            let endpointBase: Firebase = FirebaseController.base.childByAppendingPath(identifier)
            
            endpointBase.removeValue()
        }
    }
}