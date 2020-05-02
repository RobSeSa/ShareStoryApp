//
//  WriteStoryViewController.swift
//  StoryShareApp
//
//  Created by Robert Sato on 4/21/20.
//  Copyright © 2020 Robert Sato. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class WriteStoryViewController: UIViewController {

    @IBOutlet weak var StoryTextView: UITextView!
    @IBOutlet weak var SaveStoryButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelTapped(_ sender: Any) {
        print("cancelling story")
    }
    
    @IBAction func SaveStoryTapped(_ sender: Any) {
        
        let userID = Auth.auth().currentUser!.uid
        let text = StoryTextView.text!
        writeNewPost(userID: userID, text: text)
        
    }
    
    func writeNewPost(userID: String, text: String) {
        let db = Firestore.firestore()
        let myStoryDocument = db.collection("stories").document()
        let docID = myStoryDocument.documentID
        
        print("Writing a new post with userID: '\(userID)' and text: '\(text)'")
        
        // select our user from the users collection to get the username and occupation when writing the story
        db.collection("users").whereField("uid", isEqualTo: userID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let userData = document.data()
                        
                        // extract the info we want from the dictionary
                        let username = userData["userName"]
                        let occupation = userData["occupation"]
                        
                        myStoryDocument.setData(["text":text, "date":NSDate(), "author":username ?? "Mystery", "uid":userID, "occupation":occupation ?? "Loving Human", "likes":0, "comments":"Comments...", "id":docID])
                    }
                }
        }
    }
}
