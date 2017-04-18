//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Melissa  Garrett on 3/10/17.
//  Copyright © 2017 MelissaGarrett. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var numInPartyLabel: UILabel!
    
    var tipSelection: Int = 0
    var numInParty: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
        segControl.selectedSegmentIndex = tipSelection
        stepper.value = Double(numInParty)
        numInPartyLabel.text = "\(numInParty) in party"
    }
    
    @IBAction func segControlChanged(_ sender: Any) {
        tipSelection = segControl.selectedSegmentIndex
    }
        
    @IBAction func stepperChanged(_ sender: UIStepper) {
        numInParty = Int(sender.value)
        numInPartyLabel.text = "\(numInParty) in party"
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
            
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
