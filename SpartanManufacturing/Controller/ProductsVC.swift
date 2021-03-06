//
//  FirstViewController.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

class ProductsVC: UITableViewController {

    // MARK: - Properties
    
    private let apiHelper = APIHelper()
    private var products = [Product]()
    
    // MARK: - iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let product = products[indexPath.row]
        cell.textLabel?.text = product.name!
        cell.detailTextLabel?.text = "Stock: \(product.stock!) | Pending: \(product.pending!) | Net: \(product.stock! - product.pending!)"
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Edit Stock") { (action, indexPath) in
            self.modifyInventory(product: self.products[indexPath.row])
        }
        action.backgroundColor = UIColor.blue
        let action2 = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            self.deleteProduct(product: self.products[indexPath.row], indexPath: indexPath)
        }
        action2.backgroundColor = UIColor.red
        
        return [action2, action]
    }
    
    // MARK: - Usage
    
    private func modifyInventory(product: Product) {
        let alert = UIAlertController(title: product.name, message: "Modify Product Stock", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "\(product.stock!)"
        }
        let add = UIAlertAction(title: "Modify", style: .default) { (action) in
            let textField = alert.textFields![0] as UITextField
            if let num = Int(textField.text!) {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.apiHelper.modifyInventory(name: product.name, newInventory: num)
                }
                DispatchQueue.main.async {
                    self.refresh()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteProduct(product: Product, indexPath: IndexPath) {
        apiHelper.deleteProduct(withName: product.name)
        products.remove(at: indexPath.row)
        refresh()
    }
    
    @objc private func addNewProduct() {
        let alert = UIAlertController(title: "Add Product", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Stock"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let name = alert.textFields![0].text ?? "Error"
            let stock = Int(alert.textFields![0].text!) ?? 10
            self.apiHelper.addProduct(name: name, stock: stock) {
                self.refresh()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc internal func refresh() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiHelper.getAllProducts() { products in
                if let products = products {
                    self.products = products
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([0], with: .automatic)
                        self.refreshControl!.endRefreshing()
                    }
                }
            }
        }
    }
    
    private func setUp() {
        title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
        refresh()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProduct))
    }

}

