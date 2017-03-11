//
//  ViewController.swift
//  TipCalculator
//
//  Created by Melissa  Garrett on 3/10/17.
//  Copyright © 2017 MelissaGarrett. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    let tipPercentages = [0.10, 0.15, 0.20, 0.25]
    
    var amount: Double!
    var tipPercent: Double!
    var tip: Double!
    var total: Double!
    
    var tipSelection: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "TIP CALCULATOR"
        
        amountTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateValues()
    }
    
    // Update the Tip and Total dynamically as the Amount changes
    @IBAction func amountTextFieldChanged(_ sender: AnyObject) {
        amount = Double(amountTextField.text!) ?? 0
        tipPercent = tipPercentages[segControl.selectedSegmentIndex]
        tip = amount * tipPercent
        total = amount + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        let defaults = UserDefaults.standard
        tipSelection = segControl.selectedSegmentIndex
        defaults.set(tipSelection, forKey: "TipSelected")
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Update the Tip, Total, and Percentage after the user updates
    // the default in the Settings VC
    func updateValues() {
        let defaults = UserDefaults.standard
        tipSelection = defaults.integer(forKey: "TipSelected")
        
        amount = amount ?? 0
        tipPercent = tipPercentages[tipSelection]
        tip = amount * tipPercent
        total = amount + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        segControl.selectedSegmentIndex = tipSelection
    }
}

