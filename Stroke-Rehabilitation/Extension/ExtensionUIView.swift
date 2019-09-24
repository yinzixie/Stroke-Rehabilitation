//
//  ExtensionUIView.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 24/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func cardView() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
    }
}
