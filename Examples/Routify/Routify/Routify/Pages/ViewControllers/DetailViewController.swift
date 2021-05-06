//
//  ViewController.swift
//  Routify
//
//  Created by iosdev on 12.4.2021.
//

import UIKit
import Firebase
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    var distance: Int = 0
    var uploader = "~John"
    var postTitle = "Title"
    var postDescription = "Description"
    var coordinates : [GeoPoint] = [GeoPoint(latitude: 60.197468,longitude: 24.928335),GeoPoint(latitude: 60.205623,longitude: 24.935941)]
    
    @IBOutlet weak private var map: MKMapView!
    @IBOutlet weak private var labelDistance: UILabel!
    @IBOutlet weak private var labelDuration: UILabel!
    @IBOutlet weak private var labelUploader: UILabel!
    @IBOutlet weak private var labelTitle: UINavigationItem!
    @IBOutlet weak private var labelDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresh()
        print(NSStringFromClass(type(of: self)))
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func refresh() {
        labelUploader.text = uploader
        labelTitle.title = postTitle
        labelDescription.text = postDescription
        refreshmap()
        refreshinfocards()
    }
        func refreshinfocards()
    {
        let duration = TimeInterval(Double(distance) / 1.4)
            if distance > 1000{
                labelDistance.text = String(Double(distance) / 1000) + "km"
            }
            else {
                labelDistance.text = String(distance) + "m"
            }
        labelDuration.text = duration.format(using: [.calendar, .hour, .minute, .second])
    }
    
    func refreshmap() {
        map.delegate = self
        map.addOverlay((cordsToPoly(cords: coordinates)), level: MKOverlayLevel.aboveRoads)
        if let first = map.overlays.first {
            let rect = map.overlays.reduce(first.boundingMapRect, {$0.union($1.boundingMapRect)})
            map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
           }
    }
}
