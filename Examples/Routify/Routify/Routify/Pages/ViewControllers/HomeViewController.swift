//
//  ViewController.swift
//  Routify
//
//  Created by iosdev on 12.4.2021.
//

import Foundation
import UIKit
import MapKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    var allRoutes: [Route] = []
    
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var btnUpload: UIButton!
    
    @objc func logout() {
        let response = Api.logout()
        
        if(response == nil)
        {
            self.performSegue(withIdentifier: "Main", sender: self)
        } else {
            self.view.showToast(toastMessage: response!)
        }
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        print(NSStringFromClass(type(of: self)))
        
        
        if Api.currentUser() != nil {
            
            /// Add back navigation button
            let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
            self.navigationItem.rightBarButtonItem = logoutButton
            
            /// Show upload new item button
            btnUpload.isHidden = false
        }
        
        /// Request posts
        var newRoutes: [Route] = []
        
        Api.searchPost(category: nil, title: nil, skip: 0, take: nil, order: "Date", descending: true) { (data, err) in print(err?.localizedDescription ?? "something went right")
            if data != nil {
                for post in data! {
                    let postData = post.data()
                    let owner = postData["Owner"]
                    let title = postData["Title"]
                    let desc = postData["Desc"]
                    let dist = postData["Distance"]
                    let cords = postData["Cords"]
                    
                    let route = Route.init(uploader: owner as? String, title: title as? String, description: desc as? String, distance: dist as? Int, coordinates: cords as? [GeoPoint])
                    newRoutes.append(route)
                }
            }
            self.allRoutes = newRoutes
            self.tableList.delegate = self as UITableViewDelegate
            self.tableList.dataSource = self as UITableViewDataSource
            self.tableList.reloadData()
            self.tableList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            let vc = segue.destination as? DetailViewController
            
            let cell = sender as! RouteViewCell
            let post = allRoutes[cell.tag]
            
            vc?.uploader = post.uploader ?? ""
            vc?.distance = post.distance ?? 0
            vc?.coordinates = post.coordinates ?? []
            vc?.postDescription = post.description ?? ""
            vc?.postTitle = post.title ?? ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRoutes.count
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    var dist: String = ""
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RouteViewCell", for: indexPath) as? RouteViewCell
        {
            cell.title.text = allRoutes[indexPath.row].title
            if allRoutes[indexPath.row].distance ?? 0 > 1000 {
                dist = String(Double(allRoutes[indexPath.row].distance ?? 0) / 1000) + "km"
            }
            else {
                dist = String(allRoutes[indexPath.row].distance ?? 0) + "m"
            }
            cell.distance.text = dist
            cell.map.delegate = self as MKMapViewDelegate
            
            let coordinates = allRoutes[indexPath.row].coordinates ?? []
            cell.map.removeOverlays(cell.map.overlays)
            cell.map.addOverlay((cordsToPoly(cords: coordinates)), level: MKOverlayLevel.aboveRoads)
            
            if let first = cell.map.overlays.first {
                let rect = cell.map.overlays.reduce(first.boundingMapRect, {$0.union($1.boundingMapRect)})
                cell.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
                
                cell.tag = indexPath.row
                return cell
               }
        }
        return UITableViewCell()
    }
}
