//
//  StoryModel.swift
//  StoryShareApp
//
//  Created by Robert Sato on 4/29/20.
//  Copyright © 2020 Robert Sato. All rights reserved.
//

class StoryModel{
    
    var author: String?
    var occupation: String?
    var story: String?
    var likes: Int?
    
    init(author:String?, occupation:String?, story:String?, likes:Int?){
        self.author = author
        self.occupation = occupation
        self.story = story
        self.likes = likes
    }
    
}
