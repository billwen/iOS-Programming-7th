//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Gang Wen on 2021-02-08.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var _fahrenheitInput: UITextField!

    var _fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsuisLabel()
        }
    }
    
    var _celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = self._fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let _numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("MainViewController loaded it view.")
        updateCelsuisLabel()
    }


    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        /*
        if let text = textField.text, !text.isEmpty {
            celsiusLabel.text = textField.text
        } else {
            celsiusLabel.text = "???"
        }
 */
        if let text = self._fahrenheitInput.text, let value = Double(text) {
            self._fahrenheitValue = Measurement(value: value, unit: UnitTemperature.fahrenheit )
        } else {
            self._fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        _fahrenheitInput.resignFirstResponder()
    }
    
    func updateCelsuisLabel() {
        if let celsiusValue = self._celsiusValue {
//            celsiusLabel.text = "\(celsiusValue)"
            celsiusLabel.text = self._numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*
        print("Current text: \(String(describing: self._fahrenheitInput.text))")
        print("Replacement text: \(string)")
        
        return true
 */
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
}

