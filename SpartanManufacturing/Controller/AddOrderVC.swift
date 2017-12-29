//
//  AddOrderVC.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/27/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

protocol AddOrderDelegate {
    func didAddOrder()
}

class AddOrderVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var namePicker: UIPickerView!
    @IBOutlet weak var orderNumberField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    internal var delegate: AddOrderDelegate!
    private let helper = APIHelper()
    private var pickerData = [String]()
    private var pickerSelected: String? = "Aluminium Water Bottle Large"
    
    // MARK: - iOS

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelected = pickerData[row]
    }
    
    // MARK: - Usage
    
    @objc private func addOrder() {
        if pickerSelected == nil {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let name = pickerSelected!
        let notes = self.notesField.text ?? ""
        let orderNumber = Int(self.orderNumberField.text!) ?? nil
        let order = Order(name: name, number: orderNumber, status: "", date: nil, notes: notes, id: 0)
        helper.addOrder(order: order) {
            self.delegate.didAddOrder()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Set up
    
    private func setUp() {
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addOrder))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close))
        self.namePicker.dataSource = self
        self.namePicker.delegate = self
        DispatchQueue.global(qos: .userInitiated).async {
            self.helper.getAllProducts() { products in
                for p in products! {
                    self.pickerData.append(p.name)
                }
                DispatchQueue.main.async {
                    self.namePicker.reloadAllComponents()
                }
            }
        }
    }

}
