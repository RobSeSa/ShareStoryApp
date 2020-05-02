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
        cell.likesLabel.text = String(story.likes!) + " Likes"
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // attach observer to firebase reference
        let db = Firestore.firestore()
        db.collection("stories").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                self.storiesList.removeAll() // clear the list of stories
                
                for document in snapshot!.documents { // iterate across each story in the "stories" collection
                    let documentData = document.data()
                    
                    let author = documentData["author"]!
                    let occupation = documentData["occupation"]!
                    let text = documentData["text"]!
                    let likes = documentData["likes"]!
                    
                    let storyObject = StoryModel(author: (author as! String), occupation: (occupation as! String), story: (text as! String), likes: (likes as! Int))
                    
                    self.storiesList.append(storyObject) // store all stories in the list
                }
                
                self.storiesTable.reloadData()
            }
        }
        
        
        
        
    }
    

    

}
