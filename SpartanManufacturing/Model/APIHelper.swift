//
//  APIHelper.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import Foundation

class APIHelper: NSObject {
    
    let urlString = "http://13.58.161.45"
    
    internal func getAllProducts(finishedClosure:@escaping (([Product]?)-> Void)) {
        let url = urlString + "/api/getproducts"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
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
                            if let new = newProduct {
                                orders.append(new)
                            }
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
    
    internal func getAllStatusCodes(finishedClosure:@escaping (([String]?) -> Void)) {
        let url = urlString + "/api/getstatuscodes"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                if let arr = json {
                    var codes = [String]()
                    for dic in arr {
                        if let d = dic as? [String: Any] {
                            let str = d["name"] as? String
                            if let new = str {
                                codes.append(new)
                            }
                        }
                    }
                    finishedClosure(codes)
                }
            } else {
                print("Error loading status codes")
                finishedClosure(nil)
            }
        }
        task.resume()
    }
    
    internal func deleteOrder(withOrderID id: Int) {
        let url = urlString + "/api/deleteorder"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let data = "id=\(id)"
        request.httpBody = data.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("Error deleting product")
            } else {
                print("Deleted order: \(id)")
            }
        }
        task.resume()
    }
    
    internal func modifyStatus(status: String, num: Int) {
        let url = urlString + "/api/modifystatus"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let data = "status=\(status)&number=\(num)"
        request.httpBody = data.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("Error marking order completed")
            } else {
                print("Changed status (\(status)): \(num)")
            }
        }
        task.resume()
    }
    
    internal func addOrder(order: Order) {
        let url = urlString + "/api/addorder"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let n = order.number
        var num = ""
        if let number = n {
            num = "\(number)"
        }
        let data = "number=\(num)&notes=\(order.notes ?? "")&name=\(order.name!)"
        request.httpBody = data.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("Error adding item")
            } else {
                print("Added part: \(order.name)")
            }
        }
        task.resume()
    }
    
    internal func modifyInventory(name: String, newInventory: Int) {
        let url = urlString + "/api/changeinventory"
        var request = URLRequest(url: URL(string: url)!)
        let data = "name=\(name)&inventory=\(newInventory)"
        request.httpMethod = "POST"
        request.httpBody = data.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                print("Error modifying inventory: " + (error?.localizedDescription)!)
            } else {
                print("Modified inventory")
            }
        }
        task.resume()
    }
    
}


