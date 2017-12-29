//
//  Order.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/24/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

class Order: NSObject {
    internal var name: String!
    internal var number: Int?
    internal var status: String!
    internal var date: Date?
    internal var notes: String?
    
    init(name: String, number: Int?, status: String, date: Date?, notes: String?) {
        self.name = name
        self.number = number
        self.status = status
        self.date = date
        self.notes = notes
    }
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let number = json["number"] as? Int,
            let status = json["status"] as? String,
            let date = json["date"] as? String,
            let notes = json["notes"] as? String
        else {
            return nil
        }
        self.name = name
        self.number = number
        self.notes = notes
        self.status = status
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:m:s"
        self.date = formatter.date(from: date)
    }
}
