//
//  ViewController.swift
//  ParlamentMembers
//
//  Created by cyroxin on 31.3.2021.
//  Copyright © 2021 cyroxin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var List: UITableView!
    var ListController = ParlamentMemberList()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MANAGED DATA FETCH
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSParlamentMember.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        ListController.fetchedMembersList = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (AppDelegate.viewContext ), sectionNameKeyPath: "lastname", cacheName: "membersCache")
        
        
        ListController.fetchedMembersList!.delegate = self
        try? ListController.fetchedMembersList?.performFetch()
        
        
        // LINK
        
        List.delegate = ListController as UITableViewDelegate
        List.dataSource = ListController as UITableViewDataSource
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController else {
                return
        }
        
        guard let source : ParlamentMemberCell = sender as? ParlamentMemberCell else {
                return
        }
        
        destination.imageData = source.imagePicture.image?.pngData()
        
        
    }


}

