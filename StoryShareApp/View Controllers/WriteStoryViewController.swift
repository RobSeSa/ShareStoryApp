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
    
    @IBAction func SaveStoryTapped(_ sender: Any) {
        let db = Firestore.firestore()
        /*
        db.collection("stories").addDocument(data: ["text" : StoryTextView.text!]) { (err) in
            if err != nil {
                // There was an error adding the new document
                print("Error creating new document with text:")
                print(self.StoryTextView.text!)
            }
        }
        */
        let myStoryDocument = db.collection("stories").document()
        myStoryDocument.setData(["text":StoryTextView.text!, "id":myStoryDocument.documentID])
        
    }
    
}
