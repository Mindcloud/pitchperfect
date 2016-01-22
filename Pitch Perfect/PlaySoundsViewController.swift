//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Boschee on 1/21/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
   
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var receivedAudio:RecordedAudio!
    var audioFile: AVAudioFile!
   
    func playSound(playSpeed: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.enableRate = true
        audioPlayer.rate = playSpeed
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playSound(2.0)
    }
    
    @IBAction func playStop(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePith(1000)
    }
    
    @IBAction func playMonsterAudio(sender: UIButton) {
        playAudioWithVariablePith(-1000)
    }
    
    func playAudioWithVariablePith(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }

}