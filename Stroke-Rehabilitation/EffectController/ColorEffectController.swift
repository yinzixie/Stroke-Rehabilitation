//
//  ColorEffectController.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 29/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation
import UIKit

public class ColorEffectController {
    //定义渐变的颜色（7种彩虹色）
    static let gradientColors = [UIColor.red.cgColor,
                                 UIColor.magenta.cgColor,
                          UIColor.orange.cgColor,
                          UIColor.yellow.cgColor,
                          UIColor.green.cgColor,
                          UIColor.cyan.cgColor,
                          UIColor.blue.cgColor,
                          UIColor.purple.cgColor]
    //共三组渐变色
    static let colorsSet = [
        [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor],
        [UIColor.yellow.cgColor, UIColor.orange.cgColor,UIColor.white.cgColor],
        [UIColor.cyan.cgColor, UIColor.green.cgColor,UIColor.white.cgColor],
        [UIColor.magenta.cgColor, UIColor.blue.cgColor,UIColor.white.cgColor],
    ]
}
