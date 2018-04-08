//
//  RoundedImage.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-04-08.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImage: UIImageView {

    override var image: UIImage! {
        get {
            return super.image
        }
        set {
            super.image = newValue
            self.clipsToBounds = true
            self.cornerRadius = self.frame.size.width / 2
        }
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 2 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    @IBInspectable
    public var borderWidth : CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    @IBInspectable
    public var borderColor : UIColor = UIColor(white: 1, alpha: 1) {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
}
