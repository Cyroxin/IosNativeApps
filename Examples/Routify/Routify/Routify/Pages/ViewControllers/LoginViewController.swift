//
//  ViewController.swift
//  Routify
//
//  Created by iosdev on 12.4.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    
    @IBAction func onProceed() {
        if fieldEmail.text != nil && fieldPassword.text != nil {
            Api.login(email: fieldEmail.text!, password: fieldPassword.text!) {(data, err) in
                
                
                if let error = err {
                    print("error: " + error.localizedDescription)
                    self.view.showToast(toastMessage: error.localizedDescription)
                } else {
                    print(Api.currentUser()?.displayName ?? "default value")
                    self.performSegue(withIdentifier: "Home", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(NSStringFromClass(type(of: self)))
    }
    
    
}

