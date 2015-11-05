//
//  ImageController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class ImageController {

    static func uploadImage(image: UIImage, completion: (identifier: String) -> Void) {
        
        completion(identifier: "-K1l4125TYvKMc7rcp5e")
    }
    
    static func imageForIdentifier(identifier: String, completion: (image: UIImage?) -> Void) {
     
        completion(image: UIImage(named: "mockPhoto"))
    }
    
    
}