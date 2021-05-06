//
//  Api.swift
//  Routify
//
//  Created by iosdev on 13.4.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


final class Api {
    
    
    /* --------------- */
    /* USER MANAGEMENT */
    /* --------------- */
    
    // Returns currently logged on user, nil if not logged in
    static func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    // Registers user with the server
    // Does not set the user's displayName, must be set manually after registration.
    static func register(email : String, password : String, onCompletion: ((AuthDataResult?,Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: onCompletion)
    }
    
    // Logs the user into the server
    static func login(email: String, password: String, onCompletion: ((AuthDataResult?,Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: onCompletion)
    }
    
    // Logs user out of the server
    // Returns error message, nil if succesfull.
    static func logout() -> String? {
        if Auth.auth().currentUser != nil
        {
            do {
                try Auth.auth().signOut()
                return nil
            }
            catch {
                return error.localizedDescription
            }
        }
        else {
            return "User is not logged in"
            
        }
    }
    
    /* --------------- */
    /* POST MANAGEMENT */
    /* --------------- */
    
    // Creates post with specific data
    // REQUIREMENTS: Must be logged in
    static func createPost(title : String, desc : String, cords : [GeoPoint], distance : Int, onCompletion: @escaping (Error?) -> Void)
    {
        
        // Create global post
        let post = Firestore.firestore().collection("posts").document()
        
        post.setData(["Title": title, "Desc": desc, "Cords": cords, "Distance" : distance, "Date": Date(), "Owner": currentUser()?.displayName ?? "Anonymous"])
        {(err) in
            
            if (err != nil)
            {
                onCompletion(err)
                return
            }
            
            // Add created post to user's own list as well.
            Firestore.firestore().collection("users").document(currentUser()?.uid ?? "visitor").setData(
                ["Posts": FieldValue.arrayUnion([post])], merge: true, completion: onCompletion
            )
        }
        
        
    }
    
    // Modifies post with specific data
    // REQUIREMENTS: Must be logged in & be the owner of the post
    static func updatePost(post: DocumentReference, title : String, desc : String, cords : [GeoPoint], onCompletion: @escaping (Error?) -> Void)
    {
        post.setData(["Title": title, "Desc": desc, "Cords": cords, "Date": Date(), "Owner": currentUser() ?? "Visitor"], completion: onCompletion)
    }
    
    static func updatePost(postId: String, title : String, desc : String, cords : [GeoPoint], onCompletion: @escaping (Error?) -> Void)
    {
        let doc = Firestore.firestore().collection("posts").document(postId)
        return updatePost(post: doc, title: title, desc: desc, cords: cords, onCompletion: onCompletion)
    }
    
    // Deletes post
    static func deletePost(post: DocumentReference, onCompletion: @escaping (Error?) -> Void)
    {
        post.delete(completion: onCompletion)
        
        // Delete post from user's own list as well.
        Firestore.firestore().collection("users").document((currentUser()?.uid)!).updateData(["Posts": FieldValue.arrayRemove([post.self])])
    }
    
    static func deletePost(postId: String, onCompletion: @escaping (Error?) -> Void)
    {
        let doc = Firestore.firestore().collection("posts").document(postId)
        return deletePost(post: doc, onCompletion: onCompletion)
    }
    
    // Searches for post using optional parameters
    // Returns array of posts or error using delegate
    static func searchPost(category: String? = nil, title: String? = nil, skip: Int = 0, take: Int? = nil, order : String? = nil, descending: Bool = true, onCompletion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void)
    {
        let posts = Firestore.firestore().collection("posts")
        let filter = category != nil ? posts.whereField("Category", isEqualTo: category as Any) : posts
        let search = title != nil ? filter.whereField("Title", isEqualTo: title as Any) : filter
        
        let skipper = skip != 0 ? search.start(at: [skip]) : search
        let limiter = take != nil ? skipper.limit(to: take!) : skipper
        
        
        let orderer = order != nil ? limiter.order(by: order!, descending: descending) : limiter
        
        
        orderer.getDocuments { (querySnapshot :QuerySnapshot?, err: Error?) in
            if(querySnapshot == nil)
            {
                onCompletion(nil, err)
            }
            else
            {
                onCompletion(querySnapshot!.documents, err)
            }
        }
        
    }
    
    // Returns user posts using delegate (posts, error)
    static func getUserPosts(user : User, useCache : Bool = true, onCompletion: @escaping ([DocumentReference], Error?) -> Void)
    {
        let docRef = Firestore.firestore().collection("users").document(user.uid)
        
        docRef.getDocument(source: useCache ? .cache : .server) { (document, error) in
            if let document = document {
                let data = document.data()
                let posts = data?["Posts"] as? [DocumentReference]
                
                onCompletion(posts ?? [],error)
            }
        }
        
    }
    
    // Returns current user's posts using delegate (posts, error)
    static func getCurrentUserPosts(useCache : Bool = true, onCompletion: @escaping ([DocumentReference], Error?) -> Void) {
        if let user = currentUser() {
            getUserPosts(user: user, useCache: useCache, onCompletion: onCompletion)
        }
    }
}
