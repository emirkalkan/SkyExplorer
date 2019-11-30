//
//  SettingsViewController.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 23.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin

class SettingsViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let loginButton = FBLoginButton(permissions: [ .publicProfile ])
        //loginButton.center = loginButton.center
        loginButton.frame = CGRect(x: 38, y: 600, width: 300, height: 30)
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        if let accesToken = AccessToken.current {
            print(accesToken)
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error")
        }
        
        performSegue(withIdentifier: "toBackSegue", sender: nil)
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("User logged in")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User log out")
        performSegue(withIdentifier: "toBackSegue", sender: nil)
    }
}
