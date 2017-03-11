//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Melissa  Garrett on 3/10/17.
//  Copyright © 2017 MelissaGarrett. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var tipSelection: Int!

    @IBOutlet weak var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        tipSelection = defaults.integer(forKey: "TipSelected")
        
        segControl.selectedSegmentIndex = tipSelection
    }
    
    @IBAction func segControlChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        tipSelection = segControl.selectedSegmentIndex
        defaults.set(tipSelection, forKey: "TipSelected")
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
