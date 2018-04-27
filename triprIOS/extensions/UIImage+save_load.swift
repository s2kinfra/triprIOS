//
//  UIImage+save_load.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-04-06.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func saveImage(filename : String) -> Bool {
        guard let data = UIImageJPEGRepresentation(self, 1) ?? UIImagePNGRepresentation(self) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(filename)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
}

extension UIImage {
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            //            let newImage = UIImage(cgImage: context.makeImage()!)
            let newImage = UIImage(cgImage: context.makeImage()!, scale: scale, orientation: .up)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    func scaleImage(newWidth: Int) -> UIImage? {
        
        let scale = CGFloat(newWidth) / self.size.width
        let newHeight = self.size.height * scale
        
        let newSize = CGSize.init(width: CGFloat(newWidth), height: newHeight)
        
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            //            let newImage = UIImage(cgImage: context.makeImage()!)
            let newImage = UIImage(cgImage: context.makeImage()!, scale: scale, orientation: .up)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    func scaleImage(byPercent: Int) -> UIImage? {
        let percent : CGFloat = CGFloat(( byPercent / 100 ))
        if percent == 0 {
            return nil
        }
        
        let newHeight = self.size.height * percent
        let newWidth = self.size.width * percent
        
        let newRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight).integral
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: newWidth, height: newHeight), false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newHeight)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            //            let newImage = UIImage(cgImage: context.makeImage()!)
            let newImage = UIImage(cgImage: context.makeImage()!, scale: scale, orientation: .up)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
}

