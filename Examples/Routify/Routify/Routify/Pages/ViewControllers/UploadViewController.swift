//
//  ViewController.swift
//  Routify
//
//  Created by iosdev on 12.4.2021.
//

import UIKit
import CoreLocation
import CoreMotion
import MapKit
import Firebase
import FirebaseAuth

class UploadViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    let motionActivityManager = CMMotionActivityManager()
    
    func askLocationPermissions() {
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
    }
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var upload: UIButton!
    @IBOutlet weak var routeTitle: UITextField!
    @IBOutlet weak var routeDescription: UITextView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var buttonChanger = "Start"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Username: ",Api.currentUser()?.displayName ?? "Visitor")
        
        /// Set Visual Indicators
        upload.isEnabled = false
        upload.alpha = CGFloat.init(0.1)
        
        /// Initialize Location Manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        askLocationPermissions()
        
        // Do any additional setup after loading the view.
        print(NSStringFromClass(type(of: self)))
        
        
        /// Show User in Map
        map.showsUserLocation = true
        
        // Set Map Preferences
        map.delegate = self
    }
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    var saveCoordsSwithcer = false
    var startTime: Int64 = 0
    var endTime: Int64 = 0
    var date = NSDate.now
    var userLocations = Array<GeoPoint>()
    var totalDistance = 0.0
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    // Controls and updates the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lastLocation: CLLocation
        let location = locations.last
        let region  = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude), span: MKCoordinateSpan (latitudeDelta: 0.001, longitudeDelta: 0.001))
        self.map.region = region
        let currentLocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        if !userLocations.isEmpty && saveCoordsSwithcer == true{
            let lastLat = userLocations.last?.latitude
            let lastLong = userLocations.last?.longitude
            lastLocation = CLLocation(latitude: lastLat!, longitude: lastLong!)
            let distanceFromLast = currentLocation.distance(from: lastLocation)
            totalDistance += distanceFromLast
            let tempTotal = String(Int(totalDistance.rounded()))
            distanceLabel.text = "Distance recorded: " + tempTotal + "m"
        }
        if saveCoordsSwithcer == true {
            userLocations.append(GeoPoint(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
            map.removeOverlays(map.overlays)
            map.addOverlay((cordsToPoly(cords: userLocations)), level: MKOverlayLevel.aboveRoads)
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if (buttonChanger == "Start") {
            /// Start recording
            totalDistance = 0
            userLocations = []
            upload.isEnabled = false
            upload.alpha = CGFloat.init(0.1)
            startTime = 0
            saveCoordsSwithcer = true
            //TMD.start()
            //print(startTime)
            buttonChanger = "Finish"
            sender.setTitle(buttonChanger, for: .normal)
        } else if(userLocations.count > 0){
            /// End recording
            upload.isEnabled = true
            upload.alpha = CGFloat.init(1)
            //TMD.stop()
            saveCoordsSwithcer = false
            endTime = currentTimeMillis()
            buttonChanger = "Start"
            sender.setTitle(buttonChanger, for: .normal)
        } else {
            print("error: No movement detected or insufficient access")
            self.view.showToast(toastMessage: "No movement detected or insufficient access")
        }
    }
    @IBAction func uploadButton(_ sender: Any) {
        let roundedTotal = Int(totalDistance.rounded())
        Api.createPost(title: routeTitle.text ?? "No title", desc: routeDescription.text ?? "No description", cords: userLocations, distance: roundedTotal) {(err) in
            
            print((err?.localizedDescription) ?? "Post Created!")
            if err == nil {
                self.performSegue(withIdentifier: "Home", sender: self)
            }
            else
            {
                self.view.showToast(toastMessage: err!.localizedDescription)
            }
        }
    }
}
