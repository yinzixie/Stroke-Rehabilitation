//
//  AccountCell.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 29/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit
//import
class AccountCell: FoldingCell {
    
    var patient:Patient!
    var parentView:UIViewController?
    
    @IBOutlet var sortNumberLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var dayTimeLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    
    @IBOutlet var patientIDNumberLabel: UILabel!
    
    @IBOutlet var detailAgeLabel: UILabel!
    @IBOutlet var detailLevelLabel: UILabel!
    @IBOutlet var detailGenderLabel: UILabel!
    
    @IBOutlet var fullNameLabel: UILabel!
    
    @IBOutlet var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setAccountCell(patient:Patient) {
        let date = DateInfo.dateStringToDate(patient.DateString!)
        dateTimeLabel.text = DateInfo.dateToDateString(date, dateFormat: "yyyy/MM/dd")
        dayTimeLabel.text = DateInfo.dateToDateString(date, dateFormat: "HH:mm")
        ageLabel.text = String(patient.Age!)
        genderLabel.text = patient.Gender
        levelLabel.text = patient.LevelDescription
        firstNameLabel.text = patient.Firstname
        lastNameLabel.text = patient.Givenname
        patientIDNumberLabel.text = patient.ID
        detailAgeLabel.text = String(patient.Age!)
        detailGenderLabel.text = patient.Gender
        detailLevelLabel.text = patient.LevelDescription
        
        fullNameLabel.text = patient.Firstname! + " " + patient.Givenname!
    }
}
