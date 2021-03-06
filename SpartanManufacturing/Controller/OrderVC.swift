//
//  SecondViewController.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

class OrderVC: UITableViewController, UIPopoverPresentationControllerDelegate, AddOrderDelegate, ModifyStatusDelegate {

    // MARK: - Properties
    
    internal var orders = [Order]()
    private let apiHelper = APIHelper()
    
    // MARK: - iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        refresh()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let order = orders[indexPath.row]
        cell.textLabel?.text = order.name
        cell.detailTextLabel?.text = "N: \(order.number!) | C: \(order.status!) | D: \(order.date!)"
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteOrderAtRow(row: indexPath.row)
        }
        delete.backgroundColor = UIColor.red
        let complete = UITableViewRowAction(style: .default, title: "Edit Status") { (action, indexPath) in
            self.modifyStatusAtIndex(row: indexPath.row)
        }
        complete.backgroundColor = UIColor.blue
        return [delete, complete]
    }
    
    internal func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: - Usage
    
    @objc internal func refresh() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiHelper.getAllOrders() { orders in
                if let o = orders {
                    self.orders = o
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([0], with: .automatic)
                        self.refreshControl!.endRefreshing()
                    }
                }
            }
        }
    }
    
    private func modifyStatusAtIndex(row: Int) {        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "ModifyStatus") as! ModifyStatusVC
        popoverContent.delegate = self
        popoverContent.orderNumber = orders[row].id
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 500, height: 100)
        popover?.delegate = self
        popover?.sourceView = tableView.cellForRow(at: IndexPath(row: row, section: 0))
        self.present(nav, animated: true, completion: nil)
    }
    
    private func deleteOrderAtRow(row: Int) {
        let order = orders[row]
        apiHelper.deleteOrder(withOrderID: order.id)
        orders.remove(at: row)
        tableView.reloadSections([0], with: .automatic)
    }
    
    @objc private func addOrder() {
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "AddOrder") as! AddOrderVC
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 500, height: 272)
        popover?.delegate = self
        popover?.barButtonItem = navigationItem.rightBarButtonItem
        //popover?.sourceRect = navigationItem.rightBarButtonItem
        
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    
    func didAddOrder() {
        refresh()
    }
    
    func didModifyStatus() {
        refresh()
    }
    
    // MARK: - Set up
    
    private func setUp() {
        // General Setup
        title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrder))
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
    }

}

