//
//  RouteViewCell.swift
//  Routify
//
//  Created by iosdev on 4.5.2021.
//

import Foundation
import UIKit
import MapKit

class RouteViewCell: UITableViewCell {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var distance: UILabel!
    
}
