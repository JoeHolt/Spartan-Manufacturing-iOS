//
//  SecondViewController.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

class OrderVC: UITableViewController {

    internal var orders = [Order]()
    private let apiHelper = APIHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Orders"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        refresh()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let order = orders[indexPath.row]
        cell.textLabel?.text = order.name
        cell.detailTextLabel?.text = "N: \(order.number!) | C: \(order.completed!) | D: \(order.date!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        let alert = UIAlertController(title: "\(order.name!) Notes", message: order.notes!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(alert, animated: true, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    @objc internal func refresh() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiHelper.getAllOrders() { orders in
                if let o = orders {
                    self.orders = o
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

}

