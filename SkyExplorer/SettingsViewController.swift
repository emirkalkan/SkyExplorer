//
//  SettingsViewController.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 23.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error")
        }
        
        performSegue(withIdentifier: "toBackSegue", sender: nil)
    }
    
}
