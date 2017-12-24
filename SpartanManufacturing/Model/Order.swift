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
    internal var number: Int!
    internal var completed: Bool!
    internal var date: Date!
    internal var notes: String!
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let number = json["number"] as? Int,
            let completed = json["completed"] as? String,
            let date = json["date"] as? String,
            let notes = json["notes"] as? String
        else {
            return nil
        }
        self.name = name
        self.number = number
        self.notes = notes
        self.completed = false
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:m:s"
        self.date = formatter.date(from: date)
        if completed.lowercased() == "yes" {
            self.completed = true
        }
    }
}
