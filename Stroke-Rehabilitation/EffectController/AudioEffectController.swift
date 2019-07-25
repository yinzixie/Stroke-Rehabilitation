//
//  AudioEffectController.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 21/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioEffectController {
    var audioPlayer:AVAudioPlayer!
    
    func playSound(fileName:String, fileType:String) {
        let sound = Bundle.main.path(forResource: fileName, ofType: fileType)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }
    
    
    
    
}
