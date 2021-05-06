//
//  ViewController.swift
//  Routify
//
//  Created by iosdev on 12.4.2021.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldNickname: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(NSStringFromClass(type(of: self)))
    }
    
    @IBAction func onProceed() {
        if fieldEmail.text != nil && fieldPassword.text != nil {
            Api.register(email: fieldEmail.text!, password: fieldPassword.text!) {(data, err) in
                
                
                if err == nil {
                    let req = data?.user.createProfileChangeRequest()
                    req?.displayName = self.fieldNickname.text
                    req?.commitChanges(){(err) in
                        self.performSegue(withIdentifier: "Home", sender: self)
                    }
                } else {
                    print("error: " + (err!.localizedDescription))
                    self.view.showToast(toastMessage: err!.localizedDescription)
                }
            }
        }
    }
    
}

