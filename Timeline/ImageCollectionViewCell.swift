//
//  ImageCollectionViewCell.swift
//  Timeline
//
//  Created by James Pacheco on 11/6/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func updateWithImageIdentifier(identifier: String) {
        ImageController.imageForIdentifier(identifier) { (image) -> Void in
            self.imageView.image = UIImage(named: identifier)
        }
    }
}
