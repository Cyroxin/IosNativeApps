//
//  ParlamentMemberList.swift
//  ParlamentMembers
//
//  Created by cyroxin on 31.3.2021.
//  Copyright © 2021 cyroxin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ParlamentMemberList: UITableViewController
{
    var fetchedMembersList : NSFetchedResultsController<NSFetchRequestResult>?
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedMembersList!.sections?.count ?? 1 // count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedMembersList!.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParlamentMemberCell", for: indexPath) as! ParlamentMemberCell
        
        
        guard let data = (self.fetchedMembersList?.object(at: indexPath) as! NSParlamentMember) as NSParlamentMember? else {
            fatalError("members not found from fetched results")
        }
        
        if let url = URL(string: data.pictureUrl) {
            if let cachedimg = data.picture {
                cell.imagePicture.image = UIImage(data: cachedimg)
            }
            else if let img = try? Data(contentsOf: url, options: .uncached)
            {
                data.picture = img
                cell.imagePicture.image = UIImage(data: img)
            }
        }
        
        cell.labelMinister.text = !data.minister ? "" : "Minister"
        cell.labelName.text = data.firstname + " " + data.lastname
        cell.labelParty.text = data.party.uppercased()
        cell.labelSeat.text = String(data.seatNumber)
        
        
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        print("controllerDidChangeContent")
        tableView.reloadData()
    }
}
