//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Gang Wen on 2021-02-11.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var _nameField: UITextField!
    
    @IBOutlet var _snField: UITextField!
    
    @IBOutlet var _valueField: UITextField!
    
    @IBOutlet var _dateField: UILabel!
    
    var _item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self._nameField.text = self._item.name
        self._snField.text = self._item.serialNumber
        self._valueField.text = "\(self._item.valueInDollars)"
        self._dateField.text = "\(self._item.dateCreated)"
    }
}
