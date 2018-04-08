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
