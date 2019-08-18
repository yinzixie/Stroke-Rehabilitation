//
//  PeripheralListCell.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 18/8/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class PeripheralListCell: UITableViewCell {
    @IBOutlet weak var peripheralLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
