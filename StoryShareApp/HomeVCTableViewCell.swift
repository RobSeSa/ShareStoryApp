//
//  HomeVCTableViewCell.swift
//  StoryShareApp
//
//  Created by Robert Sato on 4/29/20.
//  Copyright © 2020 Robert Sato. All rights reserved.
//

import UIKit

class HomeVCTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
