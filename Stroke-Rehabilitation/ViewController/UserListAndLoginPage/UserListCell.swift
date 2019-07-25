//
//  UserListCell.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 24/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

protocol TellLoginPageSelectUser {
    func selectUser(id:String)
}

class UserListCell: UITableViewCell {

    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hintLabel: UILabel!
  
    @IBOutlet weak var selectedHintImage: UIImageView!
    
    var tellLoginPageSelectUser:TellLoginPageSelectUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        tellLoginPageSelectUser?.selectUser(id: IDLabel.text!)
    }
    
    
}


