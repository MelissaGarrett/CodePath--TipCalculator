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
    @IBOutlet weak var amountPerPersonLabel: UILabel!    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var billModel: BillModel!
    
    let tipPercentages = [0.10, 0.15, 0.20, 0.25]
    var tipPercent: Double!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "TIP CALCULATOR"
        amountPerPersonLabel.isHidden = true

        billModel = BillModel()
        var amt: Double!

        
        if defaults.bool(forKey: "HasLaunchedOnce") {
            // App has launched before
            if shouldResetState() { // clear Amount field
                amt = 0
            } else {
                amt = defaults.double(forKey: "Amount")
            }
            
            billModel.amount = amt
            tipPercent = tipPercentages[billModel.tipSelection]
            billModel.tip = billModel.amount * tipPercent
            billModel.total = billModel.amount + billModel.tip

            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .decimal
                
            if billModel.amount == 0 {
                amountTextField.text = ""
            } else {
                amountTextField.text = formatter.string(from: billModel.amount as NSNumber)
            }
            
            tipLabel.text = formatter.string(from: billModel.tip as NSNumber)
                
            formatter.numberStyle = .currency
            totalLabel.text = formatter.string(from: billModel.total as NSNumber)
                
            segControl.selectedSegmentIndex = billModel.tipSelection
            
            defaults.set(amt, forKey: "Amount")
            defaults.synchronize()
        } else {
            // First time launching the app
            defaults.set(true, forKey: "HasLaunchedOnce")
            defaults.synchronize()
        }
        
        amountTextField.becomeFirstResponder()
    }
    
    // Update the Tip and Total dynamically as the Amount changes
    // or as the SegControl changes
    @IBAction func amountTextFieldChanged(_ sender: AnyObject) {
        if let amt = amountTextField.text {
            billModel.amount = (amt as NSString).doubleValue
        }
        
        billModel.amount = Double(amountTextField.text!) ?? 0
        tipPercent = tipPercentages[segControl.selectedSegmentIndex]
        billModel.tip = billModel.amount * tipPercent
        billModel.total = billModel.amount + billModel.tip
        billModel.tipSelection = segControl.selectedSegmentIndex

        formatAndUpdateComputedValues()
        
        if amountTextField.text == "" {
            defaults.set(0, forKey: "Amount")
            defaults.synchronize()
        } else {
            defaults.set(billModel.amount, forKey: "Amount")
            defaults.synchronize()
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TipToSettings" {
            let vc = segue.destination as! SettingsViewController
            vc.tipSelection = billModel.tipSelection
            vc.numInParty = billModel.numInParty
        }
    }
    
    // This function is called when the Save button on the
    // SettingsVC is tapped (and automatically dismissed)
    // This is "unwinding a segue"
    @IBAction func saveSettings(segue: UIStoryboardSegue) {
        amountPerPersonLabel.isHidden = true
        
        let vc = segue.source as! SettingsViewController
        let tipSelection = vc.tipSelection
        let numInParty = vc.numInParty
        
        tipPercent = tipPercentages[tipSelection]
        billModel.tip = billModel.amount * tipPercent
        billModel.total = billModel.amount + billModel.tip
        billModel.tipSelection = tipSelection
        billModel.numInParty = numInParty
        
        segControl.selectedSegmentIndex = billModel.tipSelection
        
        formatAndUpdateComputedValues()
    }
    
    func formatAndUpdateComputedValues() {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        tipLabel.text = formatter.string(from: billModel.tip as NSNumber)
        
        formatter.numberStyle = .currency
        totalLabel.text = formatter.string(from: billModel.total as NSNumber)
        
        let amountForEach = billModel.total / Double(billModel.numInParty)
        
        if billModel.numInParty > 1 {
            amountPerPersonLabel.isHidden = false
            
            if let tempString = formatter.string(from: amountForEach as NSNumber) {
                amountPerPersonLabel.text = "\(tempString) Per Person"
            }
        }
    }
    
    // If 10+ minutes have passed since the app was last terminated,
    // return True which will reset the Amount field.
    // Otherwise, return False to load the Amount from UserDefaults.
    func shouldResetState() -> Bool {
        if let timeAppLastExited = defaults.object(forKey: "AppLastExited") as? Date {
            let currentTime = Date()
            let calendar = NSCalendar.current
            
            let appDateComponent = calendar.component(.minute, from: timeAppLastExited as Date)
            let currentDateComponent = calendar.component(.minute, from: currentTime as Date)
            
            if currentDateComponent - appDateComponent >= 10 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}

