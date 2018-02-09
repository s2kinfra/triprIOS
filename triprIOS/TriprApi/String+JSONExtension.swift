//
//  String+JSONExtension.swift
//  triprIOS
//
//  Created by Daniel Skevarp on 2018-02-09.
//  Copyright © 2018 Daniel Skevarp. All rights reserved.
//

import Foundation

extension String {
    func prettyPrintJSONString() throws -> String {
        let jsondata = self.data(using: .utf8)
        let string = try JSONSerialization.jsonObject(with: jsondata!)
        let hmm = try JSONSerialization.data(withJSONObject: string, options: .prettyPrinted)
        return (String.init(data: hmm, encoding: .utf8))!
    }
}
