//
//  AddItemController.swift
//  ShoppingList
//
//  Created by Kelby Mittan on 7/15/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func didAddItem(item: Item)
}

class AddItemController: UIViewController {
    
    @IBOutlet var itemNameTextField: UITextField!
    @IBOutlet var itemPriceTextField: UITextField!
    @IBOutlet var categoryPicker: UIPickerView!
    
    private var categories = Category.allCases
    private var category = Category.running
    public var delegate: AddItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let name = itemNameTextField.text, name != "", let price = itemPriceTextField.text, price != "", let priceDouble = Double(price) else {
            showAlert(title: "Missing Fields", message: "Please enter all fields and valid price")
            return
        }
        let item = Item(name: name, price: priceDouble, category: category)
        delegate?.didAddItem(item: item)
        navigationController?.popViewController(animated: true)
    }
}

extension AddItemController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row]
    }
    
}
extension AddItemController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
    }
}


extension UIViewController {
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
