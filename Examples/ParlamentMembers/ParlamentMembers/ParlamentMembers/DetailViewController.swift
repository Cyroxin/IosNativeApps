//
//  DetailViewController.swift
//  ParlamentMembers
//
//  Created by cyroxin on 1.4.2021.
//  Copyright © 2021 cyroxin. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var viewImage: UIImageView!
    
    var imageData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do ant additional setup after loading the view.
        viewImage.image = UIImage(data: imageData!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be reacreated.
    }
}
