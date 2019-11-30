//
//  StartViewController.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 23.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin

class StartViewController: UIViewController, LoginButtonDelegate {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.isSecureTextEntry = true
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
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("User logged in")
        self.performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User log out")
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if  emailText.text != "" && passwordText.text != "" {
                       Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                           if error != nil {
                               self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                           } else {
                               self.performSegue(withIdentifier: "toMainSegue", sender: nil)
                           }
                       
                   }
                   
        } else {
                   makeAlert(titleInput: "Error!", messageInput: "Please fill: \n-E-mail Address\n-Password")
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toMainSegue", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Please fill: \n-Email Address\n-Password")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
         let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
         let okButon = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
         alert.addAction(okButon)
         self.present(alert, animated: true, completion: nil)

    }
    
}
