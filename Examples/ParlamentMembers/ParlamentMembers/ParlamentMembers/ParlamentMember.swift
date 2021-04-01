//
//  ParlamentMember.swift
//  ParlamentMembers
//
//  Created by cyroxin on 31.3.2021.
//  Copyright © 2021 cyroxin. All rights reserved.
//

import Foundation
import CoreData


struct ParlamentMember : Codable {
    var seatNumber : Int
    var firstname : String
    var lastname : String
    var party : String
    var minister : Bool
    var pictureUrl : String
    
    
    private static func download(_ link : String)->Data?{
        guard let url = URL(string: link) else {
            return nil
        }
        
        guard let data : Data = try? Data(contentsOf: url)
            else {
            print("[ERROR] There is an unspecified error with the connection")
            return nil
            }
            
            return data
        
    }

    
    static func loadParlament() -> [ParlamentMember]?
    {
        let apibaseurl = "https://avoindata.eduskunta.fi/"
        let apiurl = "https://avoindata.eduskunta.fi/api/v1/seating/"
        
        if let data = download(apiurl)
        {
            //let json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String:Any])
            do {
                var members = try JSONDecoder().decode([ParlamentMember].self, from: data)
                
                for i in 0...members.count-1
                {
                    members[i].pictureUrl = apibaseurl + members[i].pictureUrl
                }
                
                members.sort{ $0.lastname < $1.lastname}
                
                return members
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
    }
}

class NSParlamentMember : NSManagedObject
{
    @NSManaged var seatNumber : Int
    @NSManaged var firstname : String
    @NSManaged var lastname : String
    @NSManaged var party : String
    @NSManaged var minister : Bool
    @NSManaged var pictureUrl : String
    var picture : Data? // Image Cache
    
    
    class func getOrCreate(seatNumber : Int, context: NSManagedObjectContext) throws -> NSParlamentMember?
    {
        let request: NSFetchRequest<NSFetchRequestResult> = NSParlamentMember.fetchRequest()
        
        request.predicate = NSPredicate(format: "seatNumber == \(seatNumber)")
        
        // Create a unique object with the format
        do {
            // If an unique object exists, give that instead of creating a new one
            let matchingItems = try context.fetch(request)
            if matchingItems.count == 1 {
                return (matchingItems[0] as! NSParlamentMember)
            } else if(matchingItems.count == 0) {
                let newItem = NSParlamentMember(context: context)
                return newItem
            } else {
                print("There were more unique managed items than expected")
                return (matchingItems[0] as! NSParlamentMember) // This shouldn't ever hit.
            }
        } catch {
            throw error
        }
    }
    
    func load(member : ParlamentMember)
    {
        self.seatNumber = member.seatNumber
        self.firstname = member.firstname
        self.lastname = member.lastname
        self.party = member.party
        self.minister = member.minister
        self.pictureUrl = member.pictureUrl
    }
}


