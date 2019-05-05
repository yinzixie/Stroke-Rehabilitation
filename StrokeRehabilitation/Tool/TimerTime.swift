//
//  TimerTime.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 5/5/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

public class TimerTime {
    
    static func convertSecondsToTimeString(seconds:Float,showDeci:Bool)->String {
        var result = ""
        let hour = Int(seconds / 3600)
        var hourString = String(hour)
        if(hour < 10) {
            hourString = "0\(hour)"
        }
        
        let minute = Int((Int(seconds) % 3600) / 60)
        var minuteString = String(minute)
        if(minute < 10) {
            minuteString = "0\(minute)"
        }
        
        let second = Int((Int(seconds) % 3600) % 60)
        var secondString = String(second)
        if(second < 10) {
            secondString = "0\(second)"
        }
        
        let decisecond = String(format: "%.2f",seconds).components(separatedBy: ".").last!
        if(showDeci) {
            result = "\(hourString):\(minuteString):\(secondString).\(decisecond)"
        }else {
            result = "\(hourString):\(minuteString):\(secondString)"
        }
        return result
    }
    
    static func convertSecondsToTimeWrittenString(seconds:Float)->String {
        var result = ""
        
        let hour = Int(seconds / 3600)
        let hourString = String(hour)
        
        let minute = Int((Int(seconds) % 3600) / 60)
        let minuteString = String(minute)
        
        let second = Int((Int(seconds) % 3600) % 60)
        let secondString = String(second)
        
        if(hour == 0) {
            if(minute == 0){
                result = "\(secondString) seconds"
            }else {
                result = "\(minuteString) mins \(secondString) seconds"
            }
            
        }else {
            result = "\(hourString) hours \(minuteString) mins \(secondString) seconds"
        }
        return result
    }
    
    static func returnDisplayTimerString(seconds:Float)->String {
        if(seconds == 0) {
            return "Unlimit"
        }else {
            return convertSecondsToTimeString(seconds:seconds,showDeci:true)
        }
    }
    
    static func returnDisplayGoalString(goal:Int)->String {
        if(goal == 0) {
            return "Unlimit"
        }else {
            return String(goal)
        }
    }
    
}
