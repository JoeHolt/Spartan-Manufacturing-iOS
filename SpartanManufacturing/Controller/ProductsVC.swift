//
//  FirstViewController.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/23/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

class ProductsVC: UITableViewController {

    private let apiHelper = APIHelper()
    private var products = [Product]()
    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    @objc internal func edit() {
        print("Modify")
    }
    
    private func setUp() {
        title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Modify", style: .plain, target: self, action: #selector(edit))
        refresh()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        //tableView.addSubview(refreshCon)
    }

}

