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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var storiesTable: UITableView!
    
    var storiesList = [StoryModel]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeVCTableViewCell
        
        let story: StoryModel
        story = storiesList[indexPath.row] // get the story of that particular position
        
        cell.authorLabel.text = story.author
        cell.occupationLabel.text = story.occupation
        cell.storyLabel.text = story.story
        cell.likesLabel.text = String(story.likes!)
        
        // code executed when like button pressed in the cell
        cell.likeButtonAction = { (cell) in
            print("The like! button was pressed:")
            print("docID =", story.storyID!)
            self.updateLikes(docID: story.storyID)
        }
        
        // code executed when delete button pressed in the cell
        cell.deleteButtonAction = { (cell) in
            print("The delete button was pressed")
            self.deleteStory(docID: story.storyID)
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
    }
    
    func loadTable() {
        // attach observer to firebase reference
        let db = Firestore.firestore()
        // add descending true bc we append each object to storiesList and order gets reverted
        db.collection("stories").order(by: "likes", descending: true).getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                self.storiesList.removeAll() // clear the list of stories
                
                for document in snapshot!.documents { // iterate across each story in the "stories" collection
                    let documentData = document.data()
                    
                    let author = documentData["author"]!
                    let occupation = documentData["occupation"]!
                    let text = documentData["text"]!
                    let likes = documentData["likes"]!
                    let docID = documentData["id"]!
                    
                    let storyObject = StoryModel(author: (author as! String), occupation: (occupation as! String), story: (text as! String), likes: (likes as! Int), storyID: (docID as! String))
                    
                    self.storiesList.append(storyObject) // store all stories in the list
                }
                
                DispatchQueue.main.async {
                     self.storiesTable.reloadData()
                }
            }
        }
    }
    
    // update the document with given docID with the number of likes
    func updateLikes(docID: String?) {
        let db = Firestore.firestore()
        db.collection("stories").document(docID!).getDocument { (DocumentSnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                DispatchQueue.main.async {
                    print("Getting " + docID! + "'s document snapshot")
                    print("# likes =", DocumentSnapshot!["likes"]!)
                    let likes = DocumentSnapshot!["likes"]
                    db.collection("stories").document(docID!).setData(["likes": (likes! as! Int + 1)], merge:true)
                }
            }
        }
        loadTable()
    }
    
    // receive the docid
    func deleteStory(docID: String?) {
        let db = Firestore.firestore()
        // if document was not written by current user, do not delete
        let userID = Auth.auth().currentUser!.uid
        db.collection("stories").whereField("uid", isEqualTo: userID)
                                .whereField("id", isEqualTo: docID!)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting stories documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let storyData = document.data()
                        // debug output
                        print("Attempting to delete a document")
                        print("docID = \(String(describing: docID))")
                        print("storyData[id] = \(String(describing: storyData["id"]))")
                        print("currentUser!.uid = \(userID)")
                        print("storyData[uid] = \(String(describing: storyData["uid"]))")
                        print("Deleting...")
                        
                        // delete the document
                        db.collection("stories").document(docID!).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                        self.loadTable()
                    }
                }
        }
    }
}
