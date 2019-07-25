//
//  TimerFormattor.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 23/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation

public class TimerFormattor{
    static let formatter = DateComponentsFormatter()
    
    init(){
        TimerFormattor.formatter.allowedUnits = [.minute, .second]//formats the TimeInterval datatype to look like mm:ss
        TimerFormattor.formatter.zeroFormattingBehavior = .pad
    }
}
