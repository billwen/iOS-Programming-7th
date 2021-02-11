//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Gang Wen on 2021-02-11.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var _nameField: UITextField!
    
    @IBOutlet var _snField: UITextField!
    
    @IBOutlet var _valueField: UITextField!
    
    @IBOutlet var _dateField: UILabel!
    
    var _item: Item! {
        didSet {
            navigationItem.title = _item.name
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self._nameField.text = self._item.name
        self._snField.text = self._item.serialNumber
        /*
        self._valueField.text = "\(self._item.valueInDollars)"
        self._dateField.text = "\(self._item.dateCreated)"
 */
        self._valueField.text = numberFormatter.string(from: NSNumber(value: self._item.valueInDollars))
        self._dateField.text = dateFormatter.string(from: self._item.dateCreated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first reponder
        view.endEditing(true)
        
        // Save changes to item
        self._item.name = self._nameField.text ?? " "
        self._item.serialNumber = self._snField.text ?? " "
        
        if let valueText = self._valueField.text,
           let value = numberFormatter.number(from: valueText) {
            self._item.valueInDollars = value.intValue
        } else {
            self._item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("background tapped")
        view.endEditing(true)
    }
}
