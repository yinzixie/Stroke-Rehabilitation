//
//  PatientTableCellViewTableViewCell.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 5/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class PatientTableCellView: UITableViewCell {

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var firstnameLabel: UILabel!
    @IBOutlet var givennameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
