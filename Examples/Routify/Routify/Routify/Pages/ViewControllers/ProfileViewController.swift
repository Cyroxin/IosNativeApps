//
//  ViewController.swift
//  Routify
//
//  Created by iosdev on 12.4.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(NSStringFromClass(type(of: self)))
    }
    
    @IBAction func onLogout() {
        guard let logout = Api.logout() else {
            self.performSegue(withIdentifier: "Main", sender: self)
            return
        }
        
        self.view.showToast(toastMessage: logout)
        
    }
    
    
}

