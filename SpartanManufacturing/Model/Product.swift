//
//  Product.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import Foundation

class Product: NSObject {
    
    internal var name: String!
    internal var pending: Int!
    internal var stock: Int!
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let pending = json["pending"] as? Int,
            let stock = json["stock"] as? Int
        else {
            print("Error parsing JSON data")
            return
        }
        self.name = name
        self.pending = pending
        self.stock = stock
    }
    
    
}
