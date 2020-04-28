//
//  HomeViewController.swift
//  StoryShareApp
//
//  Created by Robert Sato on 4/16/20.
//  Copyright © 2020 Robert Sato. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        
        print("getting documents")
        db.collection("stories").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    print(documentData)
                }
            }
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
