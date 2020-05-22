//
//  UserProfileViewController.swift
//  StoryShareApp
//
//  Created by Robert Sato on 5/6/20.
//  Copyright © 2020 Robert Sato. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class UserProfileViewController: UIViewController {

    @IBOutlet weak var storiesCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        storiesCountLabel.text = "10"
        likesCountLabel.text = "4"
        
        let (storiesCount, likeCount) = setCounts()
        // set the labels
        print("setting storiesCountLabel to count = '\(storiesCount)")
        print("setting likesCountLabel to count = '\(likeCount)")
        storiesCountLabel.text = String(storiesCount)
        likesCountLabel.text = String(likeCount)
        print("set storiesCountLabel to count = '\(storiesCount)")
        print("set likesCountLabel to count = '\(likeCount)")
        
    }
    
    func setCounts() -> (String, String){
        // initialize firebase variables
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        print("Retrieving stories with userID: '\(userID)'")
        
        // declare variables for like count and stories count
        var likeCount = 0
        var storiesCount = 0
        
        // get all stories with correct uid
        db.collection("stories").whereField("uid", isEqualTo: userID)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting stories documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        DispatchQueue.main.async {
                            let storyData = document.data()
                            
                            // extract the info we want from the dictionary
                            likeCount += storyData["likes"] as! Int
                            storiesCount += 1
                            print("reading documents!")
                            print("This story has '\(storyData["likes"])' likes!")
                            print("storiesCount = '\(storiesCount)'")
                        }
                    }
                }
        }
        print("likeCount = '\(likeCount)'")
        print("storiesCount = '\(storiesCount)'")
        return (String(storiesCount), String(likeCount))
    }


}
