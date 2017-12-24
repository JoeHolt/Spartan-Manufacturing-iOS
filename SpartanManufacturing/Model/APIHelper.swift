//
//  APIHelper.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import Foundation

class APIHelper: NSObject {
    
    let urlString = "http://10.0.1.188:8081"
    
    internal func getAllProducts(finishedClosure:@escaping (([Product]?)-> Void)) {
        let url = urlString + "/api/getproducts"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        //var params = ["username":"username", "password":"password"] as Dictionary<String, String>
        //request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                if let arr = json {
                    var products = [Product]()
                    for dic in arr {
                        if let d = dic as? [String: Any] {
                            products.append(Product(json: d)!)
                        }
                    }
                    finishedClosure(products)
                }
            } else {
                print("Error fetching data")
                finishedClosure(nil)
            }
        })
        task.resume()
    }
    
    internal func getAllOrders(finishedClosure:@escaping (([Order]?) -> Void)) {
        let url = urlString + "/api/getorders"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                if let arr = json {
                    var orders = [Order]()
                    for dic in arr {
                        if let d = dic as? [String: Any] {
                            let newProduct = Order(json: d)
                            orders.append(newProduct!)
                        }
                    }
                    finishedClosure(orders)
                }
            } else {
                print("Error loading orders")
                finishedClosure(nil)
            }
        }
        task.resume()
    }
    
}


