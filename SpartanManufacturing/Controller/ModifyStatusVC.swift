//
//  ModifyStatusVC.swift
//  SpartanManufacturing
//
//  Created by Joe Holt on 12/28/17.
//  Copyright © 2017 Joe Holt. All rights reserved.
//

import UIKit

protocol ModifyStatusDelegate {
    func didModifyStatus()
}

class ModifyStatusVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var picker: UIPickerView!
    
    internal var orderNumber: Int!
    internal var delegate: ModifyStatusDelegate!
    private var data: [String] = [String]()
    private var currentSelection: String = "Pending start"

    // MARK: - iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelection = data[row]
    }
    
    // MARK: - User
    
    @objc private func modifyInventory() {
        APIHelper().modifyStatus(status: currentSelection, id: orderNumber)
        delegate.didModifyStatus()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Other
    
    private func setUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Modify", style: .done, target: self, action: #selector(modifyInventory))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel))
        
        picker.delegate = self
        picker.dataSource = self
        
        DispatchQueue.global(qos: .userInitiated).async {
            APIHelper().getAllStatusCodes { (data) in
                if let d = data {
                    self.data = d
                    DispatchQueue.main.async {
                        self.picker.reloadAllComponents()
                    }
                }
            }
        }
    }
    
}
